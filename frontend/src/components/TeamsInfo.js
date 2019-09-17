import React, { Component } from "react";
import 'moment';
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import BootstrapTable from 'react-bootstrap-table-next';

const TEAMS_INFO_QUERY = gql`
  query TeamsInfo($auction_id: Int!) {
    teams(auctionId: $auction_id) {
      id
      name
      dollarsSpent
      dollarsBid
      unusedNominations
      timeOfLastNomination
    }
  }
`;

class TeamsInfo extends Component {
  render() {
    const { auctionId } = this.props;

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
      dataField: 'name',
      text: 'Team'
    }, {
      dataField: 'dollarsSpent',
      text: '$ Spent',
      formatter: dollarsFormatter
    }, {
      dataField: 'dollarsBid',
      text: '$ Bid',
      formatter: dollarsFormatter
    }, {
      dataField: 'unusedNominations',
      text: 'Unused Nominations',
    }, {
      dataField: 'timeOfLastNomination',
      text: 'Time of Last Nomination',
      formatter: timestampFormatter
    }];

    const rowEvents = {
      onClick: (e, row, rowIndex) => {
        window.location = `/team/${row.id}`
      }
    };

    return (
      <Query
        query={TEAMS_INFO_QUERY}
        variables={{ auction_id: parseInt(auctionId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <Container>
              <BootstrapTable
                bootstrap4={ true }
                keyField='id'
                data={ data.teams }
                columns={ columns }
                rowEvents={ rowEvents }
                striped
                hover />
            </Container>
          );
        }}
      </Query>
    );
  }
}

export default TeamsInfo;
