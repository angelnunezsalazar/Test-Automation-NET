// ReSharper disable UseObjectOrCollectionInitializer
namespace WebTesting.Tests.Google
{
    using System;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using OpenQA.Selenium.Chrome;
    using OpenQA.Selenium.Firefox;
    using OpenQA.Selenium.IE;
    using OpenQA.Selenium.Support.PageObjects;
    using OpenQA.Selenium.Support.UI;

    [TestClass]
    public class GoogleSearchTests
    {
        [TestMethod]
        public void Search()
        {
            var driver = new FirefoxDriver();
            driver.Url = "http://www.google.com";

            var textbox = driver.FindElementByName("q");
            textbox.SendKeys("cats");
            textbox.Submit();

            // Google's search is rendered dynamically with JavaScript.
            // Wait for the page to load, timeout after 10 seconds
            var wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            wait.Until(x => x.Title.ToLower().StartsWith("cats"));

            Assert.IsTrue(driver.Title.Contains("cats"));
            driver.Quit();
        }

        [TestMethod]
        public void SearchWithPageObject()
        {
            var driver = new FirefoxDriver();
            var googleSearchPage = new GoogleSearchPage(driver);
            
            googleSearchPage.Open();
            googleSearchPage.SearchFor("cats");

            var wait = new WebDriverWait(driver, TimeSpan.FromSeconds(30));
            wait.Until(x => x.Title.ToLower().StartsWith("cats"));

            Assert.IsTrue(googleSearchPage.Title.Contains("cats"));
            driver.Quit();
        }
    }
}
// ReSharper restore UseObjectOrCollectionInitializer
