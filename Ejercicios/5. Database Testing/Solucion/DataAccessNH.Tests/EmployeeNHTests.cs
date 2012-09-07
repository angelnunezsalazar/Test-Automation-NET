namespace DataAccessNH.Tests
{
    using System;
    using System.Collections.Generic;

    using DataAccessNH;

    using NHibernate;
    using NHibernate.Context;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class EmployeeHibernateTests
    {
        private ISessionFactory sessionFactory;

        private EmployeeNH employeeNHibernate;

        [TestInitialize]
        public void Setup()
        {
            this.sessionFactory = SessionFactory.Create();
            this.employeeNHibernate = new EmployeeNH(this.sessionFactory);

            this.BeginTransaction();
        }

        [TestCleanup]
        public void TearDown()
        {
            this.Rollback();
        }

        [TestMethod]
        public void Find_WithLastNameFilter_ReturnTheEmployeesWithTheExactLastName()
        {
            Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            this.LoadData(employee1);
            Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29));
            this.LoadData(employee2);
            this.FlushAndClear();

            string lastName = "Pacheco";

            IList<Employee> employees = this.employeeNHibernate.Find(lastName, null, null);

            Assert.AreEqual(1, employees.Count);
        }

        [TestMethod]
        public void Find_WithHireDateFilters_ReturnTheEmployeesBetweenHireDates()
        {
            Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            this.LoadData(employee1);
            Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29));
            this.LoadData(employee2);
            Employee employee3 = new Employee("Luis", "Tovar", new DateTime(2010, 12, 28));
            this.LoadData(employee3);
            this.FlushAndClear();

            DateTime startHireDate = new DateTime(2010, 12, 29);
            DateTime endHireDate = new DateTime(2010, 12, 30);

            IList<Employee> employees = this.employeeNHibernate.Find(null, startHireDate, endHireDate);

            Assert.AreEqual(2, employees.Count);
        }

        [TestMethod]
        public void Find_WithAllFilters_ReturnTheEmployeesWithTheExactLastNameAndBetweenTheHiredDates()
        {
            Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            this.LoadData(employee1);
            Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29));
            this.LoadData(employee2);
            Employee employee3 = new Employee("Luis", "Tovar", new DateTime(2010, 12, 28));
            this.LoadData(employee3);
            this.FlushAndClear();

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
            this.FlushAndClear();

            Employee employeePersisted = this.employeeNHibernate.Get(employee.Id);
            Assert.IsNotNull(employeePersisted);
        }

        [TestMethod]
        public void Delete_TheEmployeeIsDeleted()
        {
            Employee employee = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            this.LoadData(employee);
            this.FlushAndClear();

            this.employeeNHibernate.Delete(employee.Id);
            this.FlushAndClear();

            Employee employeeDeleted = this.employeeNHibernate.Get(employee.Id);
            Assert.IsNull(employeeDeleted);
        }

        private void LoadData(object entity)
        {
            ISession session = this.sessionFactory.GetCurrentSession();
            session.Save(entity);
        }

        private void FlushAndClear()
        {
            ISession session = this.sessionFactory.GetCurrentSession();
            session.Flush();
            session.Clear();
        }

        private void BeginTransaction()
        {
            ISession session = this.sessionFactory.OpenSession();
            session.BeginTransaction();
            CurrentSessionContext.Bind(session);
        }

        private void Rollback()
        {
            var session = this.sessionFactory.GetCurrentSession();
            session.Transaction.Rollback();
            session.Transaction.Dispose();
            session.Dispose();
        }
    }
}