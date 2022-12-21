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
    internal class printITF
    {
        public static void PrintITF(Socket socket, string text)
        {
            byte[] reset = Encoding.ASCII.GetBytes("\x0A");
            byte[] nBytes = Encoding.ASCII.GetBytes("\x1d\x6b\x46\x0f" + text);          
            //012345678901234 inserido na entrada de texto pra imprimir código
            socket.Send(nBytes);
            socket.Send(reset);
        }
    }
}