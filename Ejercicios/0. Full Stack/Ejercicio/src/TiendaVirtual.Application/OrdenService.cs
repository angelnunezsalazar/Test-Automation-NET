namespace TiendaVirtual.Application
{
    using System;

    using TiendaVirtual.DataAccess;
    using TiendaVirtual.Domain;
    using TiendaVirtual.Domain.Exceptions;

    public class OrdenService
    {
        public void ReservarInventario(LineaOrden linea)
        {
            var inventarioDAO = new AlmacenDAO();
            var producto = linea.Producto;
            var inventario = inventarioDAO.CantidadInventario(producto.Id);
            if (inventario < linea.Cantidad)
                throw new InventarioInsuficienteException();

            inventarioDAO.DisminuirInventario(producto.Id, linea.Cantidad);
        }
    }
}