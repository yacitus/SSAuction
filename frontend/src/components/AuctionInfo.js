import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import Card from "react-bootstrap/Card";
import Table from "react-bootstrap/Table";
import Moment from 'react-moment';

function seconds_to_days_hours_mins_secs_str(seconds)
{ // day, h, m and s
  var days     = Math.floor(seconds / (24*60*60));
      seconds -= days    * (24*60*60);
  var hours    = Math.floor(seconds / (60*60));
      seconds -= hours   * (60*60);
  var minutes  = Math.floor(seconds / (60));
      seconds -= minutes * (60);
  return ( (0<days)?(days+" day "):""
          +(0<hours)?(hours+" hours "):""
          +(0<minutes)?(minutes+" min "):""
          +(0<seconds)?(seconds+" sec"):"" );
}

const AUCTION_INFO_QUERY = gql`
  query AuctionInfo($auction_id: Int!) {
    auction(id: $auction_id) {
      id
      name
      yearRange
      active
      startedOrPausedAt
      playersPerTeam
      dollarsPerTeam
      nominationsPerTeam
      secondsBeforeAutonomination
      bidTimeoutSeconds
    }
  }
`;

class AuctionInfo extends Component {
  render() {
    const { auctionId } = this.props;

    return (
      <Query
        query={AUCTION_INFO_QUERY}
        variables={{ auction_id: parseInt(auctionId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <Container>
              <Card border="light" style={{ width: '36rem' }}>
                <Card.Header>Auction Info</Card.Header>
                <Table bordered>
                  <tbody>
                    <tr>
                      <td>Active:</td>
                      <td>{data.auction.active ? '✅' : '❌'}</td>
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
                        {seconds_to_days_hours_mins_secs_str(
                            data.auction.secondsBeforeAutonomination)}
                      </td>
                    </tr>
                    <tr>
                      <td>Time Before Bids Expire:</td>
                      <td>
                        {seconds_to_days_hours_mins_secs_str(
                            data.auction.bidTimeoutSeconds)}
                      </td>
                    </tr>
                  </tbody>
                </Table>
              </Card>
            </Container>
          );
        }}
      </Query>
    );
  }
}

export default AuctionInfo;
