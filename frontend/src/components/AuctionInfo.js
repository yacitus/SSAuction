import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import { Mutation } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import BootstrapTable from 'react-bootstrap-table-next';
import Moment from 'react-moment';
import CurrentUserAuctionAdmin from "../components/CurrentUserAuctionAdmin";
import Switch from "react-switch";
import * as Utilities from "../components/utilities.js";

const AUCTION_INFO_QUERY = gql`
  query AuctionInfo($auction_id: Int!) {
    auction(id: $auction_id) {
      id
      name
      yearRange
      startedOrPausedAt
      playersPerTeam
      mustRosterAllPlayers
      dollarsPerTeam
      nominationsPerTeam
      secondsBeforeAutonomination
      bidTimeoutSeconds
      autonominationQueue {
        player {
          ssnum
          name
          position
        }
      }
    }
  }
`;

const TOGGLE_AUCTION_MUTATION = gql`
  mutation SetAuctionActiveOrInactive($auctionId: Int!, $active: Boolean!) {
    setAuctionActiveOrInactive(auctionId: $auctionId, active: $active) {
      id
      active
    }
  }
`;

class ToggleAuctionSwitch extends Component {
  render() {
    const { auctionId } = this.props;
    const { auctionActive } = this.props;

    return (
      <Mutation
        mutation={TOGGLE_AUCTION_MUTATION}
        variables={{auctionId: auctionId,
                    active: !auctionActive}}>
        {(toggleAuction, { loading, error }) => (
          <div>
            <Error error={error} />
            <Switch
              disabled={loading}
              onChange={toggleAuction}
              checked={auctionActive}
            />
          </div>
        )}
      </Mutation>
    );
  }
}

class AuctionInfo extends Component {
  render() {
    const { auctionId } = this.props;
    const { auctionActive } = this.props;

    return (
      <Query
        query={AUCTION_INFO_QUERY}
        variables={{ auction_id: auctionId }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <AuctionInfoTable
              info={ data }
              auctionId={ auctionId }
              auctionActive={ auctionActive }
            />
          );
        }}
      </Query>
    );
  }
}

class AuctionInfoTable extends Component {
  render() {
    const { info } = this.props;
    const { auctionId } = this.props;
    const { auctionActive } = this.props;

    function valueFormatter(cell, row) {
      if (row.id === 0) {
        return (
          <CurrentUserAuctionAdmin auctionId={ auctionId }>
            {currentUserAuctionAdmin => (
              <div>
                {currentUserAuctionAdmin && (
                    <ToggleAuctionSwitch
                      auctionId={ auctionId }
                      auctionActive={ auctionActive }
                    />
                )}
                {!currentUserAuctionAdmin && (
                  auctionActive ? '✅' : '❌'
                )}
              </div>
            )}
          </CurrentUserAuctionAdmin>
        );
      } else if (row.id === 1) {
        return (
          <Moment format="llll">
            {info.auction.startedOrPausedAt}
          </Moment>
        );
      } else if (row.id === 4) {
        if (info.auction.mustRosterAllPlayers) {
          return "Yes";
        }
        else {
          return "No";
        }
      } else {
        return (`${cell}`);
      }
    }

    const columns = [{
      dataField: 'label',
      text: ''
    }, {
      dataField: 'value',
      text: '',
      formatter: valueFormatter
    }];

    const data = [{
      label: 'Active:',
      value: '',
      id: 0
    }, {
      label: 'Last Started or Paused:',
      value: '',
      id: 1
    }, {
      label: 'Years:',
      value: `${info.auction.yearRange}`,
      id: 2
    }, {
      label: 'Players Per Team:',
      value: `${info.auction.playersPerTeam}`,
      id: 3
    }, {
      label: 'Must Roster All Players:',
      value: `${info.auction.mustRosterAllPlayers}`,
      id: 4
    }, {
      label: 'Dollars Per Team:',
      value: `$${info.auction.dollarsPerTeam}`,
      id: 5
    }, {
      label: 'Time Before Bids Expire:',
      value: `${Utilities.secondsToDaysHoursMinsSecsStr(
                  info.auction.bidTimeoutSeconds)}`,
      id: 6
    }, {
      label: 'Nominations Per Team:',
      value: `${info.auction.nominationsPerTeam}`,
      id: 7
    }, {
      label: 'Time Before Auto-nomination:',
      value: `${Utilities.secondsToDaysHoursMinsSecsStr(
                  info.auction.secondsBeforeAutonomination)}`,
      id: 8
    }, {
      label: 'Next Players in Auto-Nomination Queue:',
      value: `${info.auction.autonominationQueue[0].player.name} (#${info.auction.autonominationQueue[0].player.ssnum} - ${info.auction.autonominationQueue[0].player.position})`,
      id: 9
    }, {
      label: '',
      value: `${info.auction.autonominationQueue[1].player.name} (#${info.auction.autonominationQueue[1].player.ssnum} - ${info.auction.autonominationQueue[1].player.position})`,
      id: 10
    }];

    const CaptionElement = () =>
      <h3 style={{ borderRadius: '0.25em',
                   textAlign: 'center',
                   color: 'green',
                   border: '1px solid green',
                   padding: '0.5em' }}>
        Auction Info</h3>;

    return (
      <div>
        <BootstrapTable
          bootstrap4={ true }
          caption={ <CaptionElement /> }
          keyField='id'
          data={ data }
          columns={ columns }
          striped
          headerClasses="auction-info-header" />
      </div>
    );
  }
}

export default AuctionInfo;
