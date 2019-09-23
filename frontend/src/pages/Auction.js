import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import AuctionBids from "../components/AuctionBids";
import AuctionRosteredPlayers from "../components/AuctionRosteredPlayers";
import TeamsInfo from "../components/TeamsInfo";
import AuctionInfo from "../components/AuctionInfo";


const AUCTION_INFO_QUERY = gql`
  query AuctionInfo($auction_id: Int!) {
    auction(id: $auction_id) {
      id
      name
    }
  }
`;

class Auction extends Component {
  render() {
    const { auctionId } = this.props.match.params;

    return (
      <Query
        query={AUCTION_INFO_QUERY}
        variables={{ auction_id: parseInt(auctionId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <Container>
              <AuctionBids auctionId={ auctionId } />
              <AuctionRosteredPlayers auctionId={ auctionId } />
              <TeamsInfo auctionId={ auctionId } />
              <AuctionInfo auctionId={ auctionId } />
            </Container>
          );
        }}
      </Query>
    );
  }
}

export default Auction;
