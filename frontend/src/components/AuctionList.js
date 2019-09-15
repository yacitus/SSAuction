import React, { Component } from "react";
import PropTypes from "prop-types";
import NoData from "./NoData";
import Container from "react-bootstrap/Container";
import Jumbotron from "react-bootstrap/Jumbotron";
import Table from "react-bootstrap/Table";

class AuctionList extends Component {
  static propTypes = {
    auctions: PropTypes.array.isRequired
  };

  renderAuction(auction, index) {
    return (
      <tr key={index}>
        <td>{auction.id}</td>
        <td>{auction.name}</td>
        <td>{auction.yearRange}</td>
        <td>{auction.active ? '✅' : '❌'}</td>
      </tr>
    )
  }

  render() {
    const { auctions } = this.props;

    if (auctions.length === 0) return <NoData />;

    return (
      <Container>
        <Jumbotron>
          <h1 className="header">Auctions</h1>
          <Table striped bordered hover>
            <thead>
              <tr>
                <th>#</th>
                <th>Name</th>
                <th>Years</th>
                <th>Active</th>
              </tr>
            </thead>
            <tbody>
              {auctions.map(this.renderAuction)}
            </tbody>
          </Table>
        </Jumbotron>
      </Container>
    );
  }
}

export default AuctionList;
