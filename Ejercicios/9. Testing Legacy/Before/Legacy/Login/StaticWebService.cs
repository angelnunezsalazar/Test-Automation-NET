using System;

namespace Step1Mocks
{
    public class StaticWebService
    {
        public static void Write(string text)
        {
            if (text!="admin")
            {
                throw new NotImplementedException();
            }
           
        }
    }
}
