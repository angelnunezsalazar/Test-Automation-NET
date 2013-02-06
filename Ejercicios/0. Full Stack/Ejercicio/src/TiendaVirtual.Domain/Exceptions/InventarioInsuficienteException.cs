namespace TiendaVirtual.Domain.Exceptions
{
    using System;

    public class InventarioInsuficienteException:Exception
    {
        public InventarioInsuficienteException():
            base("Insuficiente inventario, revisar la orden")
        {
        }
    }
}