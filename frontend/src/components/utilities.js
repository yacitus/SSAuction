import 'moment';

var moment = require('moment');

export function pluralize(value) {
  return ( (value>1)?"s":"" );
}

export function secondsToDaysHoursMinsSecsStr(seconds)
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
          +((minutes<2 && hours===0 && days===0)
            ?(seconds+" second"+pluralize(seconds)+" "):"") );
}

export function secondsUntilExpiration(expires)
{
  var offset = moment(expires).utcOffset(expires);
  var duration = moment.duration(moment(offset).diff(moment.utc()));
  var seconds = duration.asSeconds();
  return ( seconds );
}

export function getTimeRemainingString(expires) {
  var seconds = secondsUntilExpiration(expires);
  if (seconds < 0) {
    return ( "" );
  } else {
    return ( secondsToDaysHoursMinsSecsStr(seconds) );
  }
}
