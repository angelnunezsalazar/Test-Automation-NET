namespace WebTesting.Tests.StackOverflow
{
    using System;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using OpenQA.Selenium;
    using OpenQA.Selenium.Chrome;
    using OpenQA.Selenium.Firefox;
    using System.Linq;

    using OpenQA.Selenium.IE;

    [TestClass]
    public class StackoverflowTests
    {
        private IWebDriver driver;
        [TestInitialize]
        public void Setup()
        {
            //driver = new InternetExplorerDriver(@"C:\Users\Snahider\Documents\Visual Studio 2010\Projects\ATesting\WebTesting\Drivers");
            //driver = new ChromeDriver(@"C:\Users\Snahider\Documents\Visual Studio 2010\Projects\WebTesting\Drivers");
            driver = new FirefoxDriver();
            driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds(10));
        }

        [TestMethod]
        public void ReleatedTags()
        {
            driver.Navigate().GoToUrl("http://stackoverflow.com/");

            var textsearch = driver.FindElement(By.Name("q"));
            textsearch.SendKeys("[c#]");
            textsearch.Submit();

            var relatedTags = driver.FindElements(By.XPath("//h4[@id='h-related-tags']/following-sibling::a"));
            var exists = relatedTags.Any(x => x.Text == ".net");
            Assert.IsTrue(exists);
        }

        [TestMethod]
        public void ReleatedTags_PageObject()
        {
            var stackoverflowPage = new StackoverflowPage(driver);

            stackoverflowPage.Open();
            stackoverflowPage.SearchFor("[c#]");

            var relatedTags = stackoverflowPage.RelatedTags;
            var exists = relatedTags.Any(x => x == ".net");
            Assert.IsTrue(exists);
        }

        [TestMethod]
        public void SearchResultHasTheCorrectTag()
        {
            driver.Navigate().GoToUrl("http://stackoverflow.com/");

            var textsearch = driver.FindElement(By.Name("q"));
            textsearch.SendKeys("[c#]");
            textsearch.Submit();
            //driver.FindElement(By.LinkText("save username but shows name in c#")).Click();
            driver.FindElement(By.XPath("//div[@id='questions']/div[1]/div/h3/a")).Click();

            var relatedTags = driver.FindElements(By.XPath("//div[@class='post-taglist']/a"));
            var exists = relatedTags.Any(x => x.Text == "c#");
            Assert.IsTrue(exists);
        }

        [TestCleanup]
        public void Teardown()
        {
            driver.Quit();
        }
    }
}