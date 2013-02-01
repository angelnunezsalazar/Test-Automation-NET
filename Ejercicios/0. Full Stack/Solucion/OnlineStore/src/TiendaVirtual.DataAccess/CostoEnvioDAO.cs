namespace TiendaVirtual.DataAccess
{
    using System.Linq;

    using Dapper;

    public class CostoEnvioDAO
    {
        public decimal Obtener(string pais)
        {
            using (var connection = new DatabaseContext().Database.Connection)
            {
                connection.Open();
                var costo = connection.Query<decimal>("Select costo from CostoEnvioPais where pais=@pais", new { pais }).Single();
                return costo;
            }
        }

        public void Actualizar(string pais, decimal costo)
        {
            using (var connection = new DatabaseContext().Database.Connection)
            {
                connection.Open();
                connection.Execute("Update CostoEnvioPais set costo=@costo where pais=@pais", new { costo, pais });
            }
        }
    }
}