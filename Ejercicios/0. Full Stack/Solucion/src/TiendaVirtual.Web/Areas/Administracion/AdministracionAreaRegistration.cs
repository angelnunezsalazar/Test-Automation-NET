using System.Web.Mvc;

namespace TiendaVirtual.Web.Areas.Administracion
{
    public class AdministracionAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Administracion";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "Administracion_default",
                "Administracion/{controller}/{action}/{id}",
                new {controller="productos", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
