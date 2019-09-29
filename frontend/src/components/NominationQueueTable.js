import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
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
          position
        }
      }
    }
  }
`;

class NominationQueueTable extends Component {
  componentWillReceiveProps(props) {
    const { refresh } = this.props;
    if (props.refresh !== refresh) {
      this.refetch();
    }
  }

  render() {
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
        variables={{ team_id: this.props.teamId }}
        fetchPolicy={'no-cache'}>
        {({ data, loading, error, refetch }) => {
          this.refetch = refetch;
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
    );
  }
}

export default NominationQueueTable;
