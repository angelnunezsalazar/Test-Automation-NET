using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TiendaVirtual.Web.Controllers
{
    using TiendaVirtual.DataAccess;

    public class NavegacionController : Controller
    {
        DatabaseContext context=new DatabaseContext();

        [ChildActionOnly]
        public ActionResult Menu()
        {
            var categorias = context.Categorias.ToList();
            return View("_Menu", categorias);
        }

    }
}
