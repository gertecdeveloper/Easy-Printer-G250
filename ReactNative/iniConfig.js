const net = require('net');
var XMLParser = require('react-xml-parser');
import XMLData from "../assets/iniConfig.js";

function iniConfig(socket) {
    var iniData = new XMLParser().parseFromString(XMLData);
    var iniDataOutput = iniData.getElementsByTagName("iniConfig")[0].value;
    return iniDataOutput;
}

export {iniConfig};

