const net = require('net')

function trigGuill(socket) {
    socket.write('\x1d\x56\x41');
}

export {trigGuill};

