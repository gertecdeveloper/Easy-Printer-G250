using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class printQRCODE {
        public static String PrintQRCODE(String qrText) {
            return EncodeQRCODE(qrText);
        }

        public static void PrintQRCODE(SerialPort serialPort, String qrText) {
            serialPort.Write(EncodeQRCODE(qrText));
        }

        public static void PrintQRCODE(Socket socket, String qrText) {
            byte[] nBytes = Encoding.GetEncoding(860).GetBytes(EncodeQRCODE(qrText));
            socket.Send(nBytes);
        }

        public static string EncodeQRCODE(String qrText) {
            string qrCode = "";
            int len = (qrText).Length + 3;
            byte pl = (byte)(len % 256);
            byte ph = (byte)(len / 256);

            Encoding m_encoding = Encoding.GetEncoding("iso-8859-1");
            qrCode += m_encoding.GetString(new byte[] { 29, 40, 107, 4, 0, 49, 65, 50, 0 });
            qrCode += m_encoding.GetString(new byte[] { 29, 40, 107, 3, 0, 49, 67, 4 });
            qrCode += m_encoding.GetString(new byte[] { 29, 40, 107, 3, 0, 49, 69, 48 });
            qrCode += m_encoding.GetString(new byte[] { 29, 40, 107, pl, ph, 49, 80, 48 });
            qrCode += qrText;
            qrCode += m_encoding.GetString(new byte[] { 29, 40, 107, 3, 0, 49, 81, 48 });
            return qrCode;
        }



    }
}
