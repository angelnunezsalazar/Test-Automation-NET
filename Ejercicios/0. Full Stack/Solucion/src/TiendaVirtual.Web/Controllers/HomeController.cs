using System.Web.Mvc;

namespace TiendaVirtual.Web.Controllers
{
    using System.Configuration;
    using System.IO;

    using TiendaVirtual.DataAccess;
    using TiendaVirtual.Web.Pagination;

    public class HomeController : Controller
    {
        private ProductoDAO productoDAO;

        const int tamanoPagina = 2;

        public HomeController()
        {
            DatabaseContext context = new DatabaseContext();
            this.productoDAO = new ProductoDAO(context);
        }

        public ActionResult Index(string categoria, int pagina)
        {
            var productos = productoDAO.Buscar(categoria);
            var pagedList = productos.ToPagedList(pagina, tamanoPagina);

            return View(pagedList);
        }

        public ActionResult Imagen(int id)
        {
            var producto = productoDAO.Obtener(id);
            string path = Path.Combine(ConfigurationManager.AppSettings["DirectorioProductos"],
                                       producto.Imagen.Ruta);
            return File(path, producto.Imagen.Tipo);
        }
    }
}
