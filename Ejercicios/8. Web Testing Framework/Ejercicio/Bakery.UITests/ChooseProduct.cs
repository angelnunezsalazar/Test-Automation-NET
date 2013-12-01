using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenQA.Selenium;

namespace Bakery.UITests
{
    public class ChooseProduct
    {
        private readonly IWebDriver driver;

        public ChooseProduct(IWebDriver webdriver)
        {
            this.driver = webdriver;
        }

        public void Open()
        {
            driver.Url = "http://localhost:9593/";
        }

        public void OrderNow(string productName)
        {
            driver.FindElement(By.XPath("//h3[contains(text(),'" + productName + "')]/../.././/a")).Click();
        }
    }
}
