using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab02
{
    class Freighter: AirCraft
    {
        private int minimal_pilot_count { get; set; }
        private double cargo_hold_volume_m3 { get; set; }
        public override bool Equals(Object other)
        {
            if (other == null || other.GetType() != typeof(Freighter))
            {
                return false;
            }
            Freighter other_freighter = (Freighter)other;
            return other_freighter.minimal_pilot_count == minimal_pilot_count &&
                other_freighter.cargo_hold_volume_m3 == cargo_hold_volume_m3 &&
                other_freighter.Carrying_capacity_kg == Carrying_capacity_kg &&
                other_freighter.Capacity_persons == Capacity_persons;
        }
        public static bool operator == (Freighter freighter1, Freighter freighter2)
        {
            if (freighter1 == null)
            {
                throw new ArgumentNullException(nameof(freighter1));
            }
            return freighter1.Equals(freighter2);
        }
        public static bool operator !=(Freighter freighter1, Freighter freighter2)
        {
            if (freighter1 == null)
            {
                throw new ArgumentNullException(nameof(freighter1));
            }
            return !freighter1.Equals(freighter2);
        }
        public override int GetHashCode()
        {
            return minimal_pilot_count + (int)cargo_hold_volume_m3 + Carrying_capacity_kg + Capacity_persons;
        }
        public override string ToString()
        {
            return String.Format("Freighter max speed {0} m/s, costs {1}$, minimal {2} pilots expected, {3}m3 cargo section volume",
                Max_speed_meters_per_sec,
                Cost, minimal_pilot_count,
                cargo_hold_volume_m3);
        }
    }
}
