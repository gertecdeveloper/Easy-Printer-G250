#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string EncodeQRCODE(string qrText){

    string qrCode = "";

    int len = (qrText).length() + 3;
    int pl = len % 256;
    int ph = len / 256;

    string bytes1 { 29, 40, 107, 4, 0, 49, 65, 50 };
    string bytes2 { 29, 40, 107, 3, 0, 49, 67, 16 };
    string bytes3 { 29, 40, 107, 3, 0, 49, 69, 48 };
    string bytes4 { 29, 40, 107, (char)pl, (char)ph, 49, 80, 48 };
    string bytes5 { 29, 40, 107, 3, 0, 49, 81, 48 };

    qrCode += bytes1;
    qrCode += bytes2;
    qrCode += bytes3;
    qrCode += bytes4;
    qrCode += qrText;
    qrCode += bytes5;
    
    string result(qrCode, sizeof(qrCode));

    return result;

}

string printQRCODE(string texto){

    //serialPort << EncodeQRCODE(texto) << endl;

    return EncodeQRCODE(texto);

}