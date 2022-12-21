using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GertecEasyPrint
{
    internal class openDrawer {
        public static String OpenDrawer() {
            return "\x1b\x70\x00\x19\x00";
        }
    }
}
