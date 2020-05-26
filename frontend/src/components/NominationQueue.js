import React, { Component } from "react";
import NominationQueueTable from "../components/NominationQueueTable";
import NominationQueuePlayerSearch from "../components/NominationQueuePlayerSearch";

class NominationQueue extends Component {
  render() {
    const teamId = parseInt(this.props.teamId, 10);
    const auctionId = parseInt(this.props.auctionId, 10);

    return (
      <div>
        <NominationQueueTable
          teamId={ teamId }
          auctionId={ auctionId } />
        <NominationQueuePlayerSearch
          teamId={ teamId } />
      </div>
    );
  }
}

export default NominationQueue;
