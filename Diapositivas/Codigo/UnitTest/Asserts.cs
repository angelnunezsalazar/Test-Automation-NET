namespace UnitTest
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class Asserts
    {
        [TestMethod]
        public void Test()
        {

            Assert.AreEqual(2, Suma(1, 1));

            Assert.IsNull(null);

            Assert.AreEqual(2, Suma(1, 1), "1+1 debería ser 2");


        }



        private double Suma(int i, int i1)
        {
            return 0;
        }
    }
}