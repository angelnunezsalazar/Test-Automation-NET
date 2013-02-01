namespace TiendaVirtual.DataAccess
{
    using System.Linq;

    using Dapper;

    public class AlmacenDAO
    {
        public int CantidadInventario(int productoId)
        {
            using (var connection = new DatabaseContext().Database.Connection)
            {
                connection.Open();
                var cantidad=connection.Query<int>("select cantidad from Inventario where productoId=@productoId", new { productoId }).Single();
                return cantidad;
            }
        }

        public void DisminuirInventario(int productoId, int cantidad)
        {
            using (var connection = new DatabaseContext().Database.Connection)
            {
                connection.Open();
                connection.Execute("Update Inventario set cantidad=@cantidad where productoId=@productoId", new { productoId, cantidad });
            }
        }
    }
}