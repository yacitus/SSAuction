import React from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import AuctionList from "../components/AuctionList";

const GET_AUCTIONS_QUERY = gql`
  query GetAuctions {
    auctions {
      id
      name
      yearRange
      active
    }
  }
`;

const Home = () => (
  <Query query={GET_AUCTIONS_QUERY}>
    {({ data, loading, error }) => {
      if (loading) return <Loading />;
      if (error) return <Error error={error} />;
      return <AuctionList auctions={data.auctions} />;
    }}
  </Query>
);

export default Home;
