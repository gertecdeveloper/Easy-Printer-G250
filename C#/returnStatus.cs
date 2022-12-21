using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint {
    internal class returnStatus {
        public static String ReturnStatus(Object obj, int n, String bit) {
            switch (n) {
                case 1:
                    return printerStatus(bit, obj);
                case 2:
                    return offLineStatus(bit, obj);
                case 3:
                    return errorStatus(bit, obj);
                case 4:
                    return ContinuousPaperSensorStatus(bit, obj);
                default:
                    return "Invalid option for N.";
            }

            String printerStatus(String bitValue, Object ob) {
                String bin = "";

                if (obj.GetType() == typeof(SerialPort)) { 
                        SerialPort sp = (SerialPort)obj;
                        sp.Write("\x10\x04\x01");
                        bin = Convert.ToString(sp.ReadByte(), 2).PadLeft(8, '0');
                } else if (obj.GetType() == typeof(Socket)){
                        Socket sk = (Socket)obj;
                        byte[] nBytes = Encoding.Default.GetBytes("\x10\x04\x01");
                        sk.Send(nBytes);
                        byte[] buffer = new byte[8];
                        sk.Receive(buffer);
                        bin = Convert.ToString(buffer[0], 2).PadLeft(8, '0');
                }

                switch (bitValue) {
                    case "2":
                        if ((char)bin[5] == '0') {
                            return "Drawer kick-out connector pin 3 is LOW.";
                        } else {
                            return "Drawer kick-out connector pin 3 is HIGH.";
                        }
                    case "3":
                        if ((char)bin[4] == '0') {
                            return "Online.";
                        } else {
                            return "Offline.";
                        }
                    default:
                        return "Invalid option for BIT.";
                }
            }

            String offLineStatus(String bitValue, Object ob) {
                String bin = "";

                if (obj.GetType() == typeof(SerialPort)) { 
                        SerialPort sp = (SerialPort)obj;
                        sp.Write("\x10\x04\x02");
                        bin = Convert.ToString(sp.ReadByte(), 2).PadLeft(8, '0');
                } else if (obj.GetType() == typeof(Socket)){
                        Socket sk = (Socket)obj;
                        byte[] nBytes = Encoding.Default.GetBytes("\x10\x04\x02");
                        sk.Send(nBytes);
                        byte[] buffer = new byte[8];
                        sk.Receive(buffer);
                        bin = Convert.ToString(buffer[0], 2).PadLeft(8, '0');
                }

                switch (bitValue) {
                    case "2":
                        if ((char)bin[5] == '0') {
                            return "Cover is closed.";
                        } else {
                            return "Cover is open.";
                        }
                    case "3":
                        if ((char)bin[4] == '0') {
                            return "Paper is not being fed by using the FEED button.";
                        } else {
                            return "Paper is beging fed by the FEED button.";
                        }
                    case "5":
                        if ((char)bin[2] == '0') {
                            return "No paper-end stop.";
                        } else {
                            return "Printing is being stopped.";
                        }
                    case "6":
                        if ((char)bin[1] == '0') {
                            return "No error.";
                        } else {
                            return "Error occurs.";
                        }
                    default:
                        return "Invalid option for BIT";
                }
            }

            String errorStatus(String bitValue, Object ob) {
                String bin = "";

                if (obj.GetType() == typeof(SerialPort)) { 
                        SerialPort sp = (SerialPort)obj;
                        sp.Write("\x10\x04\x03");
                        bin = Convert.ToString(sp.ReadByte(), 2).PadLeft(8, '0');
                } else if (obj.GetType() == typeof(Socket)){
                        Socket sk = (Socket)obj;
                        byte[] nBytes = Encoding.Default.GetBytes("\x10\x04\x03");
                        sk.Send(nBytes);
                        byte[] buffer = new byte[8];
                        sk.Receive(buffer);
                        bin = Convert.ToString(buffer[0], 2).PadLeft(8, '0');
                }
                switch (bitValue) {
                    case "3":
                        if ((char)bin[4] == '0') {
                            return "No auto-cutter error.";
                        } else {
                            return "Auto-cutter error occurs.";
                        }
                    case "5":
                        if ((char)bin[2] == '0') {
                            return "No unrecoverable error.";
                        } else {
                            return "Unrecoverable error occurs.";
                        }
                    case "6":
                        if ((char)bin[1] == '0') {
                            return "No auto-recoverable error.";
                        } else {
                            return "Auto-recoverable error occurred.";
                        }
                    default:
                        return "Invalid option for BIT.";
                }
            }

            String ContinuousPaperSensorStatus(String bitValue, Object ob) {
                String bin = "";

                if (obj.GetType() == typeof(SerialPort)) { 
                        SerialPort sp = (SerialPort)obj;
                        sp.Write("\x10\x04\x04");
                        bin = Convert.ToString(sp.ReadByte(), 2).PadLeft(8, '0');
                } else if (obj.GetType() == typeof(Socket)){
                        Socket sk = (Socket)obj;
                        byte[] nBytes = Encoding.Default.GetBytes("\x10\x04\x04");
                        sk.Send(nBytes);
                        byte[] buffer = new byte[8];
                        sk.Receive(buffer);
                        bin = Convert.ToString(buffer[0], 2).PadLeft(8, '0');
                }

                switch (bitValue) {
                    case "2":
                        if ((char)bin[5] == '0') {
                            return "Paper roll near-end sensor:paper adequate.";
                        } else {
                            return "Paper near-end is detected by the paper roll near-end sensor.";
                        }
                    case "3":
                        if ((char)bin[4] == '0') {
                            return "Paper roll near-end sensor:paper adequate.";
                        } else {
                            return "Paper near-end is detected by the paper roll near-end sensor.";
                        }
                    case "5":
                        if ((char)bin[2] == '0') {
                            return "Paper roll sensor:Paper present.";
                        } else {
                            return "Paper roll end detected by paper roll sensor.";
                        }
                    case "6":
                        if ((char)bin[2] == '0') {
                            return "Paper roll sensor:Paper present.";
                        } else {
                            return "Paper roll end detected by paper roll sensor.";
                        }
                    default:
                        return "Invalid option for BIT.";
                }
            }

        }
    }
}
