using System.Linq;
using System.Web.Mvc;

namespace TiendaVirtual.Web.Controllers
{
    using System.Configuration;
    using System.IO;

    using TiendaVirtual.DataAccess;
    using TiendaVirtual.Web.Pagination;

    public class HomeController : Controller
    {
        DatabaseContext context = new DatabaseContext();

        const int tamanoPagina = 2;

        public ActionResult Index(string categoria, int pagina)
        {
            var query = categoria == null
                ? context.Productos.OrderBy(x => x.Nombre)
                : context.Productos.OrderBy(x => x.Nombre).Where(x => x.Categoria.Nombre == categoria);

            var productos = query.ToPagedList(pagina, tamanoPagina);

            return View(productos);
        }

        public ActionResult Imagen(int id)
        {
            var producto = context.Productos.Find(id);
            string path = Path.Combine(ConfigurationManager.AppSettings["DirectorioProductos"],
                                       producto.Imagen.Ruta);
            return File(path, producto.Imagen.Tipo);
        }
    }
}
