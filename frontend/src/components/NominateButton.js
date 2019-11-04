import React, { Component } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import { useMutation } from '@apollo/react-hooks';
import PropTypes from "prop-types";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Button from 'react-bootstrap/Button'

const TEAM_NOMINATIONS_OPEN_QUERY = gql`
  query TeamNominationsOpen($team_id: Int!) {
    team(id: $team_id) {
      id
      nominationsOpen
    }
  }
`;

const TEAM_NOMINATIONS_OPEN_SUBSCRIPTION = gql`
  subscription TeamNominationsOpenChange($team_id: Int!) {
    nominationQueueChange(id: $team_id) {
      id
      nominationsOpen
    }
  }
`;

const SUBMIT_BID_MUTATION = gql`
  mutation SubmitBid(
    $auction_id: Int!
    $team_id: Int!
    $player_id: Int!
    $bid_amount: Int!
    $hidden_high_bid: Int
  ) {
    submitBid(auctionId: $auction_id,
              teamId: $team_id,
              playerId: $player_id,
              bidAmount: $bid_amount,
              hiddenHighBid: $hidden_high_bid) {
      id
      expiresAt
    }
  }
`;

class NominateButton extends Component {
  render() {
    const { row } = this.props;
    const { auctionId } = this.props;
    const { teamId } = this.props;
    const playerId = parseInt(this.props.row.player.id, 10);

    return (
      <Query
        query={TEAM_NOMINATIONS_OPEN_QUERY}
        variables={{ team_id: teamId }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <NominateButtonMutator
              auctionId={ auctionId }
              teamId={ teamId }
              playerId={ playerId }
              row={ row }
              nominationsOpen={ data.team.nominationsOpen }
              subscribeToNominationsOpenChanges={ subscribeToMore }
              getInitialBid={ this.props.getInitialBid }
            />
          );
        }}
      </Query>
    );
  }
}

const NominateButtonMutator = (props) => {
  React.useEffect(() => {
    props.subscribeToNominationsOpenChanges({
      document: TEAM_NOMINATIONS_OPEN_SUBSCRIPTION,
      variables: { team_id: props.teamId },
      updateQuery: (prev, { subscriptionData }) => {
        if (!subscriptionData.data) return prev;
        return {
          team: {
            ...prev.team,
            nominationsOpen: subscriptionData.data.nominationQueueChange.nominationsOpen
          }
        };
      }
    });
  }, [props]);

  const [submitBid] = useMutation(SUBMIT_BID_MUTATION);

  return (
    <div>
      <Button
        disabled={ !props.nominationsOpen }
        onClick={ () => {
          let bid = props.getInitialBid(props.row);
          submitBid({ variables: { auction_id: props.auctionId,
                                   team_id: props.teamId,
                                   player_id: props.playerId,
                                   bid_amount: parseInt(bid.initialBid, 10),
                                   hidden_high_bid: parseInt(bid.hiddenMaxBid, 10) } });
        }}
        variant="outline-success">
        Nominate
      </Button>
    </div>
  );
};

NominateButtonMutator.propTypes = {
  auctionId: PropTypes.number.isRequired,
  teamId: PropTypes.number.isRequired,
  playerId: PropTypes.number.isRequired,
  row: PropTypes.object.isRequired,
  nominationsOpen: PropTypes.bool.isRequired,
  subscribeToNominationsOpenChanges: PropTypes.func.isRequired,
  getInitialBid: PropTypes.func.isRequired
};

export default NominateButton;
