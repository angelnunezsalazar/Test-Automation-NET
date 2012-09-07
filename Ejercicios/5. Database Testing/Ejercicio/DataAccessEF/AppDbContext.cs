namespace DataAccessEF
{
    using System.Data.Entity;

    public class AppDbContext:DbContext
    {
        public IDbSet<Employee> Employees { get; set; }
    }
}