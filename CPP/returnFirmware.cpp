#include <arpa/inet.h>
#include <string>
#include <fstream>
#include <iostream>

using namespace std;

int returnFirmware(){

    ofstream serial("/dev/usb/lp0");

    string ipAddress = "192.168.10.10";
    int port = 9100;
    string text = "\x1d\x49\x41";

    int sock = socket(AF_INET, SOCK_STREAM, 0);

    sockaddr_in hint;
    hint.sin_family = AF_INET;
    hint.sin_port = htons(port);
    inet_pton(AF_INET, ipAddress.c_str(), &hint.sin_addr);

    connect(sock, (sockaddr*)&hint, sizeof(hint));

    send(sock, text.c_str(), text.size(), 0);

    char buf[4096];

    int bytesReceived = recv(sock, buf, 4096, 0);
        
    serial << "Firmware: " << string(buf, 1, bytesReceived) << endl;
}