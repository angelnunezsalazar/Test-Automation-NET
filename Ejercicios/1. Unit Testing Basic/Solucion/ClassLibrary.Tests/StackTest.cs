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
        public void IsEmptyWhenNew()//Está vacio si no tiene elementos
        {
            this.stack = new Stack();

            bool isEmpty = this.stack.IsEmpty;

            Assert.IsTrue(isEmpty);
        }

        [TestMethod]
        public void NotIsEmptyWhenPushingAnItem()//No está vacio si colocamos elemento
        {
            stack.Push(1);

            bool isEmpty = stack.IsEmpty;

            Assert.IsFalse(isEmpty);
        }

        [TestMethod]
        public void RemovesTheItemWhenPopping()//Elimina un elemento de la lista al obtenerlo
        {
            stack.Push(1);
            
            stack.Pop();

            bool isEmpty = stack.IsEmpty;
            Assert.IsTrue(isEmpty);
        }

        [TestMethod]
        public void PopsTheSameItemThatWasPushed()//Retorna el mismo elemento que se ha ingresado
        {
            stack.Push(1);

            int element = stack.Pop();

            Assert.AreEqual(1, element);
        }

        [TestMethod]
        public void TheFirstItemPoppedIsTheLastItemPushed()//El primer elemento obtenido es último elemento que ha sido ingresado
        {
            stack.Push(1);
            stack.Push(2);
            stack.Push(3);

            Assert.AreEqual(3, stack.Pop());
            Assert.AreEqual(2, stack.Pop());
            Assert.AreEqual(1, stack.Pop());
        }

        [TestMethod]
        public void ThrowsExceptionWhenPoppingAnItemItDoesntHold()//Lanza una excepción al obtener un elemento que no ha sido ingresado
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
