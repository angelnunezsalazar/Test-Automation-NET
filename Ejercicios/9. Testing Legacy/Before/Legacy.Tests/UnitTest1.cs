using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using MyBillingProduct;

namespace Legacy.Tests
{
    [TestClass]
    public class UnitTest1
    {
 
    }

    public class TesteableLoggingManager : LoginManager {

        public string user;
        public override void WriteLogger(string user)
        {
            this.user = user;
        }
    }
}
