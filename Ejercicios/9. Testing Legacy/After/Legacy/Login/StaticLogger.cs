using Legacy.Login;
using System;

namespace Step1Mocks
{
    public class StaticLogger
    {
        public static void Write(string user)
        {
            if (user=="admin")
            {
                throw new LoggerException();
            }
            
        }
    }
}
