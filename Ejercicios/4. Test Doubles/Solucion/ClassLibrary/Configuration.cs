using System;
using System.Configuration;

namespace ClassLibrary
{
    public interface IConfiguration
    {
        Level LoggerLevel();
    }

    public class Configuration : IConfiguration
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