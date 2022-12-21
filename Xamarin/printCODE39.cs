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
    internal class printCODE39
    {

        public static void PrintCODE39(Socket socket, string text)
        {   
            byte[] reset = Encoding.ASCII.GetBytes("\x0A");
            byte[] nBytes = Encoding.ASCII.GetBytes("\x1d\x6b\x04\x43\x4f\x44\x45\x20\x33\x39\x00" + text); 
            //byte[] vs = Encoding.ASCII.GetBytes("*ABCDEF12345678912345*");

            socket.Send(nBytes);
            //socket.Send(vs);
            socket.Send(reset);
        }
    }
}