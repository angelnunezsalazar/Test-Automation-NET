namespace TiendaVirtual.Domain
{
    using System.ComponentModel.DataAnnotations;

    public class Producto
    {
        public Producto( )
        {
            this.Imagen=new Imagen();
        }

        public int Id { get; set; }

        [Required(ErrorMessage = "El {0} es obligatorio")]
        public string Nombre { get; set; }

        [Required(ErrorMessage = "El {0} es obligatorio")]
        public decimal Precio { get; set; }

        public int CategoriaId { get; set; }

        public Imagen Imagen { get; set; }

        public virtual Categoria Categoria { get; set; }
    }
}