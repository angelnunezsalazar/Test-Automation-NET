namespace TiendaVirtual.Domain
{
    using System.Collections.Generic;

    public class Orden
    {
        public int Id { get; set; }

        public decimal TotalProductos { get; set; }

        public decimal TotalEnvio { get; set; }

        public decimal Total { get; set; }

        public DireccionEnvio Envio { get; set; }

        public IList<LineaOrden> Lineas { get; set; }

        public Orden(CarroCompras carroCompras)
        {
            this.Envio = carroCompras.Envio;
            this.TotalProductos = carroCompras.Total;
            this.TotalEnvio = 20;
            this.Total = carroCompras.Total + 20;
        }

        public void AgregarLineasCarroCompras(CarroCompras carroCompras)
        {
            foreach (var lineaCarro in carroCompras.Detalle)
            {
                var lineaOrden = new LineaOrden(lineaCarro.Producto, lineaCarro.Cantidad);
                this.Lineas.Add(lineaOrden);
            }
        }
    }
}