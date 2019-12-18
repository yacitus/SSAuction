import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import PropTypes from "prop-types";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Header from "../components/Header";
import CurrentUserInTeam from "../components/CurrentUserInTeam";
import Container from "react-bootstrap/Container";
import TeamBids from "../components/TeamBids";
import TeamAuthorizedBids from "../components/TeamAuthorizedBids";
import NominationQueue from "../components/NominationQueue";
import TeamRosteredPlayers from "../components/TeamRosteredPlayers";
import TeamInfo from "../components/TeamInfo";
import UserInfo from "../components/UserInfo";

const TEAM_INFO_QUERY = gql`
  query TeamInfo($team_id: Int!) {
    team(id: $team_id) {
      id
      name
      auction {
        id
        name
        active
      }
    }
  }
`;

const AUCTION_STATUS_CHANGE_SUBSCRIPTION = gql`
  subscription AuctionStatusChange($auction_id: Int!) {
    auctionStatusChange(id: $auction_id) {
      id
      name
      active
    }
}`;

class Team extends Component {
  render() {
    const { teamId } = this.props.match.params;

    return (
      <Query
        query={TEAM_INFO_QUERY}
        variables={{ team_id: parseInt(teamId, 10) }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <Container>
              <Header
                home='team'
                data={data.team}
              />
              <TeamContainer
                teamId={ parseInt(teamId, 10) }
                auctionId={ parseInt(data.team.auction.id, 10) }
                auctionActive={ data.team.auction.active }
                subscribeToAuctionStatusChanges={ subscribeToMore }
              />
            </Container>
          );
        }}
      </Query>
    );
  }
}

class TeamContainer extends Component {
  static propTypes = {
    teamId: PropTypes.number.isRequired,
    auctionId: PropTypes.number.isRequired,
    auctionActive: PropTypes.bool.isRequired,
    subscribeToAuctionStatusChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToAuctionStatusChanges({
      document: AUCTION_STATUS_CHANGE_SUBSCRIPTION,
      variables: { auction_id: this.props.auctionId },
      updateQuery: this.handleAuctionStatusChange
    });
  }

  handleAuctionStatusChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    return {
      team: {
        ...prev.team,
        auction: {
          active: subscriptionData.data.auctionStatusChange.active,
          id: subscriptionData.data.auctionStatusChange.id,
          name: subscriptionData.data.auctionStatusChange.name
        }
      }
    };
  };

  render() {
    const { teamId } = this.props;
    const { auctionId } = this.props;
    const { auctionActive } = this.props;

    return (
      <CurrentUserInTeam teamId={ teamId }>
        {currentUserInTeam => (
          <Container>
            {!currentUserInTeam && (
              <TeamBids
                teamId={ teamId }
                auctionId={ auctionId }
                auctionActive={ auctionActive }
              />
            )}
            {currentUserInTeam && (
              <>
                <TeamAuthorizedBids
                  teamId={ teamId }
                  auctionId={ auctionId }
                  auctionActive={ auctionActive }
                />
                <NominationQueue
                  teamId={ teamId }
                  auctionId={ auctionId }
                />
              </>
            )}
            <TeamRosteredPlayers teamId={ teamId } />
            <TeamInfo teamId={ teamId } />
            <UserInfo teamId={ teamId } />
          </Container>
        )}
      </CurrentUserInTeam>
    );
  }
}

export default Team;
