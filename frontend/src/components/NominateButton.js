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
            <NominateBidFormModal
              auctionId={ auctionId }
              teamId={ teamId }
              playerId={ playerId }
              row={ row }
              nominationsOpen={ data.team.nominationsOpen }
              subscribeToNominationsOpenChanges={ subscribeToMore }
            />
          );
        }}
      </Query>
    );
  }
}

const NominateBidFormModal = (props) => {
  const [show, setShow] = useState(false);

  const bidAmountRef = React.createRef();
  const hiddenHighBidRef = React.createRef();

  const handleClose = () => {
    setShow(false);
  }

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

  const handleSubmitBid = () => {
    submitBid({ variables: { auction_id: parseInt(props.auctionId, 10),
                             team_id: parseInt(props.teamId, 10),
                             player_id: parseInt(props.row.player.id, 10),
                             bid_amount: bidAmountRef.current.valueAsNumber,
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
            Nominate
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form>
            <Form.Group controlId="formBidAmount">
              <Form.Label>Bid Amount</Form.Label>
              <Form.Control
                type="number"
                ref={bidAmountRef} />
            </Form.Group>
            <Form.Group controlId="formHiddenHighBid">
              <Form.Label>Hidden Max Bid</Form.Label>
              <Form.Control
                type="number"
                ref={hiddenHighBidRef} />
            </Form.Group>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={ handleClose }>Cancel</Button>
          <Button onClick={ handleSubmitBid }>Nominate</Button>
        </Modal.Footer>
      </Modal>
      <Button
        disabled={ !props.nominationsOpen }
        onClick={ () => { setShow(true); }}
        variant="outline-success">
        Nominate
      </Button>
    </div>
  );
};

NominateBidFormModal.propTypes = {
  auctionId: PropTypes.number.isRequired,
  teamId: PropTypes.number.isRequired,
  playerId: PropTypes.number.isRequired,
  row: PropTypes.object.isRequired,
  nominationsOpen: PropTypes.bool.isRequired,
  subscribeToNominationsOpenChanges: PropTypes.func.isRequired,
};

export default NominateButton;
