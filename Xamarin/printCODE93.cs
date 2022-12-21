using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;

namespace gertecEasyPrint
{
    internal class printCODE93
    {
        public static void PrintCODE93(Socket socket, string text)
        {
            byte[] reset = Encoding.ASCII.GetBytes("\x0A");
            byte[] nBytes = Encoding.ASCII.GetBytes("\x1d\x6b\x48\x0f" + text); 
            //byte[] vs = Encoding.ASCII.GetBytes("1234ABCDEF5678");

            socket.Send(nBytes);
            //socket.Send(vs);
            socket.Send(reset);
        }
    }
}