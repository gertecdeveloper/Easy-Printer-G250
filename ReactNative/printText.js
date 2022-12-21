const net = require('net')

function printText(socket, text) {
    socket.write(text);
}

export {printText};

