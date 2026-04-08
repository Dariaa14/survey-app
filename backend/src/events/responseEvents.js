const EventEmitter = require('events');

class ResponseEmitter extends EventEmitter {}

const responseEvents = new ResponseEmitter();

module.exports = responseEvents;