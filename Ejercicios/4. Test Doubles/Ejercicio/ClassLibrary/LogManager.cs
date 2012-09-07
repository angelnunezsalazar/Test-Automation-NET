namespace ClassLibrary
{
    using System.Collections.Generic;

    public class LogManager
    {
        private readonly IList<Level> orderedLevels = new List<Level> { Level.Error, Level.Info, Level.Debug };

        public void Write(string message, Level level)
        {
            if (level == Level.Error)
            {
                var emailSender = new EmailSender();
                emailSender.SendToAdmin(message);
            }

            if (IsEnabled(level))
            {
                var appender = new FileAppender();
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
            var configuration = new Configuration();
            return configuration.LoggerLevel();
        }

        private bool MessageLevelIsBeforeOrEqualThanLoggerLevel(Level messageLevel, Level loggingLevel)
        {
            return orderedLevels.IndexOf(messageLevel) <= orderedLevels.IndexOf(loggingLevel);
        }
    }
}
