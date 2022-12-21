﻿using Android.App;
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
    internal class printUPCE
    {
          public static void PrintUPCE(Socket socket, string text)
        {
            byte[] reset = Encoding.ASCII.GetBytes("\x0A");
            byte[] nBytes = Encoding.ASCII.GetBytes("\x1d\x6b\x01" + text);
           // byte[] vs = Encoding.ASCII.GetBytes("123456789909");

            socket.Send(nBytes);
           // socket.Send(vs);
            socket.Send(reset);
        }
    }
}