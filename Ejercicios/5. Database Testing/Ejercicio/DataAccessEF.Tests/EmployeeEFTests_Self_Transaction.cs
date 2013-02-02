namespace DataAccessEF.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Transactions;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class EmployeeEFTests_Self_Transaction
    {
        private AppDbContext context;
        private EmployeeEF employeeEF;

        private TransactionScope transactionScope;

        private Employee employeeLoaded;

        [TestInitialize]
        public void Setup()
        {
            this.context = new AppDbContext();
            this.employeeEF = new EmployeeEF(context);
            transactionScope = new TransactionScope();

            Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            LoadData(employee1);
            Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29));
            LoadData(employee2);
            Employee employee3 = new Employee("Luis", "Tovar", new DateTime(2010, 12, 28));
            LoadData(employee3);

            employeeLoaded = employee1;
        }

        [TestCleanup]
        public void TearDown()
        {
            transactionScope.Dispose();
        }

        [TestMethod]
        public void Find_WithLastNameFilter_ReturnTheEmployeesWithTheExactLastName()
        {
            string lastName = "Pacheco";

            IList<Employee> employees = employeeEF.Find(lastName, null, null);

            Assert.AreEqual(1, employees.Count);
        }

        [TestMethod]
        public void Find_WithHireDateFilters_ReturnTheEmployeesBetweenHireDates()
        {
            DateTime startHireDate = new DateTime(2010, 12, 29);
            DateTime endHireDate = new DateTime(2010, 12, 30);

            IList<Employee> employees = employeeEF.Find(null, startHireDate, endHireDate);

            Assert.AreEqual(2, employees.Count);
        }

        [TestMethod]
        public void Find_WithAllFilters_ReturnTheEmployeesWithTheExactLastNameAndBetweenTheHiredDates()
        {
            String lastName = "Pacheco";
            DateTime startHireDate = new DateTime(2010, 12, 29);
            DateTime endHireDate = new DateTime(2010, 12, 30);

            IList<Employee> employees = employeeEF.Find(lastName, startHireDate, endHireDate);

            Assert.AreEqual(1, employees.Count);
        }

        [TestMethod]
        public void Create_TheEmployeeIsPersisted()
        {
            Employee employee = new Employee("Luis", "Carranza", new DateTime(2010, 12, 15));

            employeeEF.Create(employee);

            Employee employeePersisted = employeeEF.Get(employee.Id);
            Assert.IsNotNull(employeePersisted);
        }

        [TestMethod]
        public void Delete_TheEmployeeIsDeleted()
        {
            employeeEF.Delete(employeeLoaded.Id);

            Employee employeeDeleted = employeeEF.Get(employeeLoaded.Id);
            Assert.IsNull(employeeDeleted);
        }

        private void LoadData(Employee entity)
        {
            context.Employees.Add(entity);
        }
    }
}