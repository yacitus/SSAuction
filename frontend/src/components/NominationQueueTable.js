import React, { Component } from "react";
import gql from "graphql-tag";
import PropTypes from "prop-types";
import { Query } from "react-apollo";
import { Mutation } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import BootstrapTable from 'react-bootstrap-table-next';
import Button from 'react-bootstrap/Button'

const TEAM_NOMINATION_QUEUE_QUERY = gql`
  query TeamNominationQueue($team_id: Int!) {
    team(id: $team_id) {
      id
      nominationQueue {
        rank
        player {
          id
          name
          ssnum
          position
        }
      }
    }
  }
`;

const SUBMIT_BID_MUTATION = gql`
  mutation SubmitBid(
    $auction_id: Int!
    $team_id: Int!
    $player_id: Int!
    $bid_amount: Int!
  ) {
    submitBid(auctionId: $auction_id,
            teamId: $team_id,
            playerId: $player_id,
            bidAmount: $bid_amount) {
      id
      expiresAt
    }
  }
`;

const TEAM_NOMINATION_QUEUE_SUBSCRIPTION = gql`
  subscription TeamNominationQueueChange($team_id: Int!) {
    nominationQueueChange(id: $team_id) {
      id
      nominationQueue {
        rank
        player {
          id
          name
          ssnum
          position
        }
      }
    }
  }
`;

class NominationQueueTable extends Component {
  render() {
    const { teamId } = this.props;
    const { auctionId } = this.props;

    return (
      <Query
        query={TEAM_NOMINATION_QUEUE_QUERY}
        variables={{ team_id: teamId }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <NominationQueueBootstrapTable
              auctionId={ auctionId }
              teamId={ teamId }
              nominationQueue={ data.team.nominationQueue }
              subscribeToNominationQueueChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

class NominateButton extends Component {
  render() {
    const { auctionId } = this.props;
    const { teamId } = this.props;
    const playerId = parseInt(this.props.row.player.id, 10);
    const bidAmount = 1;

    return (
      <Mutation
        mutation={SUBMIT_BID_MUTATION}
        variables={{
          auction_id: auctionId,
          team_id: teamId,
          player_id: playerId,
          bid_amount: bidAmount
        }}
      >
        {(submitBid, { loading, error }) => (
          <div>
            <Error error={error} />
            <Button
              disabled={loading}
              onClick={submitBid}
              variant="outline-success">
              Nominate
            </Button>
          </div>
        )}
      </Mutation>
    );
  }
}

class NominationQueueBootstrapTable extends Component {
  static propTypes = {
    auctionId: PropTypes.number.isRequired,
    teamId: PropTypes.number.isRequired,
    nominationQueue: PropTypes.array.isRequired,
    subscribeToNominationQueueChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToNominationQueueChanges({
      document: TEAM_NOMINATION_QUEUE_SUBSCRIPTION,
      variables: { team_id: this.props.teamId },
      updateQuery: this.handleNominationQueueChange
    });
  }

  handleNominationQueueChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    return {
      team: {
        ...prev.team,
        nominationQueue: subscriptionData.data.nominationQueueChange.nominationQueue
      }
    };
  };

  render() {
    const { auctionId } = this.props;
    const { teamId } = this.props;
    const { nominationQueue } = this.props;

    function buttonFormatter(cell, row) {
      return (
        <NominateButton row={row} auctionId={auctionId} teamId={teamId}/>
      );
    }

    const queue_columns = [{
      dataField: 'player.ssnum',
      text: 'Scoresheet num',
    }, {
      dataField: 'player.name',
      text: 'Player',
    }, {
      dataField: 'player.position',
      text: 'Position',
    }, {
      text: 'Nominate',
      formatter: buttonFormatter
    }];

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'purple',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Nomination Queue</h3>;

    return (
      <BootstrapTable
        bootstrap4={ true }
        caption={ <CaptionElement /> }
        keyField='player.ssnum'
        data={ nominationQueue }
        columns={ queue_columns }
        striped
        hover />
    );
  }
}

export default NominationQueueTable;
