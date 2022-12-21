using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Ports;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint {
    internal class printText {

        public static String PrintText(String texto) {
            return TagsConvert(texto);
        }

        public const string boldOff = "\x1b\x45\x00";     // </ne>
        public const string boldOn = "\x1b\x45\x01";     // <ne>

        public const string underlineOff = "\x1b\x2d\x00";     // </su>
        public const string underlineOn = "\x1b\x2d\x01";     // <su>

        public const string alignOff = "\x1b\x61\x00";     // </alc> </ald>
        public const string centerOn = "\x1b\x61\x01";     // <alc>
        public const string rightOn = "\x1b\x61\x02";     // <ald>

        public const string expandedOff = "\x1b\x20\x00";     // </ex>
        public const string expandedOn = "\x1b\x20\x10";     // <ex>

        public const string doubleOff = "\x1b\x21\x00";     // </da> </dl>  </dal>
        public const string doubleHOn = "\x1b\x21\x10";     // <da>
        public const string doubleWOn = "\x1b\x21\x20";     // <dl>
        public const string doubleHWOn = "\x1b\x21\x30";     // <dal>

        public const string smallFontOff = "\x1b\x4d\x00";     // </c>
        public const string smallFontOn = "\x1b\x4d\x01";     // <c>

        public const string invertOff = "\x1d\x42\x00";     // </fi>
        public const string invertOn = "\x1d\x42\x01";     // <fi>

        public const string fullCut = "\x1d\x56\x41";    // <gui>
        public const string lineFeed = "\x0a"; 

        static String TagsConvert(String tagText) {
            string convertText = tagText.   Replace("<ne>", boldOn).Replace("</ne>", boldOff).
                                            Replace("<su>", underlineOn).Replace("</su>", underlineOff).
                                            Replace("<alc>", centerOn).Replace("</alc>", alignOff).
                                            Replace("<ald>", rightOn).Replace("</ald>", alignOff).
                                            Replace("<ex>", expandedOn).Replace("</ex>", expandedOff).
                                            Replace("<da>", doubleHOn).Replace("</da>", doubleOff).
                                            Replace("<dl>", doubleWOn).Replace("</dl>", doubleOff).
                                            Replace("<dal>", doubleHWOn).Replace("</dal>", doubleOff).
                                            Replace("<c>", smallFontOn).Replace("</c>", smallFontOff).
                                            Replace("<fi>", invertOn).Replace("</fi>", invertOff).
                                            Replace("<gui>", fullCut).Replace("<lf>", lineFeed);
            return convertText;
        }
    }
}
