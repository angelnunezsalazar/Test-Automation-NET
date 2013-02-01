using System.Collections.Generic;

namespace TiendaVirtual.Web.Areas.Administracion.Models
{
    using TiendaVirtual.Domain;
    using System.Web.Mvc;

    public class EditarProductoViewModel
    {
        public EditarProductoViewModel(Producto producto, IEnumerable<Categoria> categorias)
        {
            Id = producto.Id;
            Nombre = producto.Nombre;
            Precio = producto.Precio.ToString();
            Categorias = new SelectList(categorias, "Id", "Nombre", producto.CategoriaId);
            TieneImagen = producto.Imagen.Ruta != null;
        }

        public int Id { get; set; }

        public string Nombre { get; set; }

        public string Precio { get; set; }

        public SelectList Categorias { get; set; }

        public bool TieneImagen { get; set; }
    }
}