namespace Bakery.UITests.PageObjects
{
    using OpenQA.Selenium;
    using OpenQA.Selenium.Support.PageObjects;

    public class PlaceOrderPage
    {
        private readonly IWebDriver driver;

        [FindsBy(How = How.TagName, Using = "h1")]
        private IWebElement productName;

        [FindsBy(How = How.Id, Using = "orderPrice")]
        private IWebElement productPrice;

        public PlaceOrderPage(IWebDriver driver)
        {
            this.driver = driver;
            PageFactory.InitElements(driver, this);
        }

        public string ProductName
        {
            get
            {
                return productName.Text;
            }
        }

        public string ProductPrice
        {
            get
            {
                return productPrice.Text;
            }
        }
    }
}