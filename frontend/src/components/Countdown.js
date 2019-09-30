import { Component } from "react";
import 'moment';

function pluralize(value) {
  return ( (value>1)?"s":"" );
}

function secondsToDaysHoursMinsSecsStr(seconds)
{ // day, h, m and s
  var days     = Math.floor(seconds / (24*60*60));
      seconds -= days    * (24*60*60);
  var hours    = Math.floor(seconds / (60*60));
      seconds -= hours   * (60*60);
  var minutes  = Math.floor(seconds / (60));
      seconds -= minutes * (60);
      seconds  = Math.floor(seconds);
  return ( ((0<days)?(days+" day"+pluralize(days)+" "):"")
          +((0<hours)?(hours+" hour"+pluralize(hours)+" "):"")
          +((0<minutes)?(minutes+" minute"+pluralize(minutes)+" "):"")
          +((minutes<2)?(seconds+" second"+pluralize(seconds)+" "):"") );
}

var moment = require('moment');

function secondsUntilExpiration(expires)
{
  var offset = moment(expires).utcOffset(expires);
  var duration = moment.duration(moment(offset).diff(moment.utc()));
  var seconds = duration.asSeconds();
  return ( seconds );
}

function getTimeRemainingString(expires) {
  var seconds = secondsUntilExpiration(expires);
  if (seconds < 0) {
    return ( "" );
  } else {
    return ( secondsToDaysHoursMinsSecsStr(seconds) );
  }
}

class Countdown extends Component {
  state = {
    timeRemainingString: getTimeRemainingString(this.props.expires)
  };

  componentDidMount() {
    this.updateState();
  }

  updateState() {
    this.setState({ timeRemainingString:
                    getTimeRemainingString(this.props.expires) });
    setTimeout(() => { this.updateState() }, 1000);
  }

  render() {
    return ( this.state.timeRemainingString );
  }
}

export default Countdown;
