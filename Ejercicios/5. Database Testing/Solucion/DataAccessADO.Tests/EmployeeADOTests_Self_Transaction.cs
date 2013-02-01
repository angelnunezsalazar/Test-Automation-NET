namespace DataAccessADO.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Transactions;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class EmployeeADOTests_Self_Transaction
    {
        private EmployeeADO employeeADO;

        private TransactionScope transactionScope;

        [TestInitialize]
        public void Setup()
        {
            this.employeeADO = new EmployeeADO();
            transactionScope = new TransactionScope();
        }

        [TestCleanup]
        public void TearDown()
        {
            transactionScope.Dispose();
        }

        [TestMethod]
        public void Find_WithoutFilters_ReturnAllEmployees()
        {
            Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            LoadData(employee1);
            Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29));
            LoadData(employee2);
            Employee employee3 = new Employee("Luis", "Tovar", new DateTime(2010, 12, 28));
            LoadData(employee3);

            List<Employee> employees = this.employeeADO.Find(null, null, null);

            Assert.AreEqual(3, employees.Count);
        }

        [TestMethod]
        public void Find_WithLastNameFilter_ReturnTheEmployeesWithTheExactLastName()
        {
            Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            LoadData(employee1);
            Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29));
            LoadData(employee2);

            String lastName = "Pacheco";

            List<Employee> employees = this.employeeADO.Find(lastName, null, null);

            Assert.AreEqual(1, employees.Count);
        }

        [TestMethod]
        public void Find_WithHireDateFilters_ReturnTheEmployeesBetweenHireDates()
        {
            Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            LoadData(employee1);
            Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29));
            LoadData(employee2);
            Employee employee3 = new Employee("Luis", "Tovar", new DateTime(2010, 12, 28));
            LoadData(employee3);

            DateTime startHireDate = new DateTime(2010, 12, 29);
            DateTime endHireDate = new DateTime(2010, 12, 30);

            List<Employee> employees = this.employeeADO.Find(null, startHireDate, endHireDate);

            Assert.AreEqual(2, employees.Count);
        }

        [TestMethod]
        public void Find_WithAllFilters_ReturnTheEmployeesWithTheExactLastNameAndBetweenTheHiredDates()
        {
            Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            LoadData(employee1);
            Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29));
            LoadData(employee2);
            Employee employee3 = new Employee("Luis", "Tovar", new DateTime(2010, 12, 28));
            LoadData(employee3);

            String lastName = "Pacheco";
            DateTime startHireDate = new DateTime(2010, 12, 29);
            DateTime endHireDate = new DateTime(2010, 12, 30);

            List<Employee> employees = this.employeeADO.Find(lastName, startHireDate, endHireDate);

            Assert.AreEqual(1, employees.Count);
        }

        [TestMethod]
        public void Create_TheEmployeeIsPersisted()
        {
            Employee employee = new Employee
            {
                FirstName = "Luis",
                LastName = "Carranza",
                HireDate = new DateTime(2010, 12, 15)
            };

            this.employeeADO.Create(employee);

            Employee employeePersisted = this.employeeADO.Get(employee.Id);
            Assert.IsNotNull(employeePersisted);
        }

        [TestMethod]
        public void Delete_TheEmployeeIsDeleted()
        {
            Employee employee = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            LoadData(employee);

            this.employeeADO.Delete(1);

            Employee employeeDeleted = this.employeeADO.Get(1);
            Assert.IsNull(employeeDeleted);
        }

        private void LoadData(Employee entity)
        {
            this.employeeADO.Create(entity);
        }
    }
}