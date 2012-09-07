namespace ClassLibrary.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class LogManagerTests
    {
        private Mock<IConfiguration> configuration;
        private Mock<IEmailSender> emailSender;
        private Mock<IAppender> appender;
        private LogManager logManager;

        [TestInitialize]
        public void Setup()
        {
            this.configuration = new Mock<IConfiguration>();
            this.emailSender = new Mock<IEmailSender>();
            this.appender = new Mock<IAppender>();
            this.logManager = new LogManager(configuration.Object, emailSender.Object, appender.Object);
        }

        [TestMethod]
        public void IsEnabled_MessageLevelBeforeLoggerLevel_ReturnTrue()
        {
            configuration.Setup(x => x.LoggerLevel()).Returns(Level.Info);

            bool isEnabled = this.logManager.IsEnabled(Level.Error);

            Assert.IsTrue(isEnabled);
        }

        [TestMethod]
        public void IsEnabled_MessageLevelAfterLoggerLevel_ReturnFalse()
        {
            configuration.Setup(x => x.LoggerLevel()).Returns(Level.Info);            

            bool isEnabled = logManager.IsEnabled(Level.Debug);

            Assert.IsFalse(isEnabled);
        }

        [TestMethod]
        public void Write_LevelError_SendMailtoAdmin()
        {
            logManager.Write("message", Level.Error);

            emailSender.Verify(x => x.SendToAdmin("message"));
        }

        [TestMethod]
        public void Write_IsEnabled_WriteToAppender()
        {
            configuration.Setup(x => x.LoggerLevel()).Returns(Level.Info);

            logManager.Write("message", Level.Info);

            appender.Verify(x => x.Write("message"));
        }
    }
}