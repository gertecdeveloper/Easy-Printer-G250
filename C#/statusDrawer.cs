using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class statusDrawer {
        public static String StatusDrawer(SerialPort serialPort) {
            serialPort.Write("\x10\x04\x01");
            string bin = Convert.ToString(serialPort.ReadByte(), 2).PadLeft(8, '0');
            if ((char)bin[5] == '0') {
                return "Drawer kick-out connector pin 3 is LOW";
            } else {
                return "Drawer kick-out connector pin 3 is HIGH";
            }
        }

        public static String StatusDrawer(Socket socket) {
            byte[] nBytes = Encoding.ASCII.GetBytes("\x10\x04\x01");
            socket.Send(nBytes);
            byte[] buffer = new byte[8];
            socket.Receive(buffer);
            string bin = Convert.ToString(buffer[0], 2).PadLeft(8, '0');
            if ((char)bin[5] == '0') {
                return "Drawer kick-out connector pin 3 is LOW";
            } else {
                return "Drawer kick-out connector pin 3 is HIGH";
            }
        }




    }
}
