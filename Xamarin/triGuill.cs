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
    internal class triGuill
    {
        public static void TrigGuill(Socket socket)
        {
            byte[] reset = Encoding.ASCII.GetBytes("\x0A");
            byte[] nBytes = Encoding.ASCII.GetBytes("\x1d\x56\x41");
            socket.Send(nBytes);
            socket.Send(reset);
        }


    }
}