const net = require('net')

import {NativeModules} from 'react-native';
const {NativeAndroid} = NativeModules;

function returnFirmware(socket) {
    var firmware = NativeAndroid.GetPrinterInfo('\x1d\x49\x41');
    socket.write(firmware);
}

export {returnFirmware};

