namespace TiendaVirtual.DataAccess
{
    using System.Linq;

    using TiendaVirtual.Domain;

    public class ProductoDAO
    {
        private DatabaseContext context;
        public ProductoDAO(DatabaseContext context)
        {
            this.context = context;
        }

        public Producto Obtener(int id)
        {
            return context.Productos.Find(id);
        }

        public IQueryable<Producto> Buscar(string categoria)
        {
            var productos = categoria == null
                            ? context.Productos.OrderBy(x => x.Nombre)
                            : context.Productos.OrderBy(x => x.Nombre).Where(x => x.Categoria.Nombre == categoria);
            return productos;
        }
    }
}