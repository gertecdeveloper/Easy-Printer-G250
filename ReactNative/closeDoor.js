const net = require('net')

function closeDoor(socket) {
    socket.end('\x0A');
}

export {closeDoor};

