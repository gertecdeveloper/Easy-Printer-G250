using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class printCustomBarCode {
        public static String PrintCustomBarCode(int height, int width, int hri,
                                                String systemBarCode, String value) {
            
            switch (systemBarCode) {
                case "CODE128":
                    return BuildCustomBarCode("\x1d\x6b\x49\x0f"); 
                case "CODE39":
                    return BuildCustomBarCode("\x1d\x6b\x04\x43\x4f\x44\x45\x20\x33\x39\x00");
                case "CODE93":
                    return BuildCustomBarCode("\x1d\x6b\x48\x0f");
                case "EAN13":
                    return BuildCustomBarCode("\x1d\x6b\x02");
                case "EAN8":
                    return BuildCustomBarCode("\x1d\x6b\x03");
                case "ITF":
                    return BuildCustomBarCode("\x1d\x6b\x46\x0f");
                case "UPCA":
                    return BuildCustomBarCode("\x1d\x6b\x00");
                case "UPCE":
                    return BuildCustomBarCode("\x1d\x6b\x01");
                default:
                    return "Invalid option for System Bar Code.";
            }

            String BuildCustomBarCode(String hexCommand) {
                String hriPreCommand = "\x1d\x48";
                String heightPreCommand = "\x1d\x68";
                String widthPreCommand = "\x1d\x77";
                int[] hriOptions = { 0, 1, 2, 3 };
                bool heightCheck = false;
                int[] widthOptions = { 1, 2, 3, 4, 5, 6 };
                 
                for (int i = 1; i <= 255; i++) {
                    if(i == height) {
                        heightCheck = true;
                    }
                }

                if (hriOptions.Contains(hri) == false) {
                    return "Invalid option for HRI";
                } else if (heightCheck == false) {
                    return "Invalid option for HEIGHT";
                } else if (widthOptions.Contains(width) == false) {
                    return "Invalid option for WIDTH";
                }

                String  customBarCode = hriPreCommand;
                        customBarCode += (char)hri;
                        customBarCode += heightPreCommand;
                        customBarCode += (char)height;
                        customBarCode += widthPreCommand;
                        customBarCode += (char)width;
                        customBarCode += hexCommand;
                        customBarCode += value;
                return customBarCode;
            }
        }
    }
}
