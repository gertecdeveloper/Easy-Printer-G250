const net = require('net');
var XMLParser = require('react-xml-parser');
import XMLData from "../assets/teste.js";

function printCouponNFCe() {
    var xml = new XMLParser().parseFromString(XMLData);
    var xmlNFCeOutput = xml.getElementsByTagName("cProd")[0].value;
    return xmlNFCeOutput;
}

export {printCouponNFce};

