#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string printITF(string texto) {

    return "\x1d\x6b\x46\x0f" + texto;

}