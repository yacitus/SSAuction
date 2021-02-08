import React, { Component } from "react";
import gql from "graphql-tag";
import PropTypes from "prop-types";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import BootstrapTable from 'react-bootstrap-table-next';

const PLAYER_INFO_QUERY = gql`
  query PlayerInfo($player_id: Int!) {
    player(id: $player_id) {
      id
      name
      ssnum
      position
      rostered {
        id
        cost
        team {
          id
          name
        }
      }
    }
  }
`;

const PLAYER_INFO_CHANGE_SUBSCRIPTION = gql`
  subscription PlayerInfoChange($player_id: Int!) {
    playerInfoChange(id: $player_id) {
      id
      name
      ssnum
      position
      rostered {
        id
        cost
        team {
          id
          name
        }
      }
    }
  }
`;

class PlayerInfo extends Component {
  render() {
    const { playerId } = this.props;

    return (
      <Query
        query={PLAYER_INFO_QUERY}
        variables={{ player_id: parseInt(playerId, 10) }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <PlayerInfoTable
              playerId={ playerId }
              player={ data.player }
              subscribeToPlayerInfoChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

class PlayerInfoTable extends Component {
  static propTypes = {
    playerId: PropTypes.string.isRequired,
    player: PropTypes.object.isRequired,
    subscribeToPlayerInfoChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToPlayerInfoChanges({
      document: PLAYER_INFO_CHANGE_SUBSCRIPTION,
      variables: { player_id: parseInt(this.props.playerId, 10) },
      updateQuery: this.handlePlayerInfoChange
    });
  }

  handlePlayerInfoChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    return {
      player: {
        ...prev.player,
        name: subscriptionData.data.playerInfoChange.name,
        ssnum: subscriptionData.data.playerInfoChange.ssnum,
        position: subscriptionData.data.playerInfoChange.position,
        rostered: subscriptionData.data.playerInfoChange.rostered
      }
    };
  };

  render() {
    const { player } = this.props;

    function valueFormatter(cell, row) {
      if (row.id === 3) {
        if (cell === "null") {
          return '';
        } else {
          return ( <a href={'/team/' + player.rostered.team.id}>{cell}</a> );
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

    let data = [{
      label: 'Scoresheet Num',
      value: `${player.ssnum}`,
      id: 0
    }, {
      label: 'Name',
      value: `${player.name}`,
      id: 1
    }, {
      label: 'Position',
      value: `${player.position}`,
      id: 2
    }];

    if (player.rostered != null) {
      data.push({
        label: 'Rostered By',
        value: `${player.rostered.team.name}`,
        id: 3
      });
      data.push({
        label: 'Purchase Price',
        value: `$${player.rostered.cost}`,
        id: 4
      });
    }

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'green',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Player Info</h3>;

    return (
      <div>
        <BootstrapTable
          bootstrap4={ true }
          caption={ <CaptionElement /> }
          keyField='id'
          data={ data }
          columns={ columns }
          striped
          headerClasses="player-info-header" />
      </div>
    );
  }
}

export default PlayerInfo;
