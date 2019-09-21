import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import Card from "react-bootstrap/Card";
import Table from "react-bootstrap/Table";
import Moment from 'react-moment';


const TEAM_INFO_QUERY = gql`
  query TeamInfo($team_id: Int!) {
    team(id: $team_id) {
      id
      name
      dollarsSpent
      dollarsBid
      dollarsRemainingForBids
      unusedNominations
      timeOfLastNomination
    }
  }
`;

class TeamInfo extends Component {
  render() {
    const { teamId } = this.props;

    return (
      <Query
        query={TEAM_INFO_QUERY}
        variables={{ team_id: parseInt(teamId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <Container>
              <Card border="light" style={{ width: '36rem' }}>
                <Card.Header>Team Info</Card.Header>
                <Table bordered>
                  <tbody>
                    <tr>
                      <td>$ Spent</td>
                      <td>${data.team.dollarsSpent}</td>
                    </tr>
                    <tr>
                      <td>$ Bid</td>
                      <td>${data.team.dollarsBid}</td>
                    </tr>
                    <tr>
                      <td>$ Remaining for Bids</td>
                      <td>${data.team.dollarsRemainingForBids}</td>
                    </tr>
                    <tr>
                      <td>Unused Nominations</td>
                      <td>{data.team.unusedNominations}</td>
                    </tr>
                    <tr>
                      <td>Time of Last Nomination</td>
                      <td>
                        {data.team.timeOfLastNomination != null &&
                          <Moment format="llll">
                            {data.team.timeOfLastNomination}
                          </Moment>
                        }
                      </td>
                    </tr>
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

export default TeamInfo;
