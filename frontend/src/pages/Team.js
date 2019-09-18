import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import Jumbotron from "react-bootstrap/Jumbotron";
import TeamBids from "../components/TeamBids";
import NominationQueue from "../components/NominationQueue";
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
            <Container>
              <Jumbotron>
                <h1 className="header">{data.team.name}</h1>
              </Jumbotron>
              <TeamBids teamId={ teamId } />
              <NominationQueue teamId={ teamId } />
              <TeamInfo teamId={ teamId } />
              <UserInfo teamId={ teamId } />
            </Container>
          );
        }}
      </Query>
    );
  }
}

export default Team;
