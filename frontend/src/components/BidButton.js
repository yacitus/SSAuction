import React, { Component, useState } from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import { useMutation } from '@apollo/react-hooks';
import PropTypes from "prop-types";
import Error from "../components/Error";
import Loading from "../components/Loading";
import Modal from "react-bootstrap/Modal";
import Button from 'react-bootstrap/Button'
import Form from 'react-bootstrap/Form'

const LOGGED_IN_TEAM_QUERY = gql`
  query MeTeam($auction_id: Int!) {
    meTeam(auctionId: $auction_id) {
      id
      name
    }
  }
`;

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

class BidButton extends Component {
  render() {
    const { row } = this.props;
    const { auctionId } = this.props;

    return (
      <Query
        query={LOGGED_IN_TEAM_QUERY}
        variables={{ auction_id: auctionId }}>
        {({ data, loading, error }) => {
          if (loading) return <Loading />;
          if (error) return <Error error={error} />;
          if (data.meTeam.id != null) return (
            <TeamBidButton
              auctionId={ auctionId }
              teamId={ data.meTeam.id }
              row={ row }
            />
          );
        }}
      </Query>
    );
  }
}

class TeamBidButton extends Component {
  render() {
    const { row } = this.props;
    const { auctionId } = this.props;
    const { teamId } = this.props;

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

  const [submitBid] = useMutation(SUBMIT_BID_MUTATION);

  const handleSubmitBid = () => {
    submitBid({ variables: { auction_id: parseInt(props.auctionId, 10),
                             team_id: parseInt(props.teamId, 10),
                             player_id: parseInt(props.row.player.id, 10),
                             bid_amount: bidAmountRef.current.valueAsNumber } });
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
            { props.teamId === props.row.team.id ? "Update Bid" : "New Bid" }
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            <Form.Group controlId="formBidAmount">
              <Form.Label>Bid Amount</Form.Label>
              <Form.Control
                type="number"
                disabled={ props.teamId === props.row.team.id }
                ref={bidAmountRef}
                value={ props.row.bidAmount
                        + (props.teamId === props.row.team.id ? 0 : 1) } />
            </Form.Group>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={ handleClose }>Cancel</Button>
          <Button onClick={ handleSubmitBid }>
            { props.teamId === props.row.team.id ? "Update Bid" : "New Bid" }
          </Button>
        </Modal.Footer>
      </Modal>
      <Button
        disabled={ !props.auctionActive }
        onClick={ () => { setShow(true); }}
        variant="outline-success">
        { props.teamId === props.row.team.id ? "Update Bid" : "New Bid" }
      </Button>
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
