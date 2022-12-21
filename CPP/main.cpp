#include </home/bruno/Área de Trabalho/Marcus/c++/openDoor.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/closeDoor.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/printText.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/trigGuill.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/printCODE128.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/printCODE128C.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/printCODE39.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/printCODE93.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/printEAN8.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/printEAN13.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/printITF.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/printUPCA.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/printUPCE.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/printQRCODE.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/openDrawer.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/iniConfig.cpp>
#include </home/bruno/Área de Trabalho/Marcus/c++/returnFirmware.cpp>
//#include </home/bruno/Área de Trabalho/Marcus/c++/returnModel.cpp>
//#include </home/bruno/Área de Trabalho/Marcus/c++/returnSerialNumber.cpp>
//#include </home/bruno/Área de Trabalho/Marcus/c++/statusDrawer.cpp>


using namespace std;

int main(){

    fstream sp = openDoor("/dev/usb/lp0");

    //openDoorRede("192.168.0.10", 9100, printUPCE("012345678901"));

    //sp << printText("<ne>Negrito</ne>\n<ce>Centralizado</ce>");
    //sp << printText("<ad>Direita</ad>\n<su>Sublinahdo</su>");
    //sp << printText("<ex>Expandido</ex>\n<c>Fonte Pequena</c>");
    //sp << printText("<da>Altura Dupla</da>\n<dl>Largura Dupla</dl>");
    //sp << printText("<dal>Altura e Largura Dupla</dal>\n<fi>Fonte Invertida</fi>");

    //sp << printCODE39("123456789");

    //sp << printCODE128("012345678901234");

    //sp << printCODE128C("012345678901234");

    //sp << printCODE93("012345678901234");

    //sp << printEAN8("01234567");

    //sp << printEAN13("0123456789012");

    //sp << printITF("012345678901234");

    //sp << printUPCA("012345678910");

    //sp << printUPCE("012345678901");

    //sp << printQRCODE("Hakuna Matata");

    //sp << TrigGuill();

    //sp << openDrawer();

    //closeDoor(sp);

    //iniConfig("/dev/usb/lp0", "9100", "192.168.123.100");

    //returnFirmware();

    //returnModel();

    //returnSerialNumber();

    //statusDrawer();

}
