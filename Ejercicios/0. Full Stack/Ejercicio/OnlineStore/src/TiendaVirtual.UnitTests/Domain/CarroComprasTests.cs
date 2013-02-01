namespace TiendaVirtual.UnitTests
{
    using System;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using TiendaVirtual.Domain;

    [TestClass]
    public class CarroComprasTests
    {
        [TestMethod]
        public void AgregarUnaLineaCuandoElProductoNoExista()
        {
            var carroCompras = new CarroCompras();
            var producto=new Producto();
            producto.Id = 1;

            carroCompras.AgregarLinea(producto);

            Assert.AreEqual(1,carroCompras.CantidadProductos);
            //Assert.IsTrue(carroCompras.CantidadProductos>0);
        }

        [TestMethod]
        public void IncrementaLACantidadCuandoElProductoYaExiste()
        {
            var carroCompras = new CarroCompras();
            var producto1 = new Producto();
            producto1.Id = 1;
            carroCompras.AgregarLinea(producto1);

            var producto2 = new Producto();
            producto2.Id = 1;
            carroCompras.AgregarLinea(producto2);

            Assert.AreEqual(2, carroCompras.CantidadProductos);
        }

        [TestMethod]
        public void ActualizaLaCantidadCuandoElProductoYaExiste()
        {
            var carroCompras = new CarroCompras();
            var producto = new Producto();
            producto.Id = 1;
            carroCompras.AgregarLinea(producto);

            carroCompras.ActualizarLinea(1,3);

            Assert.AreEqual(3,carroCompras.CantidadProductos);
        }

        [TestMethod]
        public void RemueveElProductoAlActualizarConCantidadCero()
        {
            var carroCompras = new CarroCompras();
            var producto = new Producto();
            producto.Id = 1;
            carroCompras.AgregarLinea(producto);

            carroCompras.ActualizarLinea(1, 0);

            Assert.AreEqual(0, carroCompras.CantidadProductos);
        }

        [TestMethod]
        [ExpectedException(typeof(Exception))]
        public void LanzaExcepcionCuandoActualizaUnProductoQueNoExiste()
        {
            var carroCompras = new CarroCompras();

            carroCompras.ActualizarLinea(1, 0);
        }

    }
}
