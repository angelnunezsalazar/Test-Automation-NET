namespace WebTesting.Tests.Google
{
    using OpenQA.Selenium;
    using OpenQA.Selenium.Support.PageObjects;

    public class GoogleSearchPage
    {
        protected IWebDriver driver;

        [FindsBy(How = How.Name, Using = "q")]
        private IWebElement q;

        public GoogleSearchPage(IWebDriver driver)
        {
            this.driver = driver;
            PageFactory.InitElements(driver, this);
        }

        public void SearchFor(string searchTerm)
        {
            q.SendKeys(searchTerm);
            q.Submit();
        }

        public void Open()
        {
            driver.Url = "http://www.google.com";
        }

        public void Close()
        {
            driver.Quit();
        }

        public string Title
        {
            get
            {
                return this.driver.Title;
            }
        }
    }
}