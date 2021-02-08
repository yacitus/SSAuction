import React, { Component } from "react";
import gql from "graphql-tag";
import PropTypes from "prop-types";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import BootstrapTable from 'react-bootstrap-table-next';
import Moment from 'react-moment';
import './tables.css';

const PLAYER_BIDLOG_QUERY = gql`
  query PlayerBidLog($player_id: Int!) {
    player(id: $player_id) {
      id
      name
      bidLogs {
        id
        amount
        type
        team {
          id
          name
        }
        datetime
      }
    }
  }
`;

const PLAYER_BID_CHANGE_SUBSCRIPTION = gql`
  subscription PlayerInfoChange($player_id: Int!) {
    playerInfoChange(id: $player_id) {
      id
      name
      bidLogs {
        id
        amount
        type
        team {
          id
          name
        }
        datetime
      }
    }
  }
`;

class PlayerBidLog extends Component {
  render() {
    const { playerId } = this.props;

    return (
      <Query
        query={PLAYER_BIDLOG_QUERY}
        variables={{ player_id: parseInt(playerId, 10) }}>
        {({ data, loading, error, refetch, subscribeToMore }) => {
          this.refetch = refetch;
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <PlayerBidLogTable
              playerId={ playerId }
              bidLogs={ data.player.bidLogs }
              subscribeToPlayerInfoChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

class PlayerBidLogTable extends Component {
  static propTypes = {
    playerId: PropTypes.number.isRequired,
    bidLogs: PropTypes.array.isRequired,
    subscribeToPlayerInfoChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToPlayerInfoChanges({
      document: PLAYER_BID_CHANGE_SUBSCRIPTION,
      variables: { player_id: this.props.playerId },
      updateQuery: this.handlePlayerInfoChange
    });
  }

  handlePlayerInfoChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    return {
      player: {
        ...prev.player,
        bidLogs: subscriptionData.data.playerInfoChange.bidLogs
      }
    };
  };

  render() {
    const getColumns = () => {
      let columns = [{
        dataField: 'datetime',
        text: 'When',
        formatter: timestampFormatter,
        sort: true
      }, {
        dataField: 'team.name',
        text: 'Team',
        formatter: teamNameFormatter,
        sort: true
      }, {
        dataField: 'amount',
        text: 'Amount',
        formatter: dollarsFormatter,
        sort: true
      }, {
        dataField: 'type',
        text: 'Bid Type',
        formatter: bidTypeFormatter,
        sort: true,
      }];

      return columns;
    }

    function timestampFormatter(cell, row) {
      return ( <Moment format="llll">{cell}</Moment> );
    }

    function teamNameFormatter(cell, row) {
      return ( <a href={'/team/' + row.team.id}>{cell}</a> );
    }

    function dollarsFormatter(cell, row) {
      if (cell === null) return '';
      return (`$${cell}`);
    }

    function bidTypeFormatter(cell, row) {
      if (cell === null) return '';
      if (cell === 'N') return 'nomination';
      if (cell === 'B') return 'bid';
      if (cell === 'U') return 'bid under hidden high bid';
      if (cell === 'H') return 'hidden high bid';
      if (cell === 'R') return 'rostered';
      return '';
    }

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'green',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Bids</h3>;

    const defaultSortedBy = [{
      dataField: "bidLogs.datetime",
      order: "asc"
    }];

    return (
      <div>
        <BootstrapTable
          bootstrap4={ true }
          caption={ <CaptionElement /> }
          keyField='id'
          data={ this.props.bidLogs }
          columns={ getColumns() }
          striped
          defaultSorted={defaultSortedBy}
        />
      </div>
    );
  }
}

export default PlayerBidLog;
