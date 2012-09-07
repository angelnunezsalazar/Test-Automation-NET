namespace Bakery.UITests
{
    using System.Configuration;

    using Bakery.UITests.Infraestructure;
    using Bakery.UITests.PageObjects;
    using Bakery.Web.Database;
    using Bakery.Web.Models;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using OpenQA.Selenium;
    using OpenQA.Selenium.Chrome;

    [TestClass]
    public class PurchasingCakes
    {
        private static IWebDriver driver;

        [AssemblyInitialize]
        public static void SetupOnlyOnce(TestContext testContext)
        {
            driver = new ChromeDriver(ConfigurationManager.AppSettings["seleniumDriver"]);
        }

        [TestCleanup]
        public void Teardown()
        {
            DatabaseCleaner.Clean("Products");
        }

        [AssemblyCleanup]
        public static void TearDownOnlyOnce()
        {
            driver.Quit();
        }

        [TestMethod]
        public void SeeProductDetailsWhenPlacingOrder()
        {
            DataFactory.Load(new Product
                {
                    Name = "Apple Cake",
                    Description = "Default Descripcion",
                    Price = 8.99m,
                    ImageName = "carrot_cake.jpg"
                });

            var chooseProductPage = new ChooseProductPage(driver);
            chooseProductPage.Open();
            var placeOrderPage = chooseProductPage.GoToPlaceOrderForProduct("Apple Cake");

            Assert.IsTrue(placeOrderPage.ProductName.Contains("Apple Cake"));
            Assert.IsTrue(placeOrderPage.ProductPrice.Contains("8.99"));
        }

        [TestMethod]
        public void PurchaseOneCake()
        {

        }
    }
}