using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class returnModel {
        public static String ReturnModel(SerialPort serialPort) {
            serialPort.Write("\x1d\x49\x43");
            serialPort.ReadByte();
            string model = "";
            char temp;

            do {
                model += temp = (char)serialPort.ReadByte();
            } while (temp != 0);

            return model;
        }

        public static String ReturnModel(Socket socket) {
            byte[] nBytes = Encoding.ASCII.GetBytes("\x1d\x49\x43");
            byte[] buffer = new byte[256];

            socket.Send(nBytes);
            int bytesRec = socket.Receive(buffer);

            return Encoding.GetEncoding(860).GetString(buffer, 1, bytesRec);
        }



    }





}
