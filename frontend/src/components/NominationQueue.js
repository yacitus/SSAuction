import React, { Component } from "react";
import 'moment';
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import BootstrapTable from 'react-bootstrap-table-next';

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
        }
      }
    }
  }
`;

class NominationQueue extends Component {
  render() {
    const { teamId } = this.props;

    const columns = [{
      dataField: 'rank',
      text: 'Order'
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
        Nomination Queue</h3>;

    return (
      <Query
        query={TEAM_NOMINATION_QUEUE_QUERY}
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
                data={ data.team.nominationQueue }
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

export default NominationQueue;
