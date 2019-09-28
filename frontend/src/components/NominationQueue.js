import React, { Component } from "react";
import 'moment';
import gql from "graphql-tag";
import { Query } from "react-apollo";
import { Mutation } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import BootstrapTable from 'react-bootstrap-table-next';
import paginationFactory from 'react-bootstrap-table2-paginator';
import ToolkitProvider, { Search } from 'react-bootstrap-table2-toolkit';
import Button from 'react-bootstrap/Button'

const TEAM_NOMINATION_QUEUE_QUERY = gql`
  query TeamNominationQueue($team_id: Int!) {
    team(id: $team_id) {
      id
      nominationQueue {
        rank
        player {
          id
          name
          ssnum
          position
        }
      }
    }
  }
`;

const TEAM_QUEUEABLE_PLAYERS_QUERY = gql`
  query TeamQueueablePlayers($team_id: Int!) {
    queueablePlayers(teamId: $team_id) {
      id
      name
      ssnum
      position
    }
  }
`;

const ADD_TO_NOMINATION_QUEUE_MUTATION = gql`
  mutation AddToNominationQueue(
    $player_id: Int!
    $team_id: Int!
  ) {
    addToNominationQueue(playerId: $player_id, teamId: $team_id) {
      rank
      player {
        id
        ssnum
        name
      }
    }
  }
`;

class AddButton extends Component {
  render() {
    const { teamId } = this.props;
    const playerId = this.props.row.id;

    return (
      <Mutation
        mutation={ADD_TO_NOMINATION_QUEUE_MUTATION}
        variables={{
          player_id: parseInt(playerId, 10),
          team_id: parseInt(teamId, 10)
        }}
      >
        {(addToQueue, { loading, error }) => (
          <div>
            <Error error={error} />
            <Button
              disabled={loading}
              onClick={addToQueue}
              variant="outline-success">
              Add
            </Button>
          </div>
        )}
      </Mutation>
    );
  }
}

class NominationQueue extends Component {
  render() {
    const { teamId } = this.props;

    const { SearchBar } = Search;

    const queue_columns = [{
      dataField: 'player.ssnum',
      text: 'Scoresheet num',
    }, {
      dataField: 'player.name',
      text: 'Player',
    }, {
      dataField: 'player.position',
      text: 'Position',
    }];

    function buttonFormatter(cell, row) {
      return (
        <AddButton row={row} teamId={teamId}/>
      );
    }

    const players_columns = [{
      dataField: 'ssnum',
      text: 'Scoresheet num',
    }, {
      dataField: 'name',
      text: 'Player',
    }, {
      dataField: 'position',
      text: 'Position',
    }, {
      text: 'Add To Queue',
      formatter: buttonFormatter
    }];

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'purple',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Nomination Queue</h3>;

    return (
      <Container>
        <Query
          query={TEAM_NOMINATION_QUEUE_QUERY}
          variables={{ team_id: parseInt(teamId, 10) }}>
          {({ data, loading, error }) => {
            if (loading) return <Loading />;
            if (error) return <Error error={error} />;
            return (
                <BootstrapTable
                  bootstrap4={ true }
                  caption={ <CaptionElement /> }
                  keyField='player.ssnum'
                  data={ data.team.nominationQueue }
                  columns={ queue_columns }
                  striped
                  hover />
            );
          }}
        </Query>
        <Query
          query={TEAM_QUEUEABLE_PLAYERS_QUERY}
          variables={{ team_id: parseInt(teamId, 10) }}>
          {({ data, loading, error }) => {
            if (loading) return <Loading />;
            if (error) return <Error error={error} />;
            return (
              <ToolkitProvider
                keyField="ssnum"
                bootstrap4={ true }
                data={ data.queueablePlayers }
                columns={ players_columns }
                striped
                hover
                search
              >
              {
                props => (
                  <div>
                    <h3>Search for a Scoresheet num, name, or position:</h3>
                    <SearchBar { ...props.searchProps } />
                    <hr />
                    <BootstrapTable
                      { ...props.baseProps }
                      pagination={ paginationFactory() }
                    />
                  </div>
                )
              }
              </ToolkitProvider>
            );
          }}
        </Query>
      </Container>
    );
  }
}

export default NominationQueue;
