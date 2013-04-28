namespace DataAccessEF.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Transactions;

    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Data.Entity.Infrastructure;
    using System.Data.Metadata.Edm;

    [TestClass]
    public class EmployeeEFTests_Self_Transaction
    {
        private AppDbContext context;
        private EmployeeEF employeeEF;

        private TransactionScope transactionScope;

        private Employee employeeLoaded;

        //[ClassInitialize]
        //public static void InitializeDatabase(TestContext context)
        //{
        //    Database.SetInitializer(new EmployeeEFInitializer());
        //    using (var dbcontext = new AppDbContext())
        //    {
        //        dbcontext.Database.Initialize(force: true);
        //    }
        //}

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
            FlushChanges();

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
            //Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            //LoadData(employee1);
            //Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29));
            //LoadData(employee2);
            //FlushChanges();

            string lastName = "Pacheco";

            IList<Employee> employees = employeeEF.Find(lastName, null, null);

            Assert.AreEqual(1, employees.Count);
        }

        [TestMethod]
        public void Find_WithHireDateFilters_ReturnTheEmployeesBetweenHireDates()
        {
            //Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            //LoadData(employee1);
            //Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29));
            //LoadData(employee2);
            //Employee employee3 = new Employee("Luis", "Tovar", new DateTime(2010, 12, 28));
            //LoadData(employee3);
            //FlushChanges();

            DateTime startHireDate = new DateTime(2010, 12, 29);
            DateTime endHireDate = new DateTime(2010, 12, 30);

            IList<Employee> employees = employeeEF.Find(null, startHireDate, endHireDate);

            Assert.AreEqual(2, employees.Count);
        }

        [TestMethod]
        public void Find_WithAllFilters_ReturnTheEmployeesWithTheExactLastNameAndBetweenTheHiredDates()
        {
            //Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            //LoadData(employee1);
            //Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29));
            //LoadData(employee2);
            //Employee employee3 = new Employee("Luis", "Tovar", new DateTime(2010, 12, 28));
            //LoadData(employee3);
            //FlushChanges();

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
            FlushChanges();

            Employee employeePersisted = employeeEF.Get(employee.Id);
            Assert.IsNotNull(employeePersisted);
        }

        [TestMethod]
        public void Delete_TheEmployeeIsDeleted()
        {
            employeeEF.Delete(employeeLoaded.Id);
            FlushChanges();

            Employee employeeDeleted = employeeEF.Get(employeeLoaded.Id);
            Assert.IsNull(employeeDeleted);
        }

        private void LoadData(Employee entity)
        {
            context.Employees.Add(entity);
        }

        private void FlushChanges()
        {
            context.SaveChanges();
        }

        /***************  SQLServer 2005 - SQLServer CE ***********************/
        //private IDbConnection connection;
        //private IDbTransaction transaction;

        //private void BeginTransaction()
        //{
        //    this.connection = ((IObjectContextAdapter)context).ObjectContext.Connection;
        //    this.connection.Open();
        //    this.transaction = connection.BeginTransaction();
        //}

        //private void Rollback()
        //{
        //    if (this.connection.State != ConnectionState.Closed)
        //    {
        //        this.transaction.Rollback();
        //        this.connection.Close();
        //    }
        //}
    }
}