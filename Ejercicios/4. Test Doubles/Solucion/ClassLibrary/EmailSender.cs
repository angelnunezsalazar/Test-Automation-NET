using System;

namespace ClassLibrary
{
    public interface IEmailSender
    {
        void SendToAdmin(string message);
    }

    public class EmailSender : IEmailSender
    {
        public void SendToAdmin(string message)
        {
            //send mail to admin
        }
    }
}