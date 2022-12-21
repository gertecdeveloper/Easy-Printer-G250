using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class printEAN8 {
        public static String PrintEAN8(String codeText) {
            return "\x1d\x6b\x03" + codeText;
        }
    }
}
