namespace DataAccessEF
{
    using System;

    public class Employee
    {
        public Employee(string firstName, string lastName, DateTime? hireDate)
        {
            this.FirstName = firstName;
            this.LastName = lastName;
            this.HireDate = hireDate;
        }

        public Employee() { }

        public int Id { get; set; }
               
        public string FirstName { get; set; }
               
        public string LastName { get; set; }
               
        public DateTime? HireDate { get; set; }
    }
}
