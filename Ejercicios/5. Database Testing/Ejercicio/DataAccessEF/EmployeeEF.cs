namespace DataAccessEF
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class EmployeeEF
    {
        private readonly AppDbContext context;

        public EmployeeEF(AppDbContext context)
        {
            this.context = context;
        }

        public IList<Employee> Find(String lastName, DateTime? startHireDate, DateTime? endHireDate)
        {
            var query = this.context.Employees.AsQueryable();

            if (lastName != null)
            {
                query=query.Where(x => x.LastName == lastName);
            }
            if (startHireDate != null && endHireDate != null)
            {
                query = query.Where(x => x.HireDate >= startHireDate && x.HireDate <= endHireDate);
            }
            return query.ToList();
        }

        public Employee Get(int id)
        {
            return this.context.Employees.Find(id);
        }

        public void Create(Employee employee)
        {
            this.context.Employees.Add(employee);
        }

        public void Delete(int id)
        {
            Employee employee = this.context.Employees.Find(id);
            this.context.Employees.Remove(employee);
        }
    }
}