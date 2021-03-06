import React, { Component } from "react";
import gql from "graphql-tag";
import PropTypes from "prop-types";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import BootstrapTable from 'react-bootstrap-table-next';
import Countdown from "../components/Countdown";
import BidButton from "../components/BidButton";
import PlusOneButton from "../components/PlusOneButton";
import './tables.css';

const AUCTION_BIDS_QUERY = gql`
  query AuctionBids($auction_id: Int!) {
    auction(id: $auction_id) {
      id
      active
      bids {
        id
        bidAmount
        hiddenHighBid
        expiresAt
        player {
          id
          ssnum
          name
          position
        }
        team {
          id
          name
        }
      }
    }
  }
`;

const AUCTION_BID_CHANGE_SUBSCRIPTION = gql`
  subscription AuctionBidChange($auction_id: Int!) {
    auctionBidChange(id: $auction_id) {
      id
      active
      bids {
        id
        bidAmount
        hiddenHighBid
        expiresAt
        player {
          id
          ssnum
          name
          position
        }
        team {
          id
          name
        }
      }
    }
  }
`;

class AuctionBids extends Component {
  componentWillReceiveProps(props) {
    const { auctionActive } = this.props;
    if (props.auctionActive !== auctionActive) {
      this.refetch();
    }
  }

  eraseNonTeamHiddenHighBids = (teamId, bids) => {
    var bid;
    for (bid of bids) {
      if (bid.team.id !== teamId) {
        bid.hiddenHighBid = null;
      }
    }
  };

  render() {
    const { auctionId } = this.props;

    return (
      <Query
        query={AUCTION_BIDS_QUERY}
        variables={{ auction_id: parseInt(auctionId, 10) }}>
        {({ data, loading, error, refetch, subscribeToMore }) => {
          this.refetch = refetch;
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          this.eraseNonTeamHiddenHighBids(this.props.teamId, data.auction.bids);
          return (
            <AuctionBidsTable
              auctionId={ auctionId }
              teamId={ this.props.teamId }
              bids={ data.auction.bids }
              subscribeToAuctionBidChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

class AuctionBidsTable extends Component {
  static propTypes = {
    auctionId: PropTypes.number.isRequired,
    teamId: PropTypes.string,
    bids: PropTypes.array.isRequired,
    subscribeToAuctionBidChanges: PropTypes.func.isRequired
  };

  componentDidMount() {
    this.props.subscribeToAuctionBidChanges({
      document: AUCTION_BID_CHANGE_SUBSCRIPTION,
      variables: { auction_id: this.props.auctionId },
      updateQuery: this.handleAuctionBidChange
    });
  }

  handleAuctionBidChange = (prev, { subscriptionData }) => {
    if (!subscriptionData.data) return prev;
    return {
      auction: {
        ...prev.auction,
        bids: subscriptionData.data.auctionBidChange.bids
      }
    };
  };

  render() {
    const { auctionId } = this.props;
    const { teamId } = this.props;

    const bidButtonFormatter = (cell, row) => {
      return (
        <BidButton
          row={ row }
          auctionId={ auctionId }
          teamId={ teamId }
          teamPage={ false }
        />
      );
    }

    const plusOneButtonFormatter = (cell, row) => {
      return (
        <PlusOneButton
          row={ row }
          auctionId={ auctionId }
          teamId={ teamId }
        />
      );
    }

    const getColumns = () => {
      let columns = [{
        dataField: 'team.name',
        text: 'Team',
        formatter: teamNameFormatter,
        sort: true
      }, {
        dataField: 'player.name',
        text: 'Player',
        formatter: playerNameFormatter,
        sort: true
      }, {
        dataField: 'player.position',
        text: 'Position',
        sort: true
      }, {
        dataField: 'player.ssnum',
        text: 'S. num',
        sort: true,
        headerStyle: () => {
          return { width: "5%" };
        }
      }, {
        dataField: 'bidAmount',
        text: '$ Bid',
        formatter: dollarsFormatter,
        sort: true,
        headerStyle: () => {
          return { width: "5%" };
        }
      }, {
        dataField: 'hiddenHighBid',
        text: '$ Hidden Max Bid',
        formatter: dollarsFormatter,
        sort: true,
        headerStyle: () => {
          return { width: "5%" };
        }
      }, {
        dataField: 'expiresAt',
        text: 'Expires In',
        formatter: countdownFormatter,
        sort: true
      }];

      if (teamId != null) {
        columns = columns.concat([{
          text: '',
          formatter: bidButtonFormatter,
         }, {
          text: '',
          formatter: plusOneButtonFormatter,
        }]);
      }

      return columns;
    }

    function teamNameFormatter(cell, row) {
      return ( <a href={'/team/' + row.team.id}>{cell}</a> );
    }

    function playerNameFormatter(cell, row) {
      return ( <a href={'/player/' + row.player.id}>{cell}</a> );
    }

    function dollarsFormatter(cell, row) {
      if (cell === null) return '';
      return (`$${cell}`);
    }

    function countdownFormatter(cell, row) {
      if (cell == null) {
        return "";
      }
      else {
        return (
            <Countdown
            expires={ cell }
            auctionId={ auctionId }
          />
        );
      }
    }

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'green',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Bids</h3>;

    const defaultSortedBy = [{
      dataField: "expiresAt",
      order: "asc"
    }];

    return (
      <div>
        <BootstrapTable
          bootstrap4={ true }
          caption={ <CaptionElement /> }
          keyField='id'
          data={ this.props.bids }
          columns={ getColumns() }
          striped
          defaultSorted={defaultSortedBy}
        />
      </div>
    );
  }
}

export default AuctionBids;
