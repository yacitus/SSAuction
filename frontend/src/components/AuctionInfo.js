import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import { Mutation } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import Card from "react-bootstrap/Card";
import Table from "react-bootstrap/Table";
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
      dollarsPerTeam
      nominationsPerTeam
      secondsBeforeAutonomination
      bidTimeoutSeconds
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
        variables={{auctionId: parseInt(auctionId, 10),
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
        variables={{ auction_id: parseInt(auctionId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <CurrentUserAuctionAdmin auctionId={ auctionId }>
              {currentUserAuctionAdmin => (
                <Container>
                  <Card border="light" style={{ width: '36rem' }}>
                    <Card.Header>Auction Info</Card.Header>
                    <Table bordered>
                      <tbody>
                        <tr>
                          <td>Active:</td>
                          <td>
                            {!currentUserAuctionAdmin && (
                              auctionActive ? '✅' : '❌'
                            )}
                            {currentUserAuctionAdmin && (
                              <ToggleAuctionSwitch
                                auctionId={auctionId}
                                auctionActive={auctionActive}
                              />
                            )}
                          </td>
                        </tr>
                        <tr>
                          <td>Last Started or Paused:</td>
                          <td>
                            <Moment format="llll">
                              {data.auction.startedOrPausedAt}
                            </Moment>
                          </td>
                        </tr>
                        <tr>
                          <td>Years:</td>
                          <td>{data.auction.yearRange}</td>
                        </tr>
                        <tr>
                          <td>Players Per Team:</td>
                          <td>{data.auction.playersPerTeam}</td>
                        </tr>
                        <tr>
                          <td>Dollars Per Team:</td>
                          <td>${data.auction.dollarsPerTeam}</td>
                        </tr>
                        <tr>
                          <td>Nominations Per Team:</td>
                          <td>{data.auction.nominationsPerTeam}</td>
                        </tr>
                        <tr>
                          <td>Time Before Auto-nomination:</td>
                          <td>
                            {Utilities.secondsToDaysHoursMinsSecsStr(
                                data.auction.secondsBeforeAutonomination)}
                          </td>
                        </tr>
                        <tr>
                          <td>Time Before Bids Expire:</td>
                          <td>
                            {Utilities.secondsToDaysHoursMinsSecsStr(
                                data.auction.bidTimeoutSeconds)}
                          </td>
                        </tr>
                      </tbody>
                    </Table>
                  </Card>
                </Container>
              )}
            </CurrentUserAuctionAdmin>
          );
        }}
      </Query>
    );
  }
}

export default AuctionInfo;
