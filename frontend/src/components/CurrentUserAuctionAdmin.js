import React, { Component } from "react";
import PropTypes from "prop-types";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";

const CURRENT_USER_AUCTION_ADMIN_QUERY = gql`
  query meAuctionAdmin($auctionId: Int!) {
    meAuctionAdmin(auctionId: $auctionId) 
  }
`;

class CurrentUserAuctionAdmin extends Component {
  static propTypes = {
    auctionId: PropTypes.string,
    children: PropTypes.func.isRequired
  };

  render() {
    const { auctionId } = this.props;

    return (
      <Query
        query={CURRENT_USER_AUCTION_ADMIN_QUERY}
        variables={{ auctionId: parseInt(auctionId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return this.props.children(null);
          if (error) return <Error error={error} />;
          return this.props.children(data.meAuctionAdmin);
        }}
      </Query>
    );
  }
}

export default CurrentUserAuctionAdmin;
