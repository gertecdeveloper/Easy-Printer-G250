#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string printCODE39(string texto) {

    string codebar_code39 = {0x1D,0x6B,0x04,0x45,0x00};
    
    return codebar_code39 + texto;
}