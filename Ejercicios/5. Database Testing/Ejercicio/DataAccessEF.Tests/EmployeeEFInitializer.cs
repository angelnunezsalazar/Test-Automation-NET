namespace DataAccessEF.Tests
{
    using System;
    using System.Data.Entity;

    public class EmployeeEFInitializer : DropCreateDatabaseAlways<AppDbContext>
    {
        protected override void Seed(AppDbContext context)
        {
            Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30));
            Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29));
            Employee employee3 = new Employee("Luis", "Tovar", new DateTime(2010, 12, 28));
            
            context.Employees.Add(employee1);
            context.Employees.Add(employee2);
            context.Employees.Add(employee3);
        }
    }









    //public class EmployeeEFInitializer : IDatabaseInitializer<AppDbContext>
    //{
    //    public void InitializeDatabase(AppDbContext context)
    //    {
    //        this.DeleteData<Employee>(context);
    //        ResetIdentitySeed(context);
    //        this.LoadData(context);
    //    }

    //    private void LoadData(AppDbContext context)
    //    {
    //        Employee employee1 = new Employee("Luis", "Pacheco", new DateTime(2010, 12, 30)) { Id = 1 };
    //        Employee employee2 = new Employee("Luis", "Quispe", new DateTime(2010, 12, 29)) { Id = 2 };
    //        Employee employee3 = new Employee("Luis", "Tovar", new DateTime(2010, 12, 28)) { Id = 3 };

    //        context.Employees.Add(employee1);
    //        context.Employees.Add(employee2);
    //        context.Employees.Add(employee3);

    //        context.SaveChanges();
    //    }

    //    private void DeleteData<T>(AppDbContext context) where T : class
    //    {
    //        var tableName = TableName<T>(context);
    //        context.Database.ExecuteSqlCommand("Delete from " + tableName);
    //    }

    //    private static void ResetIdentitySeed(AppDbContext context)
    //    {
    //        var tableName = TableName<Employee>(context);
    //        context.Database.ExecuteSqlCommand("DBCC CHECKIDENT ('" + tableName + "', RESEED, 0)");
    //    }

    //    private static string TableName<T>(AppDbContext context) where T : class
    //    {
    //        return typeof(T).Name;
    //        // Sí se utiliza el pluralize convention
    //        /* var objectContext = ((IObjectContextAdapter)context).ObjectContext;
    //           return objectContext.CreateObjectSet<T>().EntitySet.Name;
    //        */
    //    }
    //}
}