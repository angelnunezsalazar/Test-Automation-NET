namespace TiendaVirtual.Domain
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class CarroCompras
    {
        public DireccionEnvio Envio { get; set; }

        public decimal CostoEnvio { get; set; }

        private List<LineaCarroCompras> detalle = new List<LineaCarroCompras>();

        public void AgregarLinea(Producto producto)
        {
            LineaCarroCompras linea = this.BuscarLinea(producto.Id);

            if (linea == null)
            {
                this.detalle.Add(new LineaCarroCompras { Producto = producto, Cantidad = 1 });
            }
            else
            {
                linea.Cantidad += 1;
            }
        }

        public void ActualizarLinea(int productoId, int cantidad)
        {
            LineaCarroCompras linea = BuscarLinea(productoId);
            if (linea == null)
                throw new Exception("No existe el producto");

            if (cantidad == 0)
                this.RemoverLinea(productoId);

            linea.Cantidad = cantidad;
        }

        public void RemoverLinea(int productoId)
        {
            LineaCarroCompras linea = BuscarLinea(productoId);
            if (linea == null)
                throw new Exception("No existe el producto");

            this.detalle.RemoveAll(l => l.Producto.Id == productoId);
        }

        public int CantidadProductos
        {
            get
            {
                return this.detalle.Sum(x => x.Cantidad);
            }
        }

        public decimal Total
        {
            get
            {
                return this.detalle.Sum(x => x.Producto.Precio * x.Cantidad) + CostoEnvio;
            }
        }

        public LineaCarroCompras BuscarLinea(int productoId)
        {
            return (from linea in this.detalle
                    where linea.Producto.Id == productoId
                    select linea).SingleOrDefault();
        }

        public IEnumerable<LineaCarroCompras> Detalle
        {
            get { return this.detalle; }
        }
    }

    public class LineaCarroCompras
    {
        public Producto Producto { get; set; }
        public int Cantidad { get; set; }

        public decimal SubTotal
        {
            get
            {
                return this.Producto.Precio * this.Cantidad;
            }
        }
    }
}