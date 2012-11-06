using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.Support.UI;

namespace SeleniumTests
{
    [TestFixture]
    public class TranslateWord
    {
        private IWebDriver driver;
        private StringBuilder verificationErrors;
        private string baseURL;
        
        [SetUp]
        public void SetupTest()
        {
            driver = new FirefoxDriver();
            baseURL = "http://translate.reference.com/";
            verificationErrors = new StringBuilder();
        }
        
        [TearDown]
        public void TeardownTest()
        {
            try
            {
                driver.Quit();
            }
            catch (Exception)
            {
                // Ignore errors if unable to close the browser
            }
            Assert.AreEqual("", verificationErrors.ToString());
        }
        
        [Test]
        public void TheTranslateWordTest()
        {
            driver.Navigate().GoToUrl(baseURL + "/");
            new SelectElement(driver.FindElement(By.Id("src"))).SelectByText("Spanish");
            driver.FindElement(By.Id("query")).Click();
            driver.FindElement(By.Id("query")).Clear();
            driver.FindElement(By.Id("query")).SendKeys("hola mundo");
            driver.FindElement(By.CssSelector("button.trans_image")).Click();
            try
            {
                Assert.AreEqual("Hello World", driver.FindElement(By.CssSelector("div.translateTxt")).Text);
            }
            catch (AssertionException e)
            {
                verificationErrors.Append(e.Message);
            }
        }
        private bool IsElementPresent(By by)
        {
            try
            {
                driver.FindElement(by);
                return true;
            }
            catch (NoSuchElementException)
            {
                return false;
            }
        }
    }
}
