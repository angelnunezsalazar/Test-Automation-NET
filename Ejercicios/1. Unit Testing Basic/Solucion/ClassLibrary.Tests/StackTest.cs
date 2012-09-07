namespace ClassLibrary.Tests
{
    using System;

    using ClassLibrary;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class StackTest
    {
        private Stack stack;

        [TestInitialize]
        public void Setup()
        {
            this.stack = new Stack();
        }

        [TestMethod]
        public void IsEmpty_NewStack_ReturnsTrue()
        {
            this.stack = new Stack();

            bool isEmpty = this.stack.IsEmpty;

            Assert.IsTrue(isEmpty);
        }

        [TestMethod]
        public void IsEmpty_WithOneElement_ReturnsFalse()
        {
            stack.Push(1);

            bool isEmpty = stack.IsEmpty;

            Assert.IsFalse(isEmpty);
        }

        [TestMethod]
        public void IsEmpty_PushAndPopOneElement_ReturnsFalse()
        {
            stack.Push(1);
            stack.Pop();

            bool isEmpty = stack.IsEmpty;

            Assert.IsTrue(isEmpty);
        }

        [TestMethod]
        public void IsEmpty_PushTwoAndPopOne_ReturnsFalse()
        {
            stack.Push(1);
            stack.Push(2);
            stack.Pop();

            bool isEmpty = stack.IsEmpty;

            Assert.IsFalse(isEmpty);
        }

        [TestMethod]
        public void Pop_WithOneElement_ReturnsTheElement()
        {
            stack.Push(1);

            int element = stack.Pop();

            Assert.AreEqual(1, element);
        }

        [TestMethod]
        public void Pop_WithTwoElements_ReturnsTheSecondElementPushed()
        {
            stack.Push(1);
            stack.Push(2);

            int element = stack.Pop();

            Assert.AreEqual(2, element);
        }

        [TestMethod]
        public void Pop_PushTwoPopTwo_ReturnsTheFirstElementPushed()
        {
            stack.Push(1);
            stack.Push(2);
            stack.Pop();

            int element = stack.Pop();

            Assert.AreEqual(1, element);
        }

        [TestMethod]
        public void Pop_WithNoItems_ThrowsException()
        {
            try
            {
                stack.Pop();
                Assert.Fail();
            }
            catch (InvalidOperationException) { }
        }
    }
}
