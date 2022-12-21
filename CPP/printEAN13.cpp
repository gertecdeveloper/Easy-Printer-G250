#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string printEAN13(string texto) {

    return "\x1d\x6b\x02" + texto;

}
