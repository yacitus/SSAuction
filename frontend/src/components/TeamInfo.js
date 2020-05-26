import React, { Component } from "react";
import gql from "graphql-tag";
import PropTypes from "prop-types";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import BootstrapTable from 'react-bootstrap-table-next';
import Moment from 'react-moment';

const TEAM_INFO_QUERY = gql`
  query TeamInfo($team_id: Int!) {
    team(id: $team_id) {
      id
      name
      dollarsSpent
      dollarsBid
      dollarsRemainingForBids
      unusedNominations
      timeOfLastNomination
      numRosteredPlayers
    }
  }
`;

const TEAM_INFO_CHANGE_SUBSCRIPTION = gql`
  subscription TeamInfoChange($team_id: Int!) {
    teamInfoChange(id: $team_id) {
      id
      name
      dollarsSpent
      dollarsBid
      dollarsRemainingForBids
      unusedNominations
      timeOfLastNomination
      numRosteredPlayers
    }
  }
`;

class TeamInfo extends Component {
  render() {
    const { teamId } = this.props;

    return (
      <Query
        query={TEAM_INFO_QUERY}
        variables={{ team_id: parseInt(teamId, 10) }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <TeamInfoTable
              teamId={ teamId }
              team={ data.team }
              subscribeToTeamInfoChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

class TeamInfoTable extends Component {
  static propTypes = {
    teamId: PropTypes.string.isRequired,
    team: PropTypes.object.isRequired,
    subscribeToTeamInfoChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToTeamInfoChanges({
      document: TEAM_INFO_CHANGE_SUBSCRIPTION,
      variables: { team_id: parseInt(this.props.teamId, 10) },
      updateQuery: this.handleTeamInfoChange
    });
  }

  handleTeamInfoChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    return {
      team: {
        ...prev.team,
        name: subscriptionData.data.teamInfoChange.name,
        dollarsSpent: subscriptionData.data.teamInfoChange.dollarsSpent,
        dollarsBid: subscriptionData.data.teamInfoChange.dollarsBid,
        dollarsRemainingForBids: subscriptionData.data.teamInfoChange.dollarsRemainingForBids,
        unusedNominations: subscriptionData.data.teamInfoChange.unusedNominations,
        timeOfLastNomination: subscriptionData.data.teamInfoChange.timeOfLastNomination
      }
    };
  };

  render() {
    const { team } = this.props;

    function valueFormatter(cell, row) {
      if (row.id === 4) {
        if (cell === "null") {
          return '';
        } else {
          return (<Moment format="llll">
                    {cell}
                  </Moment>);
        }
      } else {
        return (`${cell}`);
      }
    }

    const columns = [{
      dataField: 'label',
      text: ''
    }, {
      dataField: 'value',
      text: '',
      formatter: valueFormatter
    }];

    const data = [{
      label: '$ Spent',
      value: `$${team.dollarsSpent}`,
      id: 0
    }, {
      label: '$ Bid',
      value: `$${team.dollarsBid}`,
      id: 1
    }, {
      label: '$ Remaining for Bids',
      value: `$${team.dollarsRemainingForBids}`,
      id: 2
    }, {
      label: 'Unused Nominations',
      value: `${team.unusedNominations}`,
      id: 3
    }, {
      label: 'Time of Last Nomination',
      value: `${team.timeOfLastNomination}`,
      id: 4
    }, {
      label: 'Players Rostered',
      value: `${team.numRosteredPlayers}`,
      id: 5
    }];

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'green',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Team Info</h3>;

    return (
      <div>
        <BootstrapTable
          bootstrap4={ true }
          caption={ <CaptionElement /> }
          keyField='id'
          data={ data }
          columns={ columns }
          striped
          headerClasses="team-info-header" />
      </div>
    );
  }
}

export default TeamInfo;
