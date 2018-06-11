using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab02
{
    class Helicopter: AirCraft
    {
        private int propeller_blades_count { get; set; }
        private int propeller_length { get; set; }
        public override bool Equals(Object other)
        {
            if (other == null || other.GetType() != typeof(Helicopter))
            {
                return false;
            }
            Helicopter other_helicopter = (Helicopter)other;
            return other_helicopter.propeller_blades_count == propeller_blades_count &&
                other_helicopter.propeller_length == propeller_length &&
                other_helicopter.Carrying_capacity_kg == Carrying_capacity_kg &&
                other_helicopter.Capacity_persons == Capacity_persons;
        }
        public static bool operator ==(Helicopter helicopter1, Helicopter helicopter2)
        {
            if (helicopter1 == null)
            {
                throw new ArgumentNullException(nameof(helicopter1));
            }
            return helicopter1.Equals(helicopter2);
        }
        public static bool operator !=(Helicopter helicopter1, Helicopter helicopter2)
        {
            if (helicopter1 == null)
            {
                throw new ArgumentNullException(nameof(helicopter1));
            }
            return !helicopter1.Equals(helicopter2);
        }
        public override int GetHashCode()
        {
            return propeller_blades_count + propeller_length + Carrying_capacity_kg + Capacity_persons;
        }
        public override string ToString()
        {
            return String.Format("Helicopter max speed {0} m/s, costs {1}$, contains {2} propeller blades, each {3} meters lenght",
                Max_speed_meters_per_sec,
                Cost, propeller_blades_count,
                propeller_length);
        }
    }
}
