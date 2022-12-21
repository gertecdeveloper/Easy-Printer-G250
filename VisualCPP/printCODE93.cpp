#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string printCODE93(string texto) {

    return "\x1d\x6b\x48\x0f" + texto;

}