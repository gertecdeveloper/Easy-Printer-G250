const net = require('net')

function printEAN13(socket, text) {
    socket.write('\x1d\x6b\x02'+text);
}

export {printEAN13};

