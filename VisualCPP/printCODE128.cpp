#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string printCODE128(string texto) {

    return "\x1d\x6b\x49\x0f" + texto;

}