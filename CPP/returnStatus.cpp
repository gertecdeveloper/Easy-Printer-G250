#include <string>
#include <iostream>
#include <fstream>
#include <arpa/inet.h>

using namespace std;

int returnStatus(){

    ofstream serial("/dev/usb/lp0");

    string ipAddress = "192.168.123.100";
    int port = 9100;
    string text = "\x10\x04\x01";

    int sock = socket(AF_INET, SOCK_STREAM, 0);

    sockaddr_in hint;
    hint.sin_family = AF_INET;
    hint.sin_port = htons(port);
    inet_pton(AF_INET, ipAddress.c_str(), &hint.sin_addr);

    connect(sock, (sockaddr*)&hint, sizeof(hint));

    send(sock, text.c_str(), text.size(), 0);

    char buf[4096];

    int bytesReceived = recv(sock, buf, 4096, 0);
        
    cout << string(buf, 1, bytesReceived) << endl;
}

int main(){

    returnStatus();
   
}