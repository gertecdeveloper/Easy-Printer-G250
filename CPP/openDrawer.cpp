#include <iostream>
#include <fstream>
#include <string>

using namespace std;

void openDrawer(fstream& serialPort){

    serialPort << "\x1b\x70\x01" << endl;
    
} 