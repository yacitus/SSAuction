import React, { Component } from "react";
import PropTypes from "prop-types";
import NoData from "./NoData";
import Container from "react-bootstrap/Container";
import BootstrapTable from 'react-bootstrap-table-next';

class AuctionList extends Component {
  static propTypes = {
    auctions: PropTypes.array.isRequired
  };

  render() {
    const { auctions } = this.props;

    if (auctions.length === 0) return <NoData />;

    function activeFormatter(cell, row) {
      return (cell ? '✅' : '❌');
    }

    const columns = [{
      dataField: 'id',
      text: 'ID'
    }, {
      dataField: 'name',
      text: 'Name'
    }, {
      dataField: 'yearRange',
      text: 'Years'
    }, {
      dataField: 'active',
      text: 'Active',
      formatter: activeFormatter
    }];

    return (
      <Container>
        <h1 className="header">Auctions</h1>
        <BootstrapTable
          bootstrap4={ true }
          keyField='id'
          data={ auctions }
          columns={ columns }
          striped
          hover />
      </Container>
    );
  }
}

export default AuctionList;
