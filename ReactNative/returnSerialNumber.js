const net = require('net')

import {NativeModules} from 'react-native';
const {NativeAndroid} = NativeModules;

function returnSerialNumber(socket) {
    var serialNumber = NativeAndroid.GetPrinterInfo('\x1d\x49\x44');
    socket.write(serialNumber);
}

export {returnSerialNumber};

