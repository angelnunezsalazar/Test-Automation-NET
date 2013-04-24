using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using UnitTest.Shared;

namespace UnitTest
{
    class NombreDeLasPruebas
    {
        [TestMethod]
        public void estaVacioCuandoNoTieneElementos()
        {
            Stack stack = new Stack();
            boolean isEmtpy = stack.IsEmpty;
            Assert.IsTrue(isEmpty);
        }
    }
}
