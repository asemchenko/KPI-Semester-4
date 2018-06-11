using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab02
{
    class Airport
    {
        public Airport()
        {
            AirCrafts = new List<AirCraft>();
            InitiallySubscribeToEvents();
        }
        public Airport(List<AirCraft> craftsList)
        {
            AirCrafts = craftsList;
            InitiallySubscribeToEvents();
        }
        public override string ToString()
        {
            string str = "AirCrafts: ";
            foreach (AirCraft function in AirCrafts)
            {
                str += function.ToString() + "; ";
            }

            return str;
        }
        public static bool operator ==(Airport firstAirport, Airport secondAirport)
        {
            return firstAirport.Equals(secondAirport);
        }
        public static bool operator !=(Airport firstAirport, Airport secondAirport)
        {
            return !firstAirport.Equals(secondAirport);
        }
        public List<AirCraft> AirCraftsList
        {
            get
            {
                return AirCrafts;
            }
            set
            {
                AirCrafts.Clear();
                Changed(this, new MyEventArgs("Aircrafts list has been changed"));
                AirCrafts.Clear();
                for (int i = 0; i < value.Count; i++)
                {
                    AirCrafts.Add(value[i]);
                }
            }
        }
        public void OnEventTriggered(object sender, MyEventArgs e)
        {
            Console.WriteLine(e.toString());
        }
        public void Add(AirCraft function)
        {
            AirCrafts.Add(function);
            Added?.Invoke(this, new MyEventArgs("Added " + function.ToString()));
        }
        public void RemoveAt(int index)
        {
            AirCrafts.RemoveAt(index);
            Deleted(this, new MyEventArgs("Deleted craft[" + index.ToString() + "]"));
        }
        public void Remove(Object obj)
        {
            AirCrafts.Remove((AirCraft)obj);
            Deleted(this, new MyEventArgs("Deleted " + ((AirCraft)obj).ToString()));
        }
        public override bool Equals(object obj)
        {
            List<AirCraft> other = ((Airport)obj).AirCraftsList;
            if (other.Count != AirCrafts.Count)
            {
                return false;
            }

            for (int i = 0; i < AirCrafts.Count; i++)
            {
                if (!AirCrafts[i].Equals(other[i]))
                {
                    return false;
                }
            }
            return true;
        }
        public override int GetHashCode()
        {
            int hash = 0;
            foreach (var element in AirCrafts)
            {
                hash += element.GetHashCode();
            }
            return hash / 120;
        }
        public object DeepCopy()
        {
            Airport newAirport = new Airport();
            foreach (var craft in AirCrafts)
            {
                newAirport.Add(craft);
            }
            return newAirport;
        }
        private List<AirCraft> AirCrafts;
        private delegate void AirportEventHandler(object sender, MyEventArgs e);
        private event AirportEventHandler Added;
        private event AirportEventHandler Deleted;
        private event AirportEventHandler Changed;
        private void InitiallySubscribeToEvents()
        {
            Added += OnEventTriggered;
            Deleted += OnEventTriggered;
            Changed += OnEventTriggered;
        }
    }
}
