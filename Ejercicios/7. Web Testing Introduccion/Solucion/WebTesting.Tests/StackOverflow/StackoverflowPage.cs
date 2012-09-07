namespace WebTesting.Tests.StackOverflow
{
    using System.Collections.Generic;
    using System.Linq;

    using OpenQA.Selenium;
    using OpenQA.Selenium.Support.PageObjects;

    public class StackoverflowPage
    {
        private readonly IWebDriver driver;

        [FindsBy(How = How.Name, Using = "q")]
        private IWebElement searchInput;

        public StackoverflowPage(IWebDriver driver)
        {
            this.driver = driver;
            PageFactory.InitElements(driver, this);
        }

        public void Open()
        {
            driver.Url = "http://stackoverflow.com/";
        }

        public void SearchFor(string query)
        {
            searchInput.SendKeys(query);
            searchInput.Submit();
        }


        public IEnumerable<string> RelatedTags
        {
            get
            {
                return driver
                    .FindElements(By.XPath("//h4[@id='h-related-tags']/following-sibling::a"))
                    .Select(x => x.Text);
            }
        }
    }
}