const net = require('net')

function printCODE93(socket, text) {
    socket.write('\x1d\x6b\x48\x0f'+text);
}

export {printCODE93};

