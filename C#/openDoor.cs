using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using Windows.Devices.Usb;

namespace GertecEasyPrint
{
    internal class openDoor {

        private static SerialPort serialPort;
        private static Socket socket;
        private static IPAddress ipAddress;
        private static IPEndPoint ipEndPoint;

        private static UsbDevice usbDevice;

        public static SerialPort OpenDoor(String portName) {
            serialPort = new SerialPort(portName);
            serialPort.BaudRate = 9600;
            serialPort.Open();
            serialPort.Encoding = Encoding.GetEncoding(860);
            //serialPort.Write("\x1b\x40");
            return serialPort;
        }

        public static Socket OpenDoor(String ip, int port) {
            socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            socket.NoDelay = true;
            ipAddress = IPAddress.Parse(ip);
            ipEndPoint = new IPEndPoint(ipAddress, port);
            socket.Connect(ipEndPoint);
            //encoding = Encoding.GetEncoding(860);
            return socket;
        }

        public static Socket OpenDoor(IPEndPoint ipEndPoint) {
            socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            socket.NoDelay = true;
            socket.Connect(ipEndPoint);
            //encoding = Encoding.GetEncoding(860);
            return socket;
        }

       /* public static UsbDevice OpenDoor(UsbDevice usbDevice) {
            socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            socket.NoDelay = true;
            socket.Connect(ipEndPoint);
            //encoding = Encoding.GetEncoding(860);
            return socket;
        }*/

    }
}
