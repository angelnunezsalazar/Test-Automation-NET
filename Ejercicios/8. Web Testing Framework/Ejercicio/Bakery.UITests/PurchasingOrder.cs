using Bakery.UITests.Infraestructure;
using Bakery.Web.Models;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenQA.Selenium;
using OpenQA.Selenium.Firefox;

namespace Bakery.UITests
{
    [TestClass]
    public class PurchasingOrder
    {
        [TestMethod]
        public void CheckPrice()
        {
            //Cargar la data
            Database.LoadData(new Product
            {
                Name = "Apple Cake",
                Description = "??",
                Price=8.9m,
                ImageName = ""
            });

            var driver = new FirefoxDriver();
            var chooseProduct = new ChooseProduct(driver);
            chooseProduct.Open();
            chooseProduct.OrderNow("Apple Cake");

            var placeOrder = new PlaceOrder(driver);

            Assert.IsTrue(placeOrder.ProductName().Contains("Apple Cake"));
            Assert.IsTrue(placeOrder.Price().Contains("8.9"));
            driver.Close();

            //eliminar la data
            Database.CleanTable("Products");
        }

    }
}
