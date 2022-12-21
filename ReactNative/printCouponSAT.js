const net = require('net');
var XMLParser = require('react-xml-parser');
import XMLData from "../assets/teste.js";

function printCouponSAT() {
    var xml = new XMLParser().parseFromString(XMLData);
    var xmlSATOutput = xml.getElementsByTagName("cProd")[0].value;
    return xmlSATOutput;
}

export {printCouponSAT};

