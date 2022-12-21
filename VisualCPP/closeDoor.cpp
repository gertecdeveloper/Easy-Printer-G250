#include <iostream>
#include <fstream>
#include <string>
#include <WS2tcpip.h>
#pragma comment(lib, "ws2_32.lib")

using namespace std;

void closeDoor(fstream& serialPort) {
    serialPort << "\x0a";
    serialPort.close();

}

void closeDoorRede(SOCKET sock) {

	closesocket(sock);

}
