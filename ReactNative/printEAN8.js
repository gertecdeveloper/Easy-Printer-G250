const net = require('net')

function printEAN8(socket, text) {
    socket.write('\x1d\x6b\x03'+text);
}

export {printEAN8};

