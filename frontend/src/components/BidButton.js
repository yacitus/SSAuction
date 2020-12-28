import React, { Component, useState } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import { useMutation } from '@apollo/react-hooks';
import PropTypes from "prop-types";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Modal from "react-bootstrap/Modal";
import Form from 'react-bootstrap/Form'
import Button from 'react-bootstrap/Button'

const AUCTION_ACTIVE_QUERY = gql`
  query AuctionActive($auction_id: Int!) {
    auction(id: $auction_id) {
      id
      active
    }
  }
`;

const AUCTION_ACTIVE_CHANGE_SUBSCRIPTION = gql`
  subscription AuctionActiveChange($auction_id: Int!) {
    auctionBidChange(id: $auction_id) {
      id
      active
    }
  }
`;

const SUBMIT_BID_MUTATION = gql`
  mutation SubmitBid(
    $auction_id: Int!
    $team_id: Int!
    $player_id: Int!
    $bid_amount: Int!
    $keep_bidding_up_to: Int!
    $hidden_high_bid: Int
  ) {
    submitBid(auctionId: $auction_id,
              teamId: $team_id,
              playerId: $player_id,
              bidAmount: $bid_amount,
              keepBiddingUpTo: $keep_bidding_up_to,
              hiddenHighBid: $hidden_high_bid) {
      id
      expiresAt
    }
  }
`;

class BidButton extends Component {
  render() {
    const { row } = this.props;
    const { auctionId } = this.props;
    const { teamId } = this.props;

    if (teamId === null) return null;
    return (
      <Query
        query={AUCTION_ACTIVE_QUERY}
        variables={{ auction_id: auctionId }}>
        {({ data, loading, error, subscribeToMore }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          return (
            <SubmitBidFormModal
              auctionId={ auctionId }
              teamId={ teamId }
              teamPage={ this.props.teamPage }
              row={ row }
              auctionActive={ data.auction.active }
              subscribeToAuctionActiveChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

const SubmitBidFormModal = (props) => {
  const [show, setShow] = useState(false);

  const bidAmountRef = React.createRef();
  const keepBiddingUpToRef = React.createRef();
  const hiddenHighBidRef = React.createRef();

  const handleClose = () => {
    setShow(false);
  }

  React.useEffect(() => {
    props.subscribeToAuctionActiveChanges({
      document: AUCTION_ACTIVE_CHANGE_SUBSCRIPTION,
      variables: { auction_id: props.auctionId },
      updateQuery: (prev, { subscriptionData }) => {
        if (!subscriptionData.data) return prev;
        return {
          auction: {
            ...prev.auction,
            active: subscriptionData.data.auctionBidChange.active
          }
        };
      }
    });
  }, [props]);

  const [submitBid, {error: mutationError}] = useMutation(SUBMIT_BID_MUTATION, {
        onError(err) {
            console.log(err);
        },
  });

  const handleSubmitBid = () => {
    submitBid({ variables: { auction_id: parseInt(props.auctionId, 10),
                             team_id: parseInt(props.teamId, 10),
                             player_id: parseInt(props.row.player.id, 10),
                             bid_amount: bidAmountRef.current.valueAsNumber,
                             keep_bidding_up_to: keepBiddingUpToRef.current.valueAsNumber,
                             hidden_high_bid: hiddenHighBidRef.current.valueAsNumber } });
    handleClose();
  }

  return (
    <div>
      <Modal
        show={ show }
        onHide={ handleClose }
        size="lg"
        aria-labelledby="contained-modal-title-vcenter"
        centered
      >
        <Modal.Header closeButton>
          <Modal.Title id="contained-modal-title-vcenter">
            { props.teamPage || props.teamId === props.row.team.id
              ? "Update Bid" : "New Bid" }
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            <Form.Group controlId="formBidAmount">
              <Form.Label>Bid Amount</Form.Label>
              <Form.Control
                type="number"
                disabled={ props.teamPage || props.teamId === props.row.team.id }
                ref={bidAmountRef}
                defaultValue={ props.row.bidAmount
                               + (props.teamPage || props.teamId === props.row.team.id
                                  ? 0 : 1) } />
            </Form.Group>
            <Form.Group controlId="formKeepBiddingUpTo">
              <Form.Label>Keep Bidding Up To</Form.Label>
              <Form.Control
                type="number"
                ref={keepBiddingUpToRef}
                defaultValue={ props.row.keepBiddingUpTo === null
                               ? "" : props.row.keepBiddingUpTo } />
            </Form.Group>
            <Form.Group controlId="formHiddenHighBid">
              <Form.Label>Hidden Max Bid</Form.Label>
              <Form.Control
                type="number"
                ref={hiddenHighBidRef}
                defaultValue={ props.row.hiddenHighBid === null
                               ? "" : props.row.hiddenHighBid } />
            </Form.Group>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={ handleClose }>Cancel</Button>
          <Button onClick={ handleSubmitBid }>
            { props.teamPage || props.teamId === props.row.team.id
              ? "Update Bid" : "New Bid" }
          </Button>
        </Modal.Footer>
      </Modal>
      <Button
        disabled={ !props.auctionActive }
        onClick={ () => { setShow(true); }}
        variant="outline-success">
        { props.teamPage || props.teamId === props.row.team.id
          ? "Update Bid" : "New Bid" }
      </Button>
      { mutationError && <Error error={mutationError} /> }
    </div>
  );
};

SubmitBidFormModal.propTypes = {
  auctionId: PropTypes.number.isRequired,
  row: PropTypes.object.isRequired,
  auctionActive: PropTypes.bool.isRequired,
  subscribeToAuctionActiveChanges: PropTypes.func.isRequired,
};

export default BidButton;
