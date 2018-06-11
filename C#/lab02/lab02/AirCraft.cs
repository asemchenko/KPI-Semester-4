using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading.Tasks;

namespace lab02
{
    abstract class AirCraft : Object
    {
        protected int Cost { get; set; }
        protected double Max_speed_meters_per_sec { get; set; }
        protected string Assembly_date { get; set; }
        protected int Carrying_capacity_kg { get; set; }
        protected int Capacity_persons { get; set; }
        public Object DeepCopy()
        {
            using (var ms = new MemoryStream())
            {
                var formatter = new BinaryFormatter();
                formatter.Serialize(ms, this);
                ms.Position = 0;

                return (Object)formatter.Deserialize(ms);
            }
        }
    }
}
