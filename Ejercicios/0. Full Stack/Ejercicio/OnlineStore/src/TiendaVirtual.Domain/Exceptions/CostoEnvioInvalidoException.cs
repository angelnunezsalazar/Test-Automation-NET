namespace TiendaVirtual.Domain.Exceptions
{
    using System;

    public class CostoEnvioInvalidoException:Exception
    {
        public CostoEnvioInvalidoException():
            base("El costo de envio no puede ser 0")
        {
        }
    }
}