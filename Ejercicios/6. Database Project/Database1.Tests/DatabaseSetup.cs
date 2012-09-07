using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Data.Schema.UnitTesting;

namespace Database1.Tests
{
    [TestClass()]
    public class DatabaseSetup
    {

        [AssemblyInitialize()]
        public static void InitializeAssembly(TestContext ctx)
        {
            //   Setup the test database based on setting in the
            // configuration file
            DatabaseTestClass.TestService.DeployDatabaseProject();
            DatabaseTestClass.TestService.GenerateData();
        }

    }
}
