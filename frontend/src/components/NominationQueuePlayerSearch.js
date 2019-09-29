import React, { Component } from "react";
import 'moment';
import gql from "graphql-tag";
import { Query } from "react-apollo";
import { Mutation } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import BootstrapTable from 'react-bootstrap-table-next';
import paginationFactory from 'react-bootstrap-table2-paginator';
import ToolkitProvider, { Search } from 'react-bootstrap-table2-toolkit';
import Button from 'react-bootstrap/Button'

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
    const playerId = parseInt(this.props.row.id, 10);

    return (
      <Mutation
        mutation={ADD_TO_NOMINATION_QUEUE_MUTATION}
        variables={{
          player_id: playerId,
          team_id: teamId
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

class NominationQueuePlayerSearch extends Component {
  componentWillReceiveProps(props) {
    const { refresh } = this.props;
    if (props.refresh !== refresh) {
      this.refetch();
    }
  }

  render() {
    const { teamId } = this.props;

    const { SearchBar } = Search;

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

    return (
      <Query
        query={TEAM_QUEUEABLE_PLAYERS_QUERY}
        variables={{ team_id: teamId }}
        fetchPolicy={'no-cache'}>
        {({ data, loading, error, refetch }) => {
          this.refetch = refetch;
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
    );
  }
}

export default NominationQueuePlayerSearch;
