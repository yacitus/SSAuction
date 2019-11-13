import React, { Component } from "react";
import 'moment';
import gql from "graphql-tag";
import PropTypes from "prop-types";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import BootstrapTable from 'react-bootstrap-table-next';

const TEAM_ROSTERED_PLAYERS_QUERY = gql`
  query TeamRosteredPlayers($team_id: Int!) {
    team(id: $team_id) {
      id
      rosteredPlayers {
        cost
        player {
          id
          name
          ssnum
        }
      }
    }
  }
`;

const TEAM_ROSTER_CHANGE_SUBSCRIPTION = gql`
  subscription TeamRosterChange($team_id: Int!) {
    teamRosterChange(id: $team_id) {
      id
      rosteredPlayers {
        cost
        player {
          id
          name
          ssnum
        }
      }
    }
  }
`;

class TeamRosteredPlayers extends Component {
  render() {
    const { teamId } = this.props;

    return (
      <Query
        query={TEAM_ROSTERED_PLAYERS_QUERY}
        variables={{ team_id: parseInt(teamId, 10) }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <TeamRosteredPlayersTable
              teamId={ teamId }
              rosteredPlayers={ data.team.rosteredPlayers }
              subscribeToTeamRosterChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

class TeamRosteredPlayersTable extends Component {
  static propTypes = {
    teamId: PropTypes.number.isRequired,
    rosteredPlayers: PropTypes.array.isRequired,
    subscribeToTeamRosterChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToTeamRosterChanges({
      document: TEAM_ROSTER_CHANGE_SUBSCRIPTION,
      variables: { team_id: parseInt(this.props.teamId, 10) },
      updateQuery: this.handleTeamRosterChange
    });
  }

  handleTeamRosterChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    return {
      team: {
        ...prev.team,
        rosteredPlayers: subscriptionData.data.teamRosterChange.rosteredPlayers
      }
    };
  };

  render() {
    const { rosteredPlayers } = this.props;

    function dollarsFormatter(cell, row) {
        return (`$${cell}`);
    }

    const columns = [{
      dataField: 'cost',
      text: 'Cost',
      formatter: dollarsFormatter
    }, {
      dataField: 'player.name',
      text: 'Player',
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

export default TeamRosteredPlayers;
