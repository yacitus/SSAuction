import React, { Component } from "react";
import gql from "graphql-tag";
import PropTypes from "prop-types";
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
      active
    }
  }
`;

const AUCTION_STATUS_CHANGE_SUBSCRIPTION = gql`
  subscription AuctionStatusChange($auction_id: Int!) {
    auctionStatusChange(id: $auction_id) {
      id
      name
      active
    }
}`;

class Auction extends Component {
  render() {
    const auctionId = parseInt(this.props.match.params.auctionId, 10);

    return (
      <Query
        query={AUCTION_INFO_QUERY}
        variables={{ auction_id: auctionId }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <AuctionContainer
              auctionId={ auctionId }
              auctionActive={ data.auction.active }
              subscribeToAuctionStatusChanges={subscribeToMore}
            />
          );
        }}
      </Query>
    );
  }
}

class AuctionContainer extends Component {
  state = {
    auctionActive:  this.props.auctionActive
  }

  static propTypes = {
    auctionId: PropTypes.number.isRequired,
    auctionActive: PropTypes.bool.isRequired,
    subscribeToAuctionStatusChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToAuctionStatusChanges({
      document: AUCTION_STATUS_CHANGE_SUBSCRIPTION,
      variables: { auction_id: this.props.auctionId },
      updateQuery: this.handleAuctionStatusChange
    });
  }

  handleAuctionStatusChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    this.setState({auctionActive: subscriptionData.data.auctionStatusChange.active});
    return prev;
  };

  render() {
    const { auctionId } = this.props;

    return (
      <Container>
        <AuctionBids
          auctionId={ auctionId }
          auctionActive={ this.state.auctionActive } />
        <AuctionRosteredPlayers auctionId={ auctionId } />
        <TeamsInfo auctionId={ auctionId } />
        <AuctionInfo
          auctionId={ auctionId }
          auctionActive={ this.state.auctionActive } />
      </Container>
    );
  }
}

export default Auction;
