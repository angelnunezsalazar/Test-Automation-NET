namespace Bakery.Web.Database
{
    using System.Data.Entity;

    using Bakery.Web.Models;

    public class AppDbContext : DbContext
    {
        public AppDbContext() : base("bakery") {
            Database.SetInitializer<AppDbContext>(null);
        }

        public IDbSet<Product> Products { get; set; }

        public IDbSet<Order> Orders { get; set; }
    }
}