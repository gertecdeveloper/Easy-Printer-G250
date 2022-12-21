using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.IO.Ports;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint {
    internal class printBITMAP {

        public static void PrintBITMAP(SerialPort serialPort, String filePath) {
            serialPort.WriteLine(EncodeBitmap(filePath));
        }

        public static void PrintBITMAP(Socket socket, String filePath) {
            byte[] nBytes = Encoding.GetEncoding(860).GetBytes(EncodeBitmap(filePath));
            socket.Send(nBytes);
        }

        public static String PrintBITMAP(String filePath) {
            return EncodeBitmap(filePath);
        }


        public static string EncodeBitmap(String filePath) {

            if (!File.Exists(filePath))
                return null;

            string r_bitmap = "";
            BitArray dots;
            int xHeight;
            int xWidth;

            using (var bitmap = (Bitmap)Bitmap.FromFile(filePath)) {
                var threshold = 127;
                var index = 0;
                double multiplier = 570;
                double scale = (double)(multiplier / (double)bitmap.Width);
                int xheight = (int)(bitmap.Height * scale);
                int xwidth = (int)(bitmap.Width * scale);
                var dimensions = xwidth * xheight;
                dots = new BitArray(dimensions);

                for (var y = 0; y < xheight; y++) {
                    for (var x = 0; x < xwidth; x++) {
                        var _x = (int)(x / scale);
                        var _y = (int)(y / scale);
                        var color = bitmap.GetPixel(_x, _y);
                        var luminance = (int)(color.R * 0.3 + color.G * 0.59 + color.B * 0.11);
                        dots[index] = (luminance < threshold);
                        index++;
                    }
                }

                xHeight = (int)(bitmap.Height * scale);
                xWidth = (int)(bitmap.Width * scale);
            }

            byte[] width = BitConverter.GetBytes(xWidth);
            int desloc = 0;

            MemoryStream stream = new MemoryStream();
            BinaryWriter bw = new BinaryWriter(stream);
            bw.Write((char)0x1B);
            bw.Write('@');
            bw.Write((char)0x1B);
            bw.Write('3');
            bw.Write((byte)24);

            while (desloc < xHeight) {
                bw.Write((char)0x1B);
                bw.Write('*');
                bw.Write((byte)33);
                bw.Write(width[0]);
                bw.Write(width[1]);

                for (int x = 0; x < xWidth; ++x) {
                    for (int k = 0; k < 3; ++k) {
                        byte slice = 0;
                        for (int b = 0; b < 8; ++b) {
                            int y = (((desloc / 8) + k) * 8) + b;
                            int i = (y * xWidth) + x;
                            bool v = false;
                            if (i < dots.Length) {
                                v = dots[i];
                            }
                            slice |= (byte)((v ? 1 : 0) << (7 - b));
                        }

                        bw.Write(slice);
                    }
                }
                desloc += 24;
                bw.Write((char)0x0A);
            }

            bw.Write((char)0x1B);
            bw.Write('3');
            bw.Write((byte)30);

            bw.Flush();
            byte[] bytes = stream.ToArray();
            return r_bitmap + Encoding.Default.GetString(bytes);
        }

    }
}
