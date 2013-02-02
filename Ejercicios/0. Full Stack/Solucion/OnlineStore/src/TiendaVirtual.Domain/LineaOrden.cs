namespace TiendaVirtual.Domain
{
    public class LineaOrden
    {
        public LineaOrden(Producto producto, int cantidad)
        {
            this.Producto = producto;
            this.Cantidad = cantidad;
        }

        public int Id { get; set; }

        public Producto Producto { get; set; }

        public int Cantidad { get; set; }
    }
}