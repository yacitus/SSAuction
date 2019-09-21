import React, { Component } from "react";
import gql from "graphql-tag";
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

class AuctionRosteredPlayers extends Component {
  render() {
    const { auctionId } = this.props;

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
                   color: 'purple',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Rostered Players</h3>;

    return (
      <Query
        query={AUCTION_ROSTERED_PLAYERS_QUERY}
        variables={{ auction_id: parseInt(auctionId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <Container>
              <BootstrapTable
                bootstrap4={ true }
                caption={ <CaptionElement /> }
                keyField='id'
                data={ data.auction.rosteredPlayers }
                columns={ columns }
                striped
                hover />
            </Container>
          );
        }}
      </Query>
    );
  }
}

export default AuctionRosteredPlayers;
