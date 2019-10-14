import React, { Component } from "react";
import gql from "graphql-tag";
import PropTypes from "prop-types";
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

const TEAM_INFO_CHANGE_SUBSCRIPTION = gql`
  subscription AuctionBidChange($team_id: Int!) {
    teamInfoChange(id: $team_id) {
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
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <TeamInfoTable
              teamId={ teamId }
              team={ data.team }
              subscribeToTeamInfoChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

class TeamInfoTable extends Component {
  static propTypes = {
    teamId: PropTypes.string.isRequired,
    team: PropTypes.object.isRequired,
    subscribeToTeamInfoChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToTeamInfoChanges({
      document: TEAM_INFO_CHANGE_SUBSCRIPTION,
      variables: { team_id: parseInt(this.props.teamId, 10) },
      updateQuery: this.handleTeamInfoChange
    });
  }

  handleTeamInfoChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    return {
      team: {
        ...prev.team,
        name: subscriptionData.data.teamInfoChange.name,
        dollarsSpent: subscriptionData.data.teamInfoChange.dollarsSpent,
        dollarsBid: subscriptionData.data.teamInfoChange.dollarsBid,
        dollarsRemainingForBids: subscriptionData.data.teamInfoChange.dollarsRemainingForBids,
        unusedNominations: subscriptionData.data.teamInfoChange.unusedNominations,
        timeOfLastNomination: subscriptionData.data.teamInfoChange.timeOfLastNomination
      }
    };
  };

  render() {
    const { team} = this.props;

    return (
      <Container>
        <Card border="light" style={{ width: '36rem' }}>
          <Card.Header>Team Info</Card.Header>
          <Table bordered>
            <tbody>
              <tr>
                <td>$ Spent</td>
                <td>${team.dollarsSpent}</td>
              </tr>
              <tr>
                <td>$ Bid</td>
                <td>${team.dollarsBid}</td>
              </tr>
              <tr>
                <td>$ Remaining for Bids</td>
                <td>${team.dollarsRemainingForBids}</td>
              </tr>
              <tr>
                <td>Unused Nominations</td>
                <td>{team.unusedNominations}</td>
              </tr>
              <tr>
                <td>Time of Last Nomination</td>
                <td>
                  {team.timeOfLastNomination != null &&
                    <Moment format="llll">
                      {team.timeOfLastNomination}
                    </Moment>
                  }
                </td>
              </tr>
            </tbody>
          </Table>
        </Card>
      </Container>
    );
  }
}

export default TeamInfo;
