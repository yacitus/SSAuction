import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import PropTypes from "prop-types";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Header from "../components/Header";
import PlayerInfo from "../components/PlayerInfo";
import PlayerBidLog from "../components/PlayerBidLog";

const PLAYER_INFO_QUERY = gql`
  query PlayerInfo($player_id: Int!) {
    player(id: $player_id) {
      id
      name
      auction {
        id
        name
      }
    }
  }
`;

class Player extends Component {
  render() {
    const { playerId } = this.props.match.params;

    return (
      <Query
        query={PLAYER_INFO_QUERY}
        variables={{ player_id: parseInt(playerId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <div>
              <Header
                home='player'
                data={data.player}
              />
              <PlayerContainer
                playerId={ parseInt(playerId, 10) }
              />
            </div>
          );
        }}
      </Query>
    );
  }
}

class PlayerContainer extends Component {
  static propTypes = {
    playerId: PropTypes.number.isRequired,
  };

  render() {
    const { playerId } = this.props;

    return (
      <div>
        <PlayerInfo playerId={ playerId } />
        <PlayerBidLog playerId={ playerId } />
      </div>
    );
  }
}

export default Player;
