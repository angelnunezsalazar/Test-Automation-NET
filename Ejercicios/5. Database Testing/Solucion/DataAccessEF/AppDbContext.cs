namespace DataAccessEF
{
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;

    public class AppDbContext:DbContext
    {
        public IDbSet<Employee> Employees { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}