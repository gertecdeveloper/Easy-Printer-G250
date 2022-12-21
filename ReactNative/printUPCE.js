const net = require('net')

function printUPCE(socket, text) {
    socket.write('\x1d\x6b\x01'+text);
}

export {printUPCE};

