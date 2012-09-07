namespace UnitTest
{
    using System;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    public class Exceptions
    {

        [TestMethod]
        public void ExceptionTest1()
        {
            try
            {
                Login("usuario", "password");
                Assert.Fail();
            }
            catch (InvalidLoginException e)
            {
                //Si llego acá significa que se produjo la excepción adecuada
                //Podemos realizar asertos al mensaje
                Assert.AreEqual("Usuario o password incorrecto", e.Message);
            }
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidLoginException), "Usuario o password incorrecto")]
        public void ExceptionTest()
        {
            Login("Usuario", "Password");
        }

        private void Login(string usuario, string password)
        {
            throw new NotImplementedException();
        }
    }

    public class InvalidLoginException : Exception
    {
    }
}