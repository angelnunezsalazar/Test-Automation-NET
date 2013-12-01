using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenQA.Selenium;

namespace Bakery.UITests
{
    public class PlaceOrder
    {
        private readonly IWebDriver driver;

        public PlaceOrder(IWebDriver webdriver)
        {
            this.driver = webdriver;
        }

        public string ProductName()
        {
            return driver.FindElement(By.TagName("h1")).Text;
        }

        public string Price()
        {
            return driver.FindElement(By.Id("orderPrice")).Text;
        }
    }
}
