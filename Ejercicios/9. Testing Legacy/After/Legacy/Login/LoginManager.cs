using System;
using System.Collections;
using Step1Mocks;

namespace Legacy.Login
{
    public class LoginManager
    {
        private Hashtable users = new Hashtable();

        public bool IsLoginOK(string user, string password)
        {
            try
            {
                LoggerWrite(user);
            }
            catch (LoggerException e)
            {
                WebServiceWrite(e);
            }
            if (users[user] != null && (string) users[user] == password)
            {
                return true;
            }
            return false;
        }

        protected void WebServiceWrite(LoggerException e)
        {
            StaticWebService.Write(e.Message + Environment.MachineName);
        }

        protected static void LoggerWrite(string user)
        {
            StaticLogger.Write(user);
        }

        public void AddUser(string user, string password)
        {
            users[user] = password;
        }

        public void ChangePass(string user, string oldPass, string newPassword)
        {
            users[user] = newPassword;
        }
    }
}
