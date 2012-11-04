namespace UnitTest
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    public class EstructuraDeUnaPrueba
    {
        public void UnitTest()
        {
            Stack stack = new Stack();
            Assert.IsTrue(stack.IsEmpty);
            stack.Push(1);
            Assert.IsFalse(stack.IsEmpty);
            int element = stack.Pop();
            Assert.AreEqual(1, element);
            stack.Push(2);
            stack.Push(3);
            Assert.AreEqual(3, stack.Pop());
            Assert.AreEqual(2, stack.Pop());
        }

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

    public class Stack
    {
        public bool IsEmpty { get; set; }

        public void Push(int i)
        {
            throw new System.NotImplementedException();
        }

        public int Pop()
        {
            throw new System.NotImplementedException();
        }
    }
}