import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import Jumbotron from "react-bootstrap/Jumbotron";

const GET_AUCTION_QUERY = gql`
  query GetAuction($auction_id: Int!) {
    auction(id: $auction_id) {
      id
      name
      yearRange
      active
    }
  }
`;

class Auction extends Component {
  render() {
    const { auctionId } = this.props.match.params;

    return (
      <Query
        query={GET_AUCTION_QUERY}
        variables={{ auction_id: parseInt(auctionId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <Container>
              <Jumbotron>
                <h1 className="header">Auction</h1>
                <p>ID: {data.auction.id}</p>
                <p>Name: {data.auction.name}</p>
                <p>Years: {data.auction.yearRange}</p>
                <p>Active: {data.auction.active ? '✅' : '❌'}</p>
              </Jumbotron>
            </Container>
          );
        }}
      </Query>
    );
  }
}

export default Auction;
