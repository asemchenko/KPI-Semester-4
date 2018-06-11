using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab02
{
    class MyEventArgs : System.EventArgs
    {
        public MyEventArgs(String str)
        {
            Info = str;
        }
        public String toString()
        {
            return Info;
        }
        private String Info;
    }
}
