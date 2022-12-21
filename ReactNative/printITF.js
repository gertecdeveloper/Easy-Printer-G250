const net = require('net')

function printITF(socket, text) {
    socket.write('\x1d\x6b\x46\x0f'+text);
}

export {printITF};

