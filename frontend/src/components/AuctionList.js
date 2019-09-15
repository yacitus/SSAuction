import React, { Component } from "react";
import PropTypes from "prop-types";
import NoData from "./NoData";
import Container from "react-bootstrap/Container";
import Jumbotron from "react-bootstrap/Jumbotron";

class AuctionList extends Component {
  static propTypes = {
    auctions: PropTypes.array.isRequired
  };

  render() {
    const { auctions } = this.props;

    if (auctions.length === 0) return <NoData />;

    return (
      <Container>
        <Jumbotron>
          <h1 className="header">NOT IMPLEMENTED...</h1>
        </Jumbotron>
      </Container>
    );
  }
}

export default AuctionList;
