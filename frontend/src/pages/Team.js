import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import CurrentUserInTeam from "../components/CurrentUserInTeam";
import Container from "react-bootstrap/Container";
import TeamBids from "../components/TeamBids";
import NominationQueue from "../components/NominationQueue";
import TeamRosteredPlayers from "../components/TeamRosteredPlayers";
import TeamInfo from "../components/TeamInfo";
import UserInfo from "../components/UserInfo";



const TEAM_INFO_QUERY = gql`
  query TeamInfo($team_id: Int!) {
    team(id: $team_id) {
      id
      name
    }
  }
`;

class Team extends Component {
  render() {
    const { teamId } = this.props.match.params;

    return (
      <Query
        query={TEAM_INFO_QUERY}
        variables={{ team_id: parseInt(teamId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <CurrentUserInTeam teamId={ teamId }>
              {currentUserInTeam => (
                <Container>
                  <TeamBids teamId={ teamId } />
                  {currentUserInTeam && (
                    <NominationQueue teamId={ teamId } />
                  )}
                  <TeamRosteredPlayers teamId={ teamId } />
                  <TeamInfo teamId={ teamId } />
                  <UserInfo teamId={ teamId } />
                </Container>
              )}
            </CurrentUserInTeam>
          );
        }}
      </Query>
    );
  }
}

export default Team;
