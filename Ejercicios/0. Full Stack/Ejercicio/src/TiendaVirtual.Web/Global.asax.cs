using System.Web.Mvc;
using System.Web.Routing;

namespace TiendaVirtual.Web
{
    using TiendaVirtual.Domain;
    using TiendaVirtual.Web.CustomModelBinders;
    using TiendaVirtual.Web.Models;

    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }

        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.IgnoreRoute("{*favicon}", new { favicon = @"(.*/)?favicon.ico(/.*)?" });

            routes.MapRoute(null,"",
                new { controller = "Home", action = "Index", pagina = 1, categoria = (string)null }
            );

            routes.MapRoute(null,
                "pagina{pagina}",
                new { controller = "Home", action = "Index", categoria = (string)null }
            );

            routes.MapRoute(null,
                "{categoria}",
                new { controller = "Home", action = "Index", pagina = 1 }
            );

            routes.MapRoute(null,
                "{categoria}/pagina{pagina}",
                new { controller = "Home", action = "Index" },
                new { pagina = @"\d+" }
            );

            routes.MapRoute(
                "Default", // Route name
                "{controller}/{action}/{id}", // URL with parameters
                new { controller = "Home", action = "Index", id = UrlParameter.Optional } // Parameter defaults
            );

        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            RegisterGlobalFilters(GlobalFilters.Filters);
            RegisterRoutes(RouteTable.Routes);

            ModelBinders.Binders.Add(typeof(CarroCompras), new CarroComprasModelBinder()); 
        }
    }
}