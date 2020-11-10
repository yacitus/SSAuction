import React, { Component } from "react";
import gql from "graphql-tag";
import PropTypes from "prop-types";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import BootstrapTable from 'react-bootstrap-table-next';
import './tables.css';

const AUCTION_ROSTERED_PLAYERS_QUERY = gql`
  query AuctionRosteredPlayers($auction_id: Int!) {
    auction(id: $auction_id) {
      id
      rosteredPlayers {
        cost
        player {
          id
          name
          ssnum
        }
        team {
          id
          name
        }
      }
    }
  }
`;

const AUCTION_ROSTER_CHANGE_SUBSCRIPTION = gql`
  subscription AuctionRosterChange($auction_id: Int!) {
    auctionRosterChange(id: $auction_id) {
      id
      rosteredPlayers {
        cost
        player {
          id
          name
          ssnum
        }
        team {
          id
          name
        }
      }
    }
  }
`;

class AuctionRosteredPlayers extends Component {
  render() {
    const { auctionId } = this.props;

    return (
      <Query
        query={AUCTION_ROSTERED_PLAYERS_QUERY}
        variables={{ auction_id: parseInt(auctionId, 10) }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <AuctionRosteredPlayersTable
              auctionId={ auctionId }
              rosteredPlayers={ data.auction.rosteredPlayers }
              subscribeToAuctionRosterChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

class AuctionRosteredPlayersTable extends Component {
  static propTypes = {
    auctionId: PropTypes.number.isRequired,
    rosteredPlayers: PropTypes.array.isRequired,
    subscribeToAuctionRosterChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToAuctionRosterChanges({
      document: AUCTION_ROSTER_CHANGE_SUBSCRIPTION,
      variables: { auction_id: this.props.auctionId },
      updateQuery: this.handleAuctionRosterChange
    });
  }

  handleAuctionRosterChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    return {
      auction: {
        ...prev.auction,
        bids: subscriptionData.data.auctionRosterChange.rosteredPlayers
      }
    };
  };

  render() {
    const { rosteredPlayers } = this.props;

    function nameFormatter(cell, row) {
      return ( <a href={'/team/' + row.team.id}>{cell}</a> );
    }

    function dollarsFormatter(cell, row) {
        return (`$${cell}`);
    }

    const columns = [{
      dataField: 'team.name',
      text: 'Team',
      formatter: nameFormatter,
      sort: true
    }, {
      dataField: 'cost',
      text: 'Cost',
      formatter: dollarsFormatter,
      sort: true
    }, {
      dataField: 'player.name',
      text: 'Player',
      sort: true
    }, {
      dataField: 'player.ssnum',
      text: 'Scoresheet num',
      sort: true
    }];

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'green',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Rostered Players</h3>;

    return (
      <div>
        <BootstrapTable
          bootstrap4={ true }
          caption={ <CaptionElement /> }
          keyField='id'
          data={ rosteredPlayers }
          columns={ columns }
          striped />
      </div>
    );
  }
}

export default AuctionRosteredPlayers;
