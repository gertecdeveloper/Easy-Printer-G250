const net = require('net')

function printCODE128(socket, text) {
    socket.write('\x1d\x6b\x49\x0f'+text);
}

export {printCODE128};

