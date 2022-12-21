const net = require('net')

function openDrawer(socket) {
    socket.write('\x1b\x70\x00\x19\x00');
}

export {openDrawer};

