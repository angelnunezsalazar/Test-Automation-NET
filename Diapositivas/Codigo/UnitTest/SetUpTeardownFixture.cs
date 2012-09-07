namespace UnitTest
{
    using System;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class SetUpTeardownFixture
    {
        [ClassInitialize]
        public void SetUpFixture(){
            ExpensiveSetupOperation();
        }

        [ClassCleanup]
        public void TearDownFixture(){
            ExpensiveTearDownOperation();
        }

        private void ExpensiveSetupOperation()
        {
            throw new NotImplementedException();
        }

        private void ExpensiveTearDownOperation()
        {
            throw new NotImplementedException();
        }
    }
}