using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class printEAN13 {
        public static String PrintEAN13(String codeText) {
            return "\x1d\x6b\x02" + codeText;
        }
    }
}
