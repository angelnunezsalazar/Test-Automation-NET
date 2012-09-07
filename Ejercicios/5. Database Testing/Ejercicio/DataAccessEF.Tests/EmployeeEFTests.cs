namespace DataAccessEF.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Transactions;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class EmployeeEFTests
    {
        private AppDbContext context;
        private EmployeeEF employeeEF;

        [TestInitialize]
        public void Setup()
        {
            this.context = new AppDbContext();
            this.employeeEF = new EmployeeEF(context);
        }

        [TestMethod]
        public void Find_WithLastNameFilter_ReturnTheEmployeesWithTheExactLastName()
        {
            string lastName = "Pacheco";

            IList<Employee> employees = this.employeeEF.Find(lastName, null, null);

            Assert.AreEqual(1, employees.Count);
        }

        [TestMethod]
        public void Find_WithHireDateFilters_ReturnTheEmployeesBetweenHireDates()
        {
            DateTime startHireDate = new DateTime(2010, 12, 29);
            DateTime endHireDate = new DateTime(2010, 12, 30);

            IList<Employee> employees = this.employeeEF.Find(null, startHireDate, endHireDate);

            Assert.AreEqual(2, employees.Count);
        }

        [TestMethod]
        public void Find_WithAllFilters_ReturnTheEmployeesWithTheExactLastNameAndBetweenTheHiredDates()
        {
            String lastName = "Pacheco";
            DateTime startHireDate = new DateTime(2010, 12, 29);
            DateTime endHireDate = new DateTime(2010, 12, 30);

            IList<Employee> employees = this.employeeEF.Find(lastName, startHireDate, endHireDate);

            Assert.AreEqual(1, employees.Count);
        }

        [TestMethod]
        public void Create_TheEmployeeIsPersisted()
        {
            Employee employee = new Employee("Luis", "Carranza", new DateTime(2010, 12, 15));

            this.employeeEF.Create(employee);

            Employee employeePersisted = this.employeeEF.Get(employee.Id);
            Assert.IsNotNull(employeePersisted);
        }

        [TestMethod]
        public void Delete_TheEmployeeIsDeleted()
        {
            this.employeeEF.Delete(1);

            Employee employeeDeleted = this.employeeEF.Get(1);
            Assert.IsNull(employeeDeleted);
        }
    }
}