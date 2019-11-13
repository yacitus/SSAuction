import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import BootstrapTable from 'react-bootstrap-table-next';


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

    function slackDisplayNameFormatter(cell, row) {
        return (`@${cell}`);
    }

    const columns = [{
      dataField: 'username',
      text: 'Username'
    }, {
      dataField: 'email',
      text: 'Email'
    }, {
      dataField: 'slackDisplayName',
      text: 'Slack Display Name',
      formatter: slackDisplayNameFormatter
    }];

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'purple',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Team Users</h3>;

    return (
      <Query
        query={TEAM_USERS_INFO_QUERY}
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
                data={ data.team.users }
                columns={ columns }
                striped />
            </Container>
          );
        }}
      </Query>
    );
  }
}

export default UserInfo;
