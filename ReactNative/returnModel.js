const net = require('net')

import {NativeModules} from 'react-native';
const {NativeAndroid} = NativeModules;

function returnModel(socket) {
    var model = NativeAndroid.GetPrinterInfo('\x1d\x49\x43');
    socket.write(model);
}

export {returnModel};

