import React, { Component } from "react";
import PropTypes from "prop-types";
import NoData from "./NoData";

class AuctionList extends Component {
  static propTypes = {
    auctions: PropTypes.array.isRequired
  };

  render() {
    const { auctions } = this.props;

    if (auctions.length === 0) return <NoData />;

    return (
      <p>NOT IMPLEMENTED</p>
    );
  }
}

export default AuctionList;
