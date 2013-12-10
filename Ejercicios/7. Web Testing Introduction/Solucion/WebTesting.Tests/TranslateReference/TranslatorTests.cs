namespace WebTesting.Tests.TranslateReference
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using OpenQA.Selenium;
    using OpenQA.Selenium.Chrome;
    using OpenQA.Selenium.Support.UI;

    [TestClass]
    public class TranslatorTests
    {
        [TestMethod]
        public void GettingStarted()
        {
            //var driver = new FirefoxDriver();
            //var driver = new InternetExplorerDriver();
            var driver = new ChromeDriver();
            driver.Url = "http://www.google.com";

            driver.Navigate();

            Assert.AreEqual("Google", driver.Title);

            driver.Quit();
        }

        [TestMethod]
        public void TranslateWord()
        {
            var driver = new ChromeDriver();
            //driver.Manage().Timeouts().ImplicitlyWait(TimeSpan.FromSeconds(10));
            driver.Navigate().GoToUrl("http://translate.reference.com/");
            new SelectElement(driver.FindElement(By.Id("src"))).SelectByText("Spanish");
            new SelectElement(driver.FindElement(By.Id("dst"))).SelectByText("English");
            driver.FindElement(By.Id("query")).Click();
            driver.FindElement(By.Id("query")).SendKeys("hola mundo");
            
            driver.FindElement(By.CssSelector("button.trans_image")).Click();

            //var wait = new WebDriverWait(driver, TimeSpan.FromSeconds(10));
            //var translateText = wait.Until(x => x.FindElement(By.CssSelector("div.translateTxt"))).Text;
            var translateText = driver.FindElement(By.CssSelector("div.translateTxt")).Text;
            Assert.AreEqual("Hello World", translateText);

            driver.Quit();
        }

        [TestMethod]
        public void InsertSymbol()
        {
            var driver = new ChromeDriver();
            
            driver.Navigate().GoToUrl("http://translate.reference.com/");
            driver.FindElement(By.Id("query")).Click();
            driver.FindElement(By.LinkText("Symbols & accents")).Click();
            //driver.FindElement(By.XPath("//div[@id='tooltip_keyboard']/p[2]/button[32]")).Click();
            driver.FindElement(By.XPath("//button[text()='ñ']")).Click();
            driver.FindElement(By.CssSelector("span.ui-icon.ui-icon-closethick")).Click();

            var symbol = driver.FindElement(By.Id("query")).GetAttribute("value");
            Assert.AreEqual("ñ", symbol);
            
            driver.Quit();
        }
    }
}