import React, { Component } from "react";
import 'moment';
import gql from "graphql-tag";
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

class TeamRosteredPlayers extends Component {
  render() {
    const { teamId } = this.props;

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
      <Query
        query={TEAM_ROSTERED_PLAYERS_QUERY}
        variables={{ team_id: parseInt(teamId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <Container>
              <BootstrapTable
                bootstrap4={ true }
                caption={ <CaptionElement /> }
                keyField='id'
                data={ data.team.rosteredPlayers }
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

export default TeamRosteredPlayers;
