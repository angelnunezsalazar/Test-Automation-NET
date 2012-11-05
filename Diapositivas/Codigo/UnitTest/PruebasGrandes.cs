namespace UnitTest
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using UnitTest.Shared;

    public class PruebasGrandes
    {
        [TestMethod]
        public void Test()
        {
            Stack stack = new Stack();
            Assert.IsTrue(stack.IsEmpty); //Test behaviour N°1

            stack.Push(1);
            Assert.IsFalse(stack.IsEmpty); //Test behaviour N°2

            Assert.AreEqual(1, stack.Pop()); //Test behaviour N°3
        }
    }
}