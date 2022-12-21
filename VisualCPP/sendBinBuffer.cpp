#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string sendBinBuffer(string buffer) {

    string bff = "\x0a" + buffer;

    return bff;
    
}

