using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class printITF {
        public static String PrintITF(String codeText) {
            return "\x1d\x6b\x46\x0f" + codeText;
        }
    }
}

