using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class printCODE128 {
        public static String PrintCODE128(String codeText) {
            return "\x1d\x6b\x49\x0f" + codeText;
        }
    }
}
