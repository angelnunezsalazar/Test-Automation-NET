namespace DataAccessNH
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

        public virtual long Id { get; set; }

        public virtual string FirstName { get; set; }

        public virtual string LastName { get; set; }

        public virtual DateTime? HireDate { get; set; }
    }
}
