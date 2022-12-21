const net = require('net')

import {NativeModules} from 'react-native';
const {NativeAndroid} = NativeModules;

function statusDrawer(socket) {
    var status = NativeAndroid.GetPrinterStatus('\x10\x04\x01');
    if(status[5] == 0){
        socket.write('Drawer kick-out connector pin 3 is LOW');
    } else {
        socket.write('Drawer kick-out connector pin 3 is LOW');
    }
}

export {statusDrawer};

