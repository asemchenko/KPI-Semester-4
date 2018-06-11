using System;

namespace lab02
{
    class Plane : AirCraft
    {
        private string owner_company_name { get; set; }
        private int life_jackets_count { get; set; }
        private int required_stewardess_count { get; set; }
        public override bool Equals(Object other) {
            if (other == null || other.GetType() != typeof(Plane))
            {
                return false;
            }
            Plane other_plane = (Plane)other;
            return other_plane.required_stewardess_count == required_stewardess_count &&
                other_plane.Carrying_capacity_kg == Carrying_capacity_kg &&
                other_plane.Capacity_persons == Capacity_persons;
        }
        public static bool operator == (Plane plane1, Plane plane2)
        {
            if (plane1 == null)
            {
                throw new ArgumentNullException(nameof(plane1));
            }
            return plane1.Equals(plane2);
        }
        public static bool operator != (Plane plane1, Plane plane2)
        {
            if (plane1 == null)
            {
                throw new ArgumentNullException(nameof(plane1));
            }
            return !plane1.Equals(plane2);
        }
        public override int GetHashCode()
        {
            return required_stewardess_count + Carrying_capacity_kg + Capacity_persons;
        }
        public override string ToString()
        {
            return String.Format("Plane owned by {0}, minimal {1} stewardess required," +
                " max speed {2} m/s, costs {3}$", owner_company_name,
                required_stewardess_count, Max_speed_meters_per_sec, Cost);
        }
    }
}
