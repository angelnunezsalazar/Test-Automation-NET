namespace TiendaVirtual.DataAccess
{
    using System.Data.Entity;
    using System.Data.Entity.ModelConfiguration.Conventions;

    using TiendaVirtual.Domain;

    public class DatabaseContext : DbContext
    {
        public DatabaseContext()
            : base("TiendaVirtual")
        {

        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }

        public IDbSet<Producto> Productos { get; set; }

        public IDbSet<Categoria> Categorias { get; set; }

        public IDbSet<Orden> Ordenes { get; set; }

    }
}