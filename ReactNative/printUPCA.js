const net = require('net')

function printUPCA(socket, text) {
    socket.write('\x1d\x6b\x00'+text);
}

export {printUPCA};

