const net = require('net')

function printQRCODE(socket, text) {
    var qrCODE = '';
    var len = text.length + 3;
    var pl = len % 256;
    var ph = ~~(len / 256);

    qrCODE += String.fromCharCode.apply(null, [29, 40, 107, 4, 0, 49, 65, 50, 0]);
    qrCODE += String.fromCharCode.apply(null, [29, 40, 107, 3, 0, 49, 67, 8]);
    qrCODE += String.fromCharCode.apply(null, [29, 40, 107, 3, 0, 49, 69, 48]);
    qrCODE += String.fromCharCode.apply(null, [29, 40, 107, pl, ph, 49, 80, 48]);
    qrCODE += text;
    qrCODE += String.fromCharCode.apply(null, [29, 40, 107, 3, 0, 49, 81, 48]);
    socket.write(qrCODE);
}

export {printQRCODE};

