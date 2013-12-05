namespace Bakery.UITests.PageObjects
{
    using OpenQA.Selenium;

    public class ChooseProductPage
    {
        private readonly IWebDriver driver;

        public ChooseProductPage(IWebDriver driver )
        {
            this.driver = driver;
        }

        public void Open()
        {
            driver.Navigate().GoToUrl("http://localhost:41419/");
        }

        public PlaceOrderPage GoToPlaceOrderForProduct(string name)
        {
            driver.FindElement(By.XPath("//h3[contains(text(),'"+name+"')]/../.././/a"))
                  .Click();
            return new PlaceOrderPage(driver);
        }
    }
}