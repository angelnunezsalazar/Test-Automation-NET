namespace UnitTest
{
    public enum CategoriaCliente
    {
        Platinum
    }

    public class CodigoLogico
    {
        public int CalcularDescuento(decimal monto,CategoriaCliente categoriaCliente)
        {
            int descuento = 0;

            if (monto > 1000) 
                descuento = 50;

            if (categoriaCliente == CategoriaCliente.Platinum)
                descuento += 10;

            return descuento;
        }
    }
}