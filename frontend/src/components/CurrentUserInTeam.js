import React, { Component } from "react";
import PropTypes from "prop-types";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";

const CURRENT_USER_IN_TEAM_QUERY = gql`
  query meInTeam($teamId: Int!) {
    meInTeam(teamId: $teamId) 
  }
`;

class CurrentUserInTeam extends Component {
  static propTypes = {
    teamId: PropTypes.number,
    children: PropTypes.func.isRequired
  };

  render() {
    const { teamId } = this.props;

    return (
      <Query
        query={CURRENT_USER_IN_TEAM_QUERY}
        variables={{ teamId: teamId }}>
        {({ data, loading, error }) => {
          if (loading) return this.props.children(null);
          if (error) return <Error error={error} />;
          return this.props.children(data.meInTeam);
        }}
      </Query>
    );
  }
}

export default CurrentUserInTeam;
