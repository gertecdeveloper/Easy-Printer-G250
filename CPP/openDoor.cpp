#include <iostream>
#include <fstream>
#include <string>
#include <arpa/inet.h>
#include <string>

using namespace std;

fstream openDoor(string port) {

		fstream serialPort;
		serialPort.open(port);
		return serialPort;		
}

int openDoorRede(string ipAddress, int port, string texto){

    int sock = socket(AF_INET, SOCK_STREAM, 0);

    sockaddr_in hint;
    hint.sin_family = AF_INET;
    hint.sin_port = htons(port);
    inet_pton(AF_INET, ipAddress.c_str(), &hint.sin_addr);

    int connResult = connect(sock, (sockaddr*)&hint, sizeof(hint));

    int sendResult = send(sock, texto.c_str(), texto.size(), 0);

}