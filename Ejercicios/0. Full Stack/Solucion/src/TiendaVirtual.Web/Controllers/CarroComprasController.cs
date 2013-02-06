using System.Linq;
using System.Web.Mvc;

namespace TiendaVirtual.Web.Controllers
{
    using TiendaVirtual.DataAccess;
    using TiendaVirtual.Domain;
    using TiendaVirtual.Web.Models;

    public class CarroComprasController : Controller
    {
        DatabaseContext context = new DatabaseContext();

        public ActionResult Mostrar(CarroCompras carroCompras, string regresarUrl)
        {
            ViewBag.RegresarUrl = regresarUrl;
            return View(carroCompras);
        }

        [HttpPost]
        public ActionResult Agregar(CarroCompras carroCompras, int id, string regresarUrl)
        {
            Producto producto = context.Productos.FirstOrDefault(p => p.Id == id);
            carroCompras.AgregarLinea(producto);

            return RedirectToAction("Mostrar", new { regresarUrl });
        }

        [HttpPost]
        public ActionResult Actualizar(CarroCompras carroCompras, int id, int cantidad, string regresarUrl)
        {
            carroCompras.ActualizarLinea(id, cantidad);
            return RedirectToAction("Mostrar", new { regresarUrl });
        }

        [HttpPost]
        public ActionResult Eliminar(CarroCompras carroCompras, int id, string regresarUrl)
        {
            carroCompras.RemoverLinea(id);
            return RedirectToAction("Mostrar", new { regresarUrl });
        }
    }
}
