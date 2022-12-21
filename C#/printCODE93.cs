using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class printCODE93 {
        public static String PrintCODE93(String codeText) {
            return "\x1d\x6b\x48\x0f" + codeText;
        }
    }
}
