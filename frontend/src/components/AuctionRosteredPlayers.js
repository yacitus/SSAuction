import React, { Component } from "react";
import gql from "graphql-tag";
import PropTypes from "prop-types";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
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

    function dollarsFormatter(cell, row) {
        return (`$${cell}`);
    }

    const columns = [{
      dataField: 'team.name',
      text: 'Team'
    }, {
      dataField: 'cost',
      text: 'Cost',
      formatter: dollarsFormatter
    }, {
      dataField: 'player.name',
      text: 'Player'
    }, {
      dataField: 'player.ssnum',
      text: 'Scoresheet num',
    }];

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'green',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Rostered Players</h3>;

    return (
      <Container>
        <BootstrapTable
          bootstrap4={ true }
          caption={ <CaptionElement /> }
          keyField='id'
          data={ rosteredPlayers }
          columns={ columns }
          striped />
      </Container>
    );
  }
}

export default AuctionRosteredPlayers;
