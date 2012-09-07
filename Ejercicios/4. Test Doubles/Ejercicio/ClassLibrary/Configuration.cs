using System;
using System.Configuration;

namespace ClassLibrary
{
    public class Configuration
    {
        public Level LoggerLevel()
        {
            var configurationLevel = ConfigurationManager.AppSettings["LoggerLevel"];
            Level level;
            Enum.TryParse(configurationLevel, out level);
            return level;
        }
    }
}