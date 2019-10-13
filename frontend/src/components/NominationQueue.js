import React, { Component } from "react";
import Container from "react-bootstrap/Container";
import NominationQueueTable from "../components/NominationQueueTable";
import NominationQueuePlayerSearch from "../components/NominationQueuePlayerSearch";

class NominationQueue extends Component {
  render() {
    const teamId = parseInt(this.props.teamId, 10);

    return (
      <Container>
        <NominationQueueTable
          teamId={ teamId } />
        <NominationQueuePlayerSearch
          teamId={ teamId } />
      </Container>
    );
  }
}

export default NominationQueue;
