using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;

namespace GertecEasyPrint
{
    internal class iniConfig {

        [DllImport("kernel32")]
        private static extern long WritePrivateProfileString(string section,
            string key, string val, string filePath);

        [DllImport("kernel32")]
        private static extern int GetPrivateProfileString(string section,
            string key, string def, StringBuilder retVal,
            int size, string filePath);

        static string section = Assembly.GetExecutingAssembly().GetName().Name;
        static string path = Directory.GetCurrentDirectory() + "\\" + section + ".ini";

        
        public static void IniConfig(   String serialPort,
                                        String ethernetIP, String ethernetPort,
                                        String usbVID, String usbPID) {
            if (serialPort != "") { WritePrivateProfileString("SERIAL", "SERIAL", serialPort, path); }
            if (ethernetIP != "") { WritePrivateProfileString("ETHERNET", "SERVER", ethernetIP, path); }
            if (ethernetPort != "") { WritePrivateProfileString("ETHERNET", "PORT", ethernetPort, path); }
            if (usbVID != "") { WritePrivateProfileString("USB", "VID", usbVID, path); }
            if (usbPID != "") { WritePrivateProfileString("USB", "PID", usbPID, path); }
        }

        public static String[] IniConfig() {
            String[] arrayData = new String[5];

            var readSerialPort = new StringBuilder(255);
            GetPrivateProfileString("SERIAL", "SERIAL", "", readSerialPort, 255, path);
            arrayData[0] = readSerialPort.ToString();

            var readEthernetIP = new StringBuilder(255);
            GetPrivateProfileString("ETHERNET", "SERVER", "", readEthernetIP, 255, path);
            arrayData[1] = readEthernetIP.ToString();

            var readEthernetPort = new StringBuilder(255);
            GetPrivateProfileString("ETHERNET", "PORT", "", readEthernetPort, 255, path);
            arrayData[2] = readEthernetPort.ToString();

            var readUsbVID = new StringBuilder(255);
            GetPrivateProfileString("USB", "VID", "", readUsbVID, 255, path);
            arrayData[3] = readUsbVID.ToString();

            var readUsbPID = new StringBuilder(255);
            GetPrivateProfileString("USB", "PID", "", readUsbPID, 255, path);
            arrayData[4] = readUsbPID.ToString();

            return arrayData;
        }




    }
}
