import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import { Mutation } from "react-apollo";
import PropTypes from "prop-types";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Button from 'react-bootstrap/Button'

const TEAM_NOMINATIONS_OPEN_QUERY = gql`
  query TeamNominationsOpen($team_id: Int!) {
    team(id: $team_id) {
      id
      nominationsOpen
    }
  }
`;

const TEAM_NOMINATIONS_OPEN_SUBSCRIPTION = gql`
  subscription TeamNominationsOpenChange($team_id: Int!) {
    nominationQueueChange(id: $team_id) {
      id
      nominationsOpen
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

class NominateButton extends Component {
  render() {
    const { auctionId } = this.props;
    const { teamId } = this.props;
    const playerId = parseInt(this.props.row.player.id, 10);
    const bidAmount = 1;

    return (
      <Query
        query={TEAM_NOMINATIONS_OPEN_QUERY}
        variables={{ team_id: teamId }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <NominateButtonMutator
              auctionId={ auctionId }
              teamId={ teamId }
              playerId={ playerId }
              bidAmount={ bidAmount }
              nominationsOpen={ data.team.nominationsOpen }
              subscribeToNominationsOpenChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

class NominateButtonMutator extends Component {
  static propTypes = {
    auctionId: PropTypes.number.isRequired,
    teamId: PropTypes.number.isRequired,
    playerId: PropTypes.number.isRequired,
    bidAmount: PropTypes.number.isRequired,
    nominationsOpen: PropTypes.bool.isRequired,
    subscribeToNominationsOpenChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToNominationsOpenChanges({
      document: TEAM_NOMINATIONS_OPEN_SUBSCRIPTION,
      variables: { team_id: this.props.teamId },
      updateQuery: this.handleNominationsOpenChange
    });
  }

  handleNominationsOpenChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    return {
      team: {
        ...prev.team,
        nominationsOpen: subscriptionData.data.nominationQueueChange.nominationsOpen
      }
    };
  };

  render() {
    const { auctionId } = this.props;
    const { teamId } = this.props;
    const { playerId } = this.props;
    const { bidAmount } = this.props;
    const { nominationsOpen } = this.props;

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
              disabled={ loading || !nominationsOpen }
              onClick={ submitBid }
              variant="outline-success">
              Nominate
            </Button>
          </div>
        )}
      </Mutation>
    );
  }
}

export default NominateButton;
