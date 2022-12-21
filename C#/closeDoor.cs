using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class closeDoor {

        public static void CloseDoor(SerialPort serialPort) {
            serialPort.Write("\x0c");
            serialPort.Close();
        }

        public static void CloseDoor(Socket socket) {
            socket.Send(Encoding.GetEncoding(860).GetBytes("\x0c"));
            socket.Close();
        }

    }
}
