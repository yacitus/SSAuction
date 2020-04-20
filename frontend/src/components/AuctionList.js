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

    function nameFormatter(cell, row) {
      return ( <a href={'auction/' + row.id}>{cell}</a> );
    }

    const columns = [{
      dataField: 'id',
      text: 'ID'
    }, {
      dataField: 'name',
      text: 'Name',
      formatter: nameFormatter
    }, {
      dataField: 'yearRange',
      text: 'Years'
    }, {
      dataField: 'active',
      text: 'Active',
      formatter: activeFormatter
    }];

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'green',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Auctions</h3>;

    const rowEvents = {
      onClick: (e, row, rowIndex) => {
        window.location = `/auction/${row.id}`
      }
    };

    return (
      <Container>
        <BootstrapTable
          bootstrap4={ true }
          caption={ <CaptionElement /> }
          keyField='id'
          data={ auctions }
          columns={ columns }
          rowEvents={ rowEvents }
          striped
          hover />
      </Container>
    );
  }
}

export default AuctionList;
