#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string printUPCE(string texto) {

    return "\x1d\x6b\x01" + texto;

}
