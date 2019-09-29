import React, { Component } from "react";
import gql from "graphql-tag";
import PropTypes from "prop-types";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import NominationQueueTable from "../components/NominationQueueTable";
import NominationQueuePlayerSearch from "../components/NominationQueuePlayerSearch";

const TEAM_QUERY = gql`
  query Team($team_id: Int!) {
    team(id: $team_id) {
      id
    }
  }
`;

const TEAM_NOMINATION_QUEUE_SUBSCRIPTION = gql`
  subscription TeamNominationQueueChange($team_id: Int!) {
    nominationQueueChange(id: $team_id) {
      id
    }
  }
`;

class NominationQueue extends Component {
  render() {
    const teamId = parseInt(this.props.teamId, 10);

    return (
      <Query
        query={TEAM_QUERY}
        variables={{ team_id: teamId }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <NominationQueuePair
              teamId={ teamId }
              subscribeToNominationQueueChanges={subscribeToMore}
            />
          );
        }}
      </Query>
    );
  }
}

class NominationQueuePair extends Component {
  state = {
    refreshToggle: false
  }

  static propTypes = {
    teamId: PropTypes.number.isRequired,
    subscribeToNominationQueueChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToNominationQueueChanges({
      document: TEAM_NOMINATION_QUEUE_SUBSCRIPTION,
      variables: { team_id: this.props.teamId },
      updateQuery: this.handleNominationQueueChange
    });
  }

  handleNominationQueueChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    this.setState({refreshToggle: !this.state.refreshToggle}); // force children to refreshh
    return prev;
  };

  render() {
    const { teamId } = this.props;

    return (
      <Container>
        <NominationQueueTable
          teamId={ teamId }
          refresh={ this.state.refreshToggle } />
        <NominationQueuePlayerSearch
          teamId={ teamId }
          refresh={ this.state.refreshToggle } />
      </Container>
    );
  }
}

export default NominationQueue;
