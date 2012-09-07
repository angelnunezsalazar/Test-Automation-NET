using System;
using System.Text;
using System.Data;
using System.Data.Common;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Data.Schema.UnitTesting;
using Microsoft.Data.Schema.UnitTesting.Conditions;

namespace Database1.Tests
{
    [TestClass()]
    public class EmployeeCreateTests : DatabaseTestClass
    {

        public EmployeeCreateTests()
        {
            InitializeComponent();
        }

        [TestInitialize()]
        public void TestInitialize()
        {
            base.InitializeTest();
        }
        [TestCleanup()]
        public void TestCleanup()
        {
            base.CleanupTest();
        }

        #region Designer support code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            Microsoft.Data.Schema.UnitTesting.DatabaseTestAction dbo_uspCreateEmployeeTest_TestAction;
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(EmployeeCreateTests));
            Microsoft.Data.Schema.UnitTesting.Conditions.RowCountCondition EmployeeCount;
            this.dbo_uspCreateEmployeeTestData = new Microsoft.Data.Schema.UnitTesting.DatabaseTestActions();
            dbo_uspCreateEmployeeTest_TestAction = new Microsoft.Data.Schema.UnitTesting.DatabaseTestAction();
            EmployeeCount = new Microsoft.Data.Schema.UnitTesting.Conditions.RowCountCondition();
            // 
            // dbo_uspCreateEmployeeTest_TestAction
            // 
            dbo_uspCreateEmployeeTest_TestAction.Conditions.Add(EmployeeCount);
            resources.ApplyResources(dbo_uspCreateEmployeeTest_TestAction, "dbo_uspCreateEmployeeTest_TestAction");
            // 
            // EmployeeCount
            // 
            EmployeeCount.Enabled = true;
            EmployeeCount.Name = "EmployeeCount";
            EmployeeCount.ResultSet = 1;
            EmployeeCount.RowCount = 1;
            // 
            // dbo_uspCreateEmployeeTestData
            // 
            this.dbo_uspCreateEmployeeTestData.PosttestAction = null;
            this.dbo_uspCreateEmployeeTestData.PretestAction = null;
            this.dbo_uspCreateEmployeeTestData.TestAction = dbo_uspCreateEmployeeTest_TestAction;
        }

        #endregion


        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        #endregion


        [TestMethod()]
        public void dbo_uspCreateEmployeeTest()
        {
            DatabaseTestActions testActions = this.dbo_uspCreateEmployeeTestData;
            // Execute the pre-test script
            // 
            System.Diagnostics.Trace.WriteLineIf((testActions.PretestAction != null), "Executing pre-test script...");
            ExecutionResult[] pretestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PretestAction);
            // Execute the test script
            // 
            System.Diagnostics.Trace.WriteLineIf((testActions.TestAction != null), "Executing test script...");
            ExecutionResult[] testResults = TestService.Execute(this.ExecutionContext, this.PrivilegedContext, testActions.TestAction);
            // Execute the post-test script
            // 
            System.Diagnostics.Trace.WriteLineIf((testActions.PosttestAction != null), "Executing post-test script...");
            ExecutionResult[] posttestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PosttestAction);
        }
        private DatabaseTestActions dbo_uspCreateEmployeeTestData;
    }
}
