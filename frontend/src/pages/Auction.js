import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import PropTypes from "prop-types";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Header from "../components/Header";
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
      startedOrPausedAt
    }
  }
`;

const AUCTION_STATUS_CHANGE_SUBSCRIPTION = gql`
  subscription AuctionStatusChange($auction_id: Int!) {
    auctionStatusChange(id: $auction_id) {
      id
      name
      active
      startedOrPausedAt
    }
}`;

const LOGGED_IN_TEAM_QUERY = gql`
  query MeTeam($auction_id: Int!) {
    meTeam(auctionId: $auction_id) {
      id
      name
    }
  }
`;

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
            <Container>
              <Header
                home='auction'
                data={data.auction}
              />
              <AuctionContainer
                auctionId={ auctionId }
                auctionActive={ data.auction.active }
                startedOrPausedAt={ data.auction.startedOrPausedAt }
                subscribeToAuctionStatusChanges={ subscribeToMore }
              />
            </Container>
          );
        }}
      </Query>
    );
  }
}

class AuctionContainer extends Component {
  state = {
    auctionActive:  this.props.auctionActive,
    startedOrPausedAt: this.props.startedOrPausedAt
  }

  static propTypes = {
    auctionId: PropTypes.number.isRequired,
    auctionActive: PropTypes.bool.isRequired,
    startedOrPausedAt: PropTypes.string.isRequired,
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
    this.setState({ auctionActive:
                      subscriptionData.data.auctionStatusChange.active,
                    startedOrPausedAt:
                      subscriptionData.data.auctionStatusChange.startedOrPausedAt
                  });
    return prev;
  };

  render() {
    const { auctionId } = this.props;

    return (
      <Query
        query={LOGGED_IN_TEAM_QUERY}
        variables={{ auction_id: auctionId }}>
        {({ data, loading, error }) => {
          return (
            <Container>
              <AuctionBids
                auctionId={ auctionId }
                teamId={ data && data.meTeam ? data.meTeam.id : null }
                auctionActive={ this.state.auctionActive }
                startedOrPausedAt={ this.state.startedOrPausedAt } />
              <AuctionRosteredPlayers auctionId={ auctionId } />
              <TeamsInfo auctionId={ auctionId } />
              <AuctionInfo
                auctionId={ auctionId }
                auctionActive={ this.state.auctionActive } />
            </Container>
          );
        }}
      </Query>
    );
  }
}

export default Auction;
