const net = require('net')

function sendBinBuffer(socket, buffer) {
    socket.write(buffer);
}

export {sendBinBuffer};

