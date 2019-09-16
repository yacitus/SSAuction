import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Container from "react-bootstrap/Container";
import Jumbotron from "react-bootstrap/Jumbotron";
import Table from "react-bootstrap/Table";
// import Moment from 'react-moment';

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

const GET_AUCTION_QUERY = gql`
  query GetAuction($auction_id: Int!) {
    auction(id: $auction_id) {
      id
      name
      yearRange
      active
      nominationsPerTeam
      secondsBeforeAutonomination
      bidTimeoutSeconds
    }
  }
`;

class Auction extends Component {
  render() {
    const { auctionId } = this.props.match.params;

    return (
      <Query
        query={GET_AUCTION_QUERY}
        variables={{ auction_id: parseInt(auctionId, 10) }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <Container>
              <Jumbotron>
                <h1 className="header">{data.auction.name}</h1>
              </Jumbotron>
              <Table striped bordered>
                <tbody>
                  <tr>
                    <td>Active:</td>
                    <td>{data.auction.active ? '✅' : '❌'}</td>
                  </tr>
                  <tr>
                    <td>Years:</td>
                    <td>{data.auction.yearRange}</td>
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
            </Container>
          );
        }}
      </Query>
    );
  }
}

export default Auction;
