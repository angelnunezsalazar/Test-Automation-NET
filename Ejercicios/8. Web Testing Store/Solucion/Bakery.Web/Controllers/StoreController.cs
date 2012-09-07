using System.Web.Mvc;

namespace Bakery.Web.Controllers
{
    using System.Linq;

    using Bakery.Web.Database;
    using Bakery.Web.Models;

    public class StoreController : Controller
    {
        AppDbContext context=new AppDbContext();

        public ActionResult ChooseProduct()
        {
            var products = context.Products.ToList();
            return View(products);
        }

        public ActionResult PlaceOrder(int productId)
        {
            this.ViewBag.Product = this.context.Products.Find(productId);
            return View();
        }

        [HttpPost]
        public ActionResult PlaceOrder(Order order)
        {
            context.Orders.Add(order);
            context.SaveChanges();
            return RedirectToAction("Confirmation");
        }

        public ActionResult Confirmation()
        {
            return View();
        }
    }
}
