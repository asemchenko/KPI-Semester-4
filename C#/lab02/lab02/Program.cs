using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab02
{
    class Program
    {
        static void Main(string[] args)
        {
            Airport airport = new Airport();
            airport.Add(new Freighter());
            airport.Add(new Helicopter());
            airport.Add(new Plane());
            System.Console.WriteLine(airport.ToString());
            airport.RemoveAt(0);
            System.Console.WriteLine(airport.ToString());
        }
    }
}
