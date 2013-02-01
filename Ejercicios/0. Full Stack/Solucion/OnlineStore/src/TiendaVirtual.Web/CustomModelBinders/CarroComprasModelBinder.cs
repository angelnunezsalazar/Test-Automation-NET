namespace TiendaVirtual.Web.CustomModelBinders
{
    using System.Web.Mvc;

    using TiendaVirtual.Domain;
    using TiendaVirtual.Web.Models;

    public class CarroComprasModelBinder : IModelBinder
    {
        private const string sessionKey = "CarroCompras";
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            CarroCompras carroCompras = (CarroCompras)controllerContext.HttpContext.Session[sessionKey];
            if (carroCompras == null)
            {
                carroCompras = new CarroCompras();
                controllerContext.HttpContext.Session[sessionKey] = carroCompras;
            }
            return carroCompras;
        }
    }
}