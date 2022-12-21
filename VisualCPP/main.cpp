#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\openDoor.cpp> //camiho do arquivo .cpp
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\closeDoor.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\printText.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\trigGuill.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\printCODE128.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\printCODE39.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\printCODE93.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\printEAN8.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\printEAN13.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\printITF.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\printUPCA.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\printUPCE.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\printQRCODE.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\openDrawer.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\iniConfig.cpp>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\returnFirmware.cpp>
//#include </home/bruno/Área de Trabalho/Marcus/c++/returnModel.cpp>            //usado individualmente
//#include </home/bruno/Área de Trabalho/Marcus/c++/returnSerialNumber.cpp>     //usado individualmente
//#include </home/bruno/Área de Trabalho/Marcus/c++/statusDrawer.cpp>           //usado individualmente

using namespace std;

int main(){

    fstream sp = openDoor("COM3");

    //openDoorRede("192.168.0.10", 9100, printUPCE("012345678901"));

    //sp << printText("<ne>Negrito</ne>\n<ce>Centralizado</ce>");
    //sp << printText("<ad>Direita</ad>\n<su>Sublinahdo</su>");
    //sp << printText("<ex>Expandido</ex>\n<c>Fonte Pequena</c>");
    //sp << printText("<da>Altura Dupla</da>\n<dl>Largura Dupla</dl>");
    //sp << printText("<dal>Altura e Largura Dupla</dal>\n<fi>Fonte Invertida</fi>");

    //sp << printCODE39("123456789");

    //sp << printCODE128("012345678901234");

    //sp << printCODE93("012345678901234");

    //sp << printEAN8("01234567");

    //sp << printEAN13("0123456789012");

    //sp << printITF("012345678901234");

    //sp << printUPCA("012345678910");

    //sp << printUPCE("012345678901");

    //sp << printQRCODE("Hakuna Matata");

    //sp << TrigGuill();

    //sp << openDrawer();

    //sp << sendBinBuffer("Buffer");

    //closeDoor(sp);

    //iniConfig("/dev/usb/lp0", "9100", "192.168.123.100");

    //returnFirmware();

    //returnModel();

    //returnSerialNumber();

    //statusDrawer();

    //openDrawer(sp);

}
