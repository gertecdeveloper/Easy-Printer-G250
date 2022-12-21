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
    internal class openDrawer
    {
        public static void OpenDrawer(Socket socket)
        {
            byte[] nBytes = Encoding.ASCII.GetBytes("\x1b\x70\x01");
            socket.Send(nBytes);         
        }
    }
}