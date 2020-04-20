import React, { Component } from "react";
import 'moment';
import gql from "graphql-tag";
import PropTypes from "prop-types";
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

const TEAMS_INFO_CHANGE_SUBSCRIPTION = gql`
  subscription AuctionTeamsInfoChange($auction_id: Int!) {
    auctionTeamsInfoChange(id: $auction_id) {
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

    return (
      <Query
        query={TEAMS_INFO_QUERY}
        variables={{ auction_id: parseInt(auctionId, 10) }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <TeamsInfoTable
              auctionId={ auctionId }
              teams={ data.teams }
              subscribeToTeamsInfoChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

class TeamsInfoTable extends Component {
  static propTypes = {
    auctionId: PropTypes.number.isRequired,
    teams: PropTypes.array.isRequired,
    subscribeToTeamsInfoChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToTeamsInfoChanges({
      document: TEAMS_INFO_CHANGE_SUBSCRIPTION,
      variables: { auction_id: this.props.auctionId },
      updateQuery: this.handleTeamsInfoChange
    });
  }

  handleTeamsInfoChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    return {
      teams: {
        ...prev.teams,
        ...subscriptionData.data.teamsInfoChange.teams,
      }
    };
  };

  render() {
    const { teams } = this.props;

    function nameFormatter(cell, row) {
      return ( <a href={'/team/' + row.id}>{cell}</a> );
    }

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
      text: 'Team',
      formatter: nameFormatter
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

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'green',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Teams</h3>;

    const rowEvents = {
      onClick: (e, row, rowIndex) => {
        window.location = `/team/${row.id}`
      }
    };

    return (
      <Container>
        <BootstrapTable
          bootstrap4={ true }
          caption={ <CaptionElement /> }
          keyField='id'
          data={ teams }
          columns={ columns }
          rowEvents={ rowEvents }
          striped
          hover />
      </Container>
    );
  }
}

export default TeamsInfo;
