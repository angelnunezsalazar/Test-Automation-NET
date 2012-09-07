namespace DataAccessNH.Tests
{
    using System;
    using System.Collections.Generic;

    using NHibernate;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class EmployeeNHTests
    {
        private ISessionFactory sessionFactory;

        private EmployeeNH employeeNHibernate;

        [TestInitialize]
        public void Setup()
        {
            this.sessionFactory = SessionFactory.Create();
            this.employeeNHibernate = new EmployeeNH(this.sessionFactory);
        }

        [TestMethod]
        public void Find_WithoutFilters_ReturnAllEmployees()
        {
            IList<Employee> employees = this.employeeNHibernate.Find(null, null, null);

            Assert.AreEqual(3, employees.Count);
        }

        [TestMethod]
        public void Find_WithLastNameFilter_ReturnTheEmployeesWithTheExactLastName()
        {
            string lastName = "Pacheco";

            IList<Employee> employees = this.employeeNHibernate.Find(lastName, null, null);

            Assert.AreEqual(1, employees.Count);
        }

        [TestMethod]
        public void Find_WithHireDateFilters_ReturnTheEmployeesBetweenHireDates()
        {
            DateTime startHireDate = new DateTime(2010, 12, 29);
            DateTime endHireDate = new DateTime(2010, 12, 30);

            IList<Employee> employees = this.employeeNHibernate.Find(null, startHireDate, endHireDate);

            Assert.AreEqual(2, employees.Count);
        }

        [TestMethod]
        public void Find_WithAllFilters_ReturnTheEmployeesWithTheExactLastNameAndBetweenTheHiredDates()
        {
            String lastName = "Pacheco";
            DateTime startHireDate = new DateTime(2010, 12, 29);
            DateTime endHireDate = new DateTime(2010, 12, 30);

            IList<Employee> employees = this.employeeNHibernate.Find(lastName, startHireDate, endHireDate);

            Assert.AreEqual(1, employees.Count);
        }

        [TestMethod]
        public void Create_TheEmployeeIsPersisted()
        {
            Employee employee = new Employee("Luis", "Carranza", new DateTime(2010, 12, 15));

            this.employeeNHibernate.Create(employee);

            Employee employeePersisted = this.employeeNHibernate.Get(employee.Id);
            Assert.IsNotNull(employeePersisted);
        }

        [TestMethod]
        public void Delete_TheEmployeeIsDeleted()
        {
            this.employeeNHibernate.Delete(1);

            Employee employeeDeleted = this.employeeNHibernate.Get(1);
            Assert.IsNull(employeeDeleted);
        }

        //private void LoadData(object entity)
        //{
        //    ISession session = sessionFactory.GetCurrentSession();
        //    session.Save(entity);
        //}

        //private void FlushAndClear()
        //{
        //    ISession session = sessionFactory.GetCurrentSession();
        //    session.Flush();
        //    session.Clear();
        //}

        //private void BeginTransaction()
        //{
        //    ISession session = this.sessionFactory.OpenSession();
        //    session.BeginTransaction();
        //    CurrentSessionContext.Bind(session);
        //}

        //private void Rollback()
        //{
        //    var session = this.sessionFactory.GetCurrentSession();
        //    session.Transaction.Rollback();
        //    session.Transaction.Dispose();
        //    session.Dispose();
        //}
    }
}