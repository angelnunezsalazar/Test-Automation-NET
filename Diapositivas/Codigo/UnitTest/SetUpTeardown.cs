using Microsoft.VisualStudio.TestTools.UnitTesting;
namespace UnitTest
{
    using System;

    [TestClass]
    public class SetUpTeardown
    {
        private User user;

        [TestInitialize]
        public void SetUp(){
            user = CreateUser("user", "pass");
        }

        [TestMethod]
        public void TransferTest(){
            var isValid=Login("user", "pass");
            Assert.IsTrue(isValid);
        }

        [TestCleanup]
        public void TearDown(){
            RemoveUser(user);
        }

        private User CreateUser(string user, string pass)
        {
            throw new NotImplementedException();
        }

        private bool Login(string user, string pass)
        {
            throw new NotImplementedException();
        }

        private void RemoveUser(User user)
        {
            throw new NotImplementedException();
        }
    }

    internal class User
    {
    }
}