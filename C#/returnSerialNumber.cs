using System;
using System.Collections;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint {
    internal class returnSerialNumber {
        public static String ReturnSerialNumber(SerialPort serialPort){
            serialPort.Write("\x1d\x49\x44"); 
            serialPort.ReadByte();
            string serialNumber = "";
            char temp;
            
            do {
                temp = (char)serialPort.ReadByte();
                serialNumber += temp;
            } while (temp != 0);

            return serialNumber;
        }

        public static String ReturnSerialNumber(Socket socket) {
            byte[] nBytes = Encoding.ASCII.GetBytes("\x1d\x49\x44");
            byte[] buffer = new byte[256];

            socket.Send(nBytes);
            int bytesRec = socket.Receive(buffer);

            return Encoding.GetEncoding(860).GetString(buffer, 1, bytesRec);
        }

    }
}
