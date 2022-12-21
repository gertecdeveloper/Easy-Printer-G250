using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class returnFirmware {
        public static String ReturnFirmware(SerialPort serialPort) {
            serialPort.Write("\x1d\x49\x41");
            serialPort.ReadByte();
            string firmware = "";
            char temp;

            do {
                firmware += temp = (char)serialPort.ReadByte();
            } while (temp != 0);

            return firmware;
        }

        public static String ReturnFirmware(Socket socket) {
            byte[] nBytes = Encoding.ASCII.GetBytes("\x1d\x49\x41");
            byte[] buffer = new byte[256];

            socket.Send(nBytes);
            int bytesRec = socket.Receive(buffer);

            return Encoding.GetEncoding(860).GetString(buffer, 1, bytesRec);
        }

    }
}
