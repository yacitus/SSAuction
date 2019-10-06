import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Countdown from "../components/Countdown";
import Container from "react-bootstrap/Container";
import BootstrapTable from 'react-bootstrap-table-next';
import './tables.css';

const TEAM_BIDS_QUERY = gql`
  query TeamBids($team_id: Int!) {
    team(id: $team_id) {
      id
      bids {
        id
        bidAmount
        expiresAt
        player {
          id
          ssnum
          name
        }
      }
    }
  }
`;

class TeamBids extends Component {
  componentWillReceiveProps(props) {
    const { auctionActive } = this.props;
    if (props.auctionActive !== auctionActive) {
      this.refetch();
    }
  }

  render() {
    const { teamId } = this.props;
    const { auctionId } = this.props;

    function dollarsFormatter(cell, row) {
        return (`$${cell}`);
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

    const columns = [{
      dataField: 'player.name',
      text: 'Player'
    }, {
      dataField: 'player.ssnum',
      text: 'Scoresheet num',
    }, {
      dataField: 'bidAmount',
      text: '$ Bid',
      formatter: dollarsFormatter
    }, {
      dataField: 'expiresAt',
      text: 'Expires In',
      formatter: countdownFormatter
    }];

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'purple',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Bids</h3>;

    return (
      <Query
        query={TEAM_BIDS_QUERY}
        variables={{ team_id: parseInt(teamId, 10) }}>
        {({ data, loading, error, refetch }) => {
          this.refetch = refetch;
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <Container>
              <BootstrapTable
                bootstrap4={ true }
                caption={ <CaptionElement /> }
                keyField='id'
                data={ data.team.bids }
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

export default TeamBids;
