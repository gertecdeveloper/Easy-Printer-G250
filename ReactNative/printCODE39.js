const net = require('net')

function printCODE39(socket, text) {
    socket.write('\x1d\x6b\x04\x43\x4f\x44\x45\x20\x33\x39\x00'+text);
}

export {printCODE39};

