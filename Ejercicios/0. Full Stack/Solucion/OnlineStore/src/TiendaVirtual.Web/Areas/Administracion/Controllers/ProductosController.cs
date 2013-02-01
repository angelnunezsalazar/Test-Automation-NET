using System.Linq;
using System.Web.Mvc;

namespace TiendaVirtual.Web.Areas.Administracion.Controllers
{
    using System;
    using System.Configuration;
    using System.IO;
    using System.Web;

    using TiendaVirtual.DataAccess;
    using TiendaVirtual.Domain;
    using TiendaVirtual.Web.Areas.Administracion.Models;

    [Authorize]
    public class ProductosController : Controller
    {
        DatabaseContext context = new DatabaseContext();
        public ActionResult Index()
        {
            var productos = context.Productos.ToList();
            return View(productos);
        }

        public ActionResult Crear()
        {
            ViewBag.CategoriaId = new SelectList(context.Categorias.ToList(), "Id", "Nombre");
            return View();
        }

        [HttpPost]
        public ActionResult Crear(Producto producto)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.CategoriaId = new SelectList(context.Categorias.ToList(), "Id", "Nombre");
                return this.View();
            }

            context.Productos.Add(producto);
            context.SaveChanges();
            TempData["Mensaje"] = "Se ha creado el producto " + producto.Nombre;
            return RedirectToAction("index");
        }

        public ActionResult Editar(int id)
        {
            var producto = context.Productos.Find(id);
            var categorias = context.Categorias.ToList();
            var viewModel = new EditarProductoViewModel(producto, categorias);
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, HttpPostedFileBase archivo)
        {
            var producto = context.Productos.Find(id);
            UpdateModel(producto);
            if (archivo != null)
            {
                producto.Imagen = new Imagen
                    {
                        Ruta = archivo.FileName,
                        Tipo = archivo.ContentType,
                    };
                string path = Path.Combine(ConfigurationManager.AppSettings["DirectorioProductos"],
                                       producto.Imagen.Ruta);

                archivo.SaveAs(Server.MapPath(path));
            }
            context.SaveChanges();
            return RedirectToAction("index");
        }

        public ActionResult Existe(string nombre)
        {
            Producto producto = this.context.Productos.SingleOrDefault(x => x.Nombre.Equals(nombre, StringComparison.CurrentCultureIgnoreCase));
            var esValido = producto == null;
            return Json(esValido, JsonRequestBehavior.AllowGet);
        }

    }
}
