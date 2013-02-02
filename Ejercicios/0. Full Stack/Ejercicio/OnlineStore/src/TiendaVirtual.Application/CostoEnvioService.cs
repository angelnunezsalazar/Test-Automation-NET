namespace TiendaVirtual.Application
{
    using System;

    using TiendaVirtual.DataAccess;
    using TiendaVirtual.Domain;
    using TiendaVirtual.Domain.Exceptions;

    public class CostoEnvioService
    {
        private int ENVIO_GRATIS = 0;

        public decimal Calcular(DireccionEnvio direccionEnvio)
        {
            if (direccionEnvio.Pais == "USA")
                return ENVIO_GRATIS;

            var costoEnvioDAO = new CostoEnvioDAO();
            return costoEnvioDAO.Obtener(direccionEnvio.Pais);
        }

        public void ActualizarCosto(string pais, decimal costo)
        {
            if (costo == 0)
                throw new CostoEnvioInvalidoException();

            var costoEnvioDAO = new CostoEnvioDAO();
            costoEnvioDAO.Actualizar(pais, costo);
        }
    }
}