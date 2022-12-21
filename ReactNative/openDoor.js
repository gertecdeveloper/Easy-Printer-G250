const net = require('net');

function openDoor(host, port) {
  var socket = new net.Socket();
  socket.host = host;
  socket.port = port;
  return socket;
};

export {openDoor};
