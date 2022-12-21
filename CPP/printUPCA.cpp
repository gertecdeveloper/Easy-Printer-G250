#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string printUPCA(string texto) {

    string codebar_codeUPCA = {0x1D,0x6B,0};

    return codebar_codeUPCA + texto;

}