#include <iostream>
#include <fstream>
#include <string>
#include <arpa/inet.h>

using namespace std;

void closeDoor(fstream& serialPort) {
    serialPort << "\x0a";
    serialPort.close();
}

void closeDoorRede(SOCKET sock) {

	closesocket(sock);

}
