using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class printUPCA {
        public static String PrintUPCA(String codeText) {
            return "\x1d\x6b\x00" + codeText;
        }

    }
}
