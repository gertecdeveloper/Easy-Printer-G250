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
    internal class printQRCODE
    {
        public static void PrintQRCODE(Socket socket, String qrText)
        {
            string qrCode = "";
            int len = (qrText).Length + 3;
            byte pl = (byte)(len % 256);
            byte ph = (byte)(len / 256);

            Encoding m_encoding = Encoding.GetEncoding("iso-8859-1");
            qrCode += m_encoding.GetString(new byte[] { 29, 40, 107, 4, 0, 49, 65, 50, 0 });
            qrCode += m_encoding.GetString(new byte[] { 29, 40, 107, 3, 0, 49, 67, 8 });
            qrCode += m_encoding.GetString(new byte[] { 29, 40, 107, 3, 0, 49, 69, 48 });
            qrCode += m_encoding.GetString(new byte[] { 29, 40, 107, pl, ph, 49, 80, 48 });
            qrCode += qrText;
            qrCode += m_encoding.GetString(new byte[] { 29, 40, 107, 3, 0, 49, 81, 48 });

            byte[] reset = Encoding.ASCII.GetBytes("\x0A");
            byte[] nBytes = Encoding.ASCII.GetBytes(qrCode);
            socket.Send(nBytes);
            socket.Send(reset);
        }
    }
}