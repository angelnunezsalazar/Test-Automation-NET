namespace ClassLibrary
{
    using System.Collections.Generic;

    public class LogManager
    {
        private readonly IList<Level> orderedLevels = new List<Level> { Level.Error, Level.Info, Level.Debug };

        private IConfiguration configuration;
        private IEmailSender emailSender;
        private IAppender appender;

        public LogManager(IConfiguration configuration, IEmailSender emailSender, IAppender appender)
        {
            this.emailSender = emailSender;
            this.appender = appender;
            this.configuration = configuration;
        }

        public void Write(string message, Level level)
        {
            if (level == Level.Error)
            {
                emailSender.SendToAdmin(message);
            }

            if (IsEnabled(level))
            {
                appender.Write(message);
            }
        }

        public bool IsEnabled(Level messageLevel)
        {
            var loggerLevel = LevelFromAppConfiguration();
            return MessageLevelIsBeforeOrEqualThanLoggerLevel(messageLevel, loggerLevel);
        }

        private Level LevelFromAppConfiguration()
        {
            return configuration.LoggerLevel();
        }

        private bool MessageLevelIsBeforeOrEqualThanLoggerLevel(Level messageLevel, Level loggingLevel)
        {
            return orderedLevels.IndexOf(messageLevel) <= orderedLevels.IndexOf(loggingLevel);
        }
    }
}
