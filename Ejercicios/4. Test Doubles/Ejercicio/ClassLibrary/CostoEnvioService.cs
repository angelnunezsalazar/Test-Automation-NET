namespace ClassLibrary
{
    using System;

    public class CostoEnvioService
    {
        private int ENVIO_GRATIS = 0;

        private CostoEnvioDAO costoEnvioDAO;

        public CostoEnvioService()
        {
            this.costoEnvioDAO = new CostoEnvioDAO();
        }

        public decimal Calcular(string pais)
        {
            if (pais == "USA")
                return ENVIO_GRATIS;

            return costoEnvioDAO.Obtener(pais);
        }

        public void ActualizarCosto(string pais, decimal costo)
        {
            if (costo == 0)
                throw new ArgumentException("Costo envio no puede ser 0");

            costoEnvioDAO.Actualizar(pais, costo);
        }
    }
}