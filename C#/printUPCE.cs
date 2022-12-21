using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class printUPCE {
        public static String PrintUPCE(String codeText) {
            return "\x1d\x6b\x01" + codeText;
        }
    }
}
