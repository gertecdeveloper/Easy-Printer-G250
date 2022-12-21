#include <iostream>
#include <fstream>
#include <string>

using namespace std;

void iniConfig(string way, string porta, string ip){

    ofstream write_arq("GertecEasyPrinter.ini");

    write_arq << way << endl;
    write_arq << porta << endl;
    write_arq << ip << endl;
}