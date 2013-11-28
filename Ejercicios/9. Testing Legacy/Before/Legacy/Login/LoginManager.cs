using System;
using System.Collections;
using Step1Mocks;
using Legacy.Login;

namespace MyBillingProduct
{
	public class LoginManager
	{
	    private Hashtable m_users = new Hashtable();

	    public bool IsLoginOK(string user, string password)
	    {
	        try
	        {
                WriteLogger(user);
	        }
	        catch (LoggerException e)
	        {
	            StaticWebService.Write(e.Message + Environment.MachineName);
	        }
	        if (m_users[user] != null &&
	            (string) m_users[user] == password)
	        {
	            return true;
	        }
	        return false;
	    }

        public v void WriteLogger(string user)
        {
            StaticLogger.Write(user);
        }


	    public void AddUser(string user, string password)
	    {
	        m_users[user] = password;
	    }

	    public void ChangePass(string user, string oldPass, string newPassword)
		{
			m_users[user]= newPassword;
		}
	}
}
