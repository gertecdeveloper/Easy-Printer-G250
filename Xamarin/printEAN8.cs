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
    internal class printEAN8
    {

        public static void PrintEAN8(Socket socket, string codeText)
        {
            byte[] reset = Encoding.ASCII.GetBytes("\x0A");
            byte[] nBytes = Encoding.ASCII.GetBytes("\x1d\x6b\x03" + codeText); 
            //byte[] vs = Encoding.ASCII.GetBytes("12345678");
            
            socket.Send(nBytes);
            //socket.Send(vs);
            socket.Send(reset);
        
        }       
    }
}