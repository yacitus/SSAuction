import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import PropTypes from "prop-types";
import Error from "../components/Error";
import Loading from "../components/Loading";
import * as Utilities from "../components/utilities.js";

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

class Countdown extends Component {
  render() {
    const auctionId = parseInt(this.props.auctionId, 10);

    return (
      <Query
        query={AUCTION_INFO_QUERY}
        variables={{ auction_id: auctionId }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <CountdownUpdater
              expires={ this.props.expires }
              auctionId={ auctionId }
              auctionActive={ data.auction.active }
              startedOrPausedAt={ data.auction.startedOrPausedAt }
              subscribeToAuctionStatusChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

class CountdownUpdater extends Component {
  state = {
    auctionActive:  this.props.auctionActive,
    startedOrPausedAt: this.props.startedOrPausedAt,
    timeRemainingString:
      Utilities.getTimeRemainingString(this.props.expires,
                                       this.props.startedOrPausedAt)
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
    this.updateState();
  }

  handleAuctionStatusChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    this.setState({ auctionActive:
                      subscriptionData.data.auctionStatusChange.active,
                    startedOrPausedAt:
                      subscriptionData.data.auctionStatusChange.startedOrPausedAt
                  });
    this.updateState();
    return prev;
  };

  updateState() {
    if (this.state.auctionActive) {
      this.setState({ timeRemainingString:
                      Utilities.getTimeRemainingString(this.props.expires) });
      this.timeout = setTimeout(() => { this.updateState() }, 1000);
    }
  }

  componentWillUnmount() {
    clearTimeout(this.timeout);
  };

  render() {
      return ( this.state.timeRemainingString );
  }
}

export default Countdown;
