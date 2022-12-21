using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class printCODE128C {
        public static String PrintCODE128C(String codeText) {
            String build = "";
            build += "\x1d\x68\x5a"; //altura
            build += "\x1d\x77\x02"; //largura
            build += "\x1d\x48\x00"; //hri
            build += "\x1d\x6b\x49\x2c"; //CODE128C
            build += codeText;
            return build;
        }
    }
}
