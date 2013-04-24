namespace ClassLibrary
{
    using System;

    public class AlmacenService
    {
        private AlmacenDAO almacenDAO;
        public AlmacenService()
        {
            this.almacenDAO = new AlmacenDAO();
        }

        public void ReservarInventario(int productoId, int cantidad)
        {
            var inventario = almacenDAO.CantidadInventario(productoId);
            if (inventario < cantidad)
                throw new InventarioInsuficienteException();

            almacenDAO.DisminuirInventario(productoId, cantidad);
        }
    }
}