import React, { Component } from "react";
import gql from "graphql-tag";
import PropTypes from "prop-types";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Countdown from "../components/Countdown";
import BootstrapTable from 'react-bootstrap-table-next';
import BidButton from "../components/BidButton";
import './tables.css';

const TEAM_BIDS_QUERY = gql`
  query TeamBids($team_id: Int!) {
    team(id: $team_id) {
      id
      bids {
        id
        bidAmount
        hiddenHighBid
        expiresAt
        player {
          id
          ssnum
          name
          position
        }
      }
    }
  }
`;

const TEAM_BID_CHANGE_SUBSCRIPTION = gql`
  subscription TeamBidChange($team_id: Int!) {
    teamBidChange(id: $team_id) {
      id
      bids {
        id
        bidAmount
        hiddenHighBid
        expiresAt
        player {
          id
          ssnum
          name
          position
        }
      }
    }
  }
`;

class TeamAuthorizedBids extends Component {
  componentWillReceiveProps(props) {
    const { auctionActive } = this.props;
    if (props.auctionActive !== auctionActive) {
      this.refetch();
    }
  }

  render() {
    const { teamId } = this.props;
    const { auctionId } = this.props;

    return (
      <Query
        query={TEAM_BIDS_QUERY}
        variables={{ team_id: parseInt(teamId, 10) }}>
        {({ data, loading, error, refetch, subscribeToMore }) => {
          this.refetch = refetch;
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <TeamAuthorizedBidsTable
              teamId={ teamId }
              auctionId={ auctionId }
              bids={ data.team.bids }
              subscribeToTeamBidChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

class TeamAuthorizedBidsTable extends Component {
  static propTypes = {
    teamId: PropTypes.number.isRequired,
    auctionId: PropTypes.number.isRequired,
    bids: PropTypes.array.isRequired,
    subscribeToTeamBidChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToTeamBidChanges({
      document: TEAM_BID_CHANGE_SUBSCRIPTION,
      variables: { team_id: parseInt(this.props.teamId, 10) },
      updateQuery: this.handleTeamBidChange
    });
  }

  handleTeamBidChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    return {
      team: {
        ...prev.team,
        bids: subscriptionData.data.teamBidChange.bids
      }
    };
  };

  render() {
    const { auctionId } = this.props;
    const { bids } = this.props;

    function dollarsFormatter(cell, row) {
      if ( cell == null ) {
          return ("");
      } else {
        return (`$${cell}`);
      }
    }

    function countdownFormatter(cell, row) {
      if (cell == null) {
        return "";
      }
      else {
        return (
            <Countdown
            expires={ cell }
            auctionId={ auctionId }
          />
        );
      }
    }

    const bidButtonFormatter = (cell, row) => {
      return (
        <BidButton
          row={ row }
          auctionId={ auctionId }
          teamId={ this.props.teamId }
          teamPage={ true }
        />
      );
    }

    function playerNameFormatter(cell, row) {
      return ( <a href={'/player/' + row.player.id}>{cell}</a> );
    }

    const columns = [{
      dataField: 'player.ssnum',
      text: 'Scoresheet num',
      sort: true
    }, {
      dataField: 'player.name',
      text: 'Player',
      formatter: playerNameFormatter,
      sort: true
    }, {
      dataField: 'player.position',
      text: 'Position',
      sort: true
    }, {
      dataField: 'bidAmount',
      text: '$ Bid',
      sort: true,
      formatter: dollarsFormatter
    }, {
      dataField: 'hiddenHighBid',
      text: '$ Hidden Max Bid',
      sort: true,
      formatter: dollarsFormatter
    }, {
      dataField: 'expiresAt',
      text: 'Expires In',
      sort: true,
      formatter: countdownFormatter
    }, {
      text: '',
      formatter: bidButtonFormatter,
    }];

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'green',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Bids</h3>;

    return (
      <div>
        <BootstrapTable
          bootstrap4={ true }
          caption={ <CaptionElement /> }
          keyField='id'
          data={ bids }
          columns={ columns }
          striped />
      </div>
    );
  }
}

export default TeamAuthorizedBids;
