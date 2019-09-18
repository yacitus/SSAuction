import React, { Component } from "react";
import 'moment';
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import BootstrapTable from 'react-bootstrap-table-next';

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
  render() {
    const { teamId } = this.props;

    function dollarsFormatter(cell, row) {
        return (`$${cell}`);
    }

    var moment = require('moment');

    function timestampFormatter(cell, row) {
      if (cell == null) {
        return cell;
      } else {
        return (moment(cell).utcOffset(cell).local().format('llll'));
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
      text: 'Expires',
      formatter: timestampFormatter
    }];

    return (
      <Query
        query={TEAM_BIDS_QUERY}
        variables={{ team_id: parseInt(teamId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <Container>
              <BootstrapTable
                bootstrap4={ true }
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
