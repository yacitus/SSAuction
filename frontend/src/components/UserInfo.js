import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import Card from "react-bootstrap/Card";
import Table from "react-bootstrap/Table";


const TEAM_USERS_INFO_QUERY = gql`
  query TeamUsersInfo($team_id: Int!) {
    team(id: $team_id) {
      id
      users {
        id
        username
        email
        slackDisplayName
      }
    }
  }
`;

class UserInfo extends Component {
  renderTableData(users) {
    return users.map((user, index) => {
       const { username, email, slackDisplayName } = user
       return (
          <tr>
             <td>{username}</td>
             <td>{email}</td>
             <td>{slackDisplayName}</td>
          </tr>
       )
    })
  }

  render() {
    const { teamId } = this.props;

    return (
      <Query
        query={TEAM_USERS_INFO_QUERY}
        variables={{ team_id: parseInt(teamId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <Container>
              <Card border="light" style={{ width: '36rem' }}>
                <Card.Header>Team Users</Card.Header>
                <Table bordered>
                  <tbody>
                    {this.renderTableData(data.team.users)}
                  </tbody>
                </Table>
              </Card>
            </Container>
          );
        }}
      </Query>
    );
  }
}

export default UserInfo;
