using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.IO.Ports;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class sendBinBuffer {
        public static String SendBinBuffer(String binBuffer) {
            List<Byte> byteList = new List<Byte>();

            for (int i = 0; i < binBuffer.Length; i += 8) {
                byteList.Add(Convert.ToByte(binBuffer.Substring(i, 8), 2));
            }

            return Regex.Unescape(Encoding.Default.GetString(byteList.ToArray()));
        }
    }
}
