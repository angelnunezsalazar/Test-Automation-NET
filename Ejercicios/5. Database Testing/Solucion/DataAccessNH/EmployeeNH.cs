namespace DataAccessNH
{
    using System;
    using System.Collections.Generic;

    using NHibernate;

    public class EmployeeNH
    {
        private readonly ISessionFactory sessionFactory;

        public EmployeeNH(ISessionFactory sessionFactory)
        {
            this.sessionFactory = sessionFactory;
        }

        public IList<Employee> Find(String lastName, DateTime? startHireDate, DateTime? endHireDate)
        {
            var criteria = this.Session.QueryOver<Employee>();

            if (lastName != null)
            {
                criteria.Where(x => x.LastName == lastName);
            }
            if (startHireDate != null && endHireDate != null)
            {
                criteria.WhereRestrictionOn(c => c.HireDate)
                        .IsBetween(startHireDate).And(endHireDate);
            }
            return criteria.List<Employee>();
        }

        public Employee Get(long id)
        {
            return this.Session.Get<Employee>(id);
        }

        public void Create(Employee employee)
        {
            this.Session.Save(employee);
        }

        public void Delete(long id)
        {
            Employee employee = this.Session.Load<Employee>(id);
            this.Session.Delete(employee);
        }

        public ISession Session
        {
            get
            {
                return this.sessionFactory.GetCurrentSession();
            }
        }
    }
}