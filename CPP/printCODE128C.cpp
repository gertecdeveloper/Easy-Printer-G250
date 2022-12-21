#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string printCODE128C(string texto) {

   string build = "";

    build += "\x1d\x68\x5a";
    build += "\x1d\x77\x02";
    build += "\x1d\x48\x00";
    build += "\x1d\x6b\x49\x2c";
    build += texto;

    return build;

}