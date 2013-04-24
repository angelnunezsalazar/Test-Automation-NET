using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using UnitTest.Shared;

namespace UnitTest
{
    class NuestraSegundaPrueba
    {

        [TestMethod]
        public void noEstaVacioCuandoContieneElementos()
        {
            Stack stack = new Stack();
            stack.Push(1);

            bool isEmpty = stack.IsEmpty;

            Assert.IsFalse(isEmpty);
        }
    }
}
