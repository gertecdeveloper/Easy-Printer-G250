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
    internal class printCODE128
    {
        public static void PrintCODE128(Socket socket, string text)
        {
            byte[] reset = Encoding.ASCII.GetBytes("\x0A");
            byte[] nBytes = Encoding.ASCII.GetBytes("\x1d\x6b\x49\x0f" + text);
            //123456789012345 inserido na entrada de texto pra imprimir código
            socket.Send(nBytes);
            socket.Send(reset);
        }
    }
}