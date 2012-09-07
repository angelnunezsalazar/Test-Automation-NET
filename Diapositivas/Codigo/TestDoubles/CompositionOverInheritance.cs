namespace TestDoubles
{
    // ReSharper disable NotAccessedField.Local
    // ReSharper disable UnusedMember.Local


    public class Composition
    {
        public class Car
        {
            private string manufacturer;
            private Engine engine;

            public Car(string manufacturer,
                       Engine engine)
            {
                this.manufacturer = manufacturer;
                this.engine = engine;
            }
        }
    }

    public class Inheritance
    {
        public class Vehicle
        {
            protected Engine Engine { get; set; }
        }

        public class Car : Vehicle
        {
            public string Manufacturer { get; set; }
        }
    }

    public class Engine
    { }

    // ReSharper restore UnusedMember.Local
    // ReSharper restore NotAccessedField.Local
}