namespace TiendaVirtual.Application
{
    using System;

    using TiendaVirtual.DataAccess;
    using TiendaVirtual.Domain;
    using TiendaVirtual.Domain.Exceptions;

    public class OrdenService
    {
        public void RealizarPedido(Orden orden)
        {
            foreach (var linea in orden.Lineas)
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
}