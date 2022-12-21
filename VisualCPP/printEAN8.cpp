#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string printEAN8(string texto) {

    return "\x1d\x6b\x03" + texto;
    
}
