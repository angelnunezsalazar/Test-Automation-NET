namespace TiendaVirtual.Domain
{
    using System.Collections.Generic;

    public class Categoria
    {
        public Categoria()
        {
            this.Productos = new List<Producto>();
        }

        public int Id { get; set; }

        public string Nombre { get; set; }

        public virtual IList<Producto> Productos { get; set; }
    }
}