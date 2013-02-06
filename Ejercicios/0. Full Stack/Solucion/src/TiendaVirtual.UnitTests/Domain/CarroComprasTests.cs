using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TiendaVirtual.UnitTests.Domain
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using TiendaVirtual.Domain;

    [TestClass]
    public class CarroComprasTests
    {
        [TestMethod]
        public void AgregaUnaNuevaLineaCuandoElProductoNoExiste()
        {
            var carroCompras = new CarroCompras();

            carroCompras.AgregarLinea(new Producto());

            Assert.AreEqual(1, carroCompras.CantidadProductos);
        }

        [TestMethod]
        public void IncrementaLaCantidadAlAgregarUnaLineaCuandoElProductoExiste()
        {
            var carroCompras = new CarroCompras();
            carroCompras.AgregarLinea(new Producto { Id = 1 });

            carroCompras.AgregarLinea(new Producto { Id = 1 });

            Assert.AreEqual(2, carroCompras.CantidadProductos);
        }

        [TestMethod]
        public void ActualizaLaCantidadCuandoElProductoExiste()
        {
            var carroCompras = new CarroCompras();
            carroCompras.AgregarLinea(new Producto { Id = 1 });

            carroCompras.ActualizarLinea(1, 3);

            Assert.AreEqual(3, carroCompras.CantidadProductos);
        }

        [TestMethod]
        public void RemueveLaLineaAlActualizarCuandoLaCantidadEsCero()
        {
            var carroCompras = new CarroCompras();
            carroCompras.AgregarLinea(new Producto { Id = 1 });

            carroCompras.ActualizarLinea(1, 0);

            Assert.AreEqual(0, carroCompras.CantidadProductos);
        }

        [TestMethod]
        [ExpectedException(typeof(Exception))]
        public void SeProduceUnErrorAlActualizarCuandoElProductoNoExiste()
        {
            var carroCompras = new CarroCompras();

            carroCompras.ActualizarLinea(1, 1);
        }

        public TestContext TestContext { get; set; }

        [DataSource("Microsoft.VisualStudio.TestTools.DataSource.CSV", 
                    "|DataDirectory|\\DataSource.csv", 
                    "DataSource#csv", 
                    DataAccessMethod.Sequential)] 
        [TestMethod]
        public void DataDrivenTesting()
        {
            var carroCompras = new CarroCompras();
            int cantidad = int.Parse(this.TestContext.DataRow["Cantidad"].ToString());
            int precio = int.Parse(this.TestContext.DataRow["Precio"].ToString()); ;
            int costoenvio = int.Parse(this.TestContext.DataRow["CostoEnvio"].ToString());
            for (int i = 0; i < cantidad; i++)
            {
                carroCompras.AgregarLinea(new Producto
                {
                    Id = 1,
                    Precio = precio
                });
            }
            carroCompras.CostoEnvio = costoenvio;

            var total = carroCompras.Total;

            Assert.AreEqual(int.Parse(this.TestContext.DataRow["Total"].ToString()),total);
        }
    }
}
