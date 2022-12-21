using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class printCODE39 {
        public static String PrintCODE39(String codeText) {
            return "\x1d\x6b\x04\x43\x4f\x44\x45\x20\x33\x39\x00" + codeText;
        }
    }
}
