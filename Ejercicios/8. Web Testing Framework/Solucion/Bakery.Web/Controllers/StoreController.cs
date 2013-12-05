using System.Collections.Generic;
using System.Web.Mvc;

namespace Bakery.Web.Controllers
{
    using System.Linq;

    using Bakery.Web.Database;
    using Bakery.Web.Models;

    public class StoreController : Controller
    {
        DataAccess dataAccess=new DataAccess();

        public ActionResult ChooseProduct()
        {
            var products = dataAccess.ListAll<Product>();
            return View(products);
        }

        public ActionResult PlaceOrder(string productId)
        {
            this.ViewBag.Product = dataAccess.GetProduct(productId);
            return View();
        }

        [HttpPost]
        public ActionResult PlaceOrder(Order order)
        {
            dataAccess.Save(order);
            return RedirectToAction("Confirmation");
        }

        public ActionResult Confirmation()
        {
            return View();
        }
    }
}
