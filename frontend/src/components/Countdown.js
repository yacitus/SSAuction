import { Component } from "react";
import * as Utilities from "../components/utilities.js";

class Countdown extends Component {
  state = {
    timeRemainingString: Utilities.getTimeRemainingString(this.props.expires)
  };

  componentDidMount() {
    this.updateState();
  }

  updateState() {
    this.setState({ timeRemainingString:
                    Utilities.getTimeRemainingString(this.props.expires) });
    this.timeout = setTimeout(() => { this.updateState() }, 1000);
  }

  componentWillUnmount() {
    clearTimeout(this.timeout);
  };

  render() {
    return ( this.state.timeRemainingString );
  }
}

export default Countdown;
