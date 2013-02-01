using System.Web.Mvc;

namespace TiendaVirtual.Web.Controllers
{
    using TiendaVirtual.Domain;
    using TiendaVirtual.Web.Models;

    public class PedidoController : Controller
    {
        public ActionResult Envio()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Envio(CarroCompras carroCompras, DireccionEnvio envio)
        {
            carroCompras.Envio = envio;
            return RedirectToAction("Confirmacion");
        }

        public ActionResult Confirmacion(CarroCompras carroCompras)
        {
            //var confirmacion = new Confirmacion
            //    {
            //        Productos = carroCompras.TotalProductos(),
            //        Envio = carroCompras.TotalEnvio(),
            //        Total = carroCompras.Total()
            //    };
            return View(carroCompras);
        }

        [HttpPost]
        public ActionResult Comprar(CarroCompras carroCompras)
        {
            //DatabaseContext context = new DatabaseContext();
            //var orden = new Orden(carroCompras);
            //context.Ordenes.Add(orden);
            //context.SaveChanges();
            return View();
        }
    }
}
