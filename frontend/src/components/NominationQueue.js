import React, { Component } from "react";
import 'moment';
import gql from "graphql-tag";
import { Query } from "react-apollo";
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
        <Button variant="outline-success">Add</Button>
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
                  keyField='id'
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
                bootstrap4={ true }
                keyField="id"
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
