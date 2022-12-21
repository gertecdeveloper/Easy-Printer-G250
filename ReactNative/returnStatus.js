const net = require('net')

import {NativeModules} from 'react-native';
const {NativeAndroid} = NativeModules;

function returnStatus(socket) {
    var status = NativeAndroid.GetPrinterStatus(socket.host, socket.port,'\x10\x04\x01');
    if(status.charAt(3) == '0'){
        return 'Online';
    } else if (status.charAt(3) == '1'){
        return 'Offline';
    } else{
        return '';
    }
}

export {returnStatus};

