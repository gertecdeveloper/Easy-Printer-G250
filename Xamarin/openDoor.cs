using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;


namespace gertecEasyPrint
{
    internal class openDoor
    {
        
        private static Socket socket;
        private static IPAddress ipAddress;
        private static IPEndPoint ipEndPoint;
        

        public static Socket OpenDoor(String ip, int port)
        {
            socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            socket.NoDelay = true;
            ipAddress = IPAddress.Parse(ip);
            ipEndPoint = new IPEndPoint(ipAddress, port);
            socket.Connect(ipEndPoint);
            
            return socket;
        }



    }
}