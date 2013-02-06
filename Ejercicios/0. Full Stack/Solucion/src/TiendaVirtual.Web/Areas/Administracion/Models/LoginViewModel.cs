namespace TiendaVirtual.Web.Areas.Administracion.Models
{
    using System.ComponentModel.DataAnnotations;

    public class LoginViewModel
    {
        [Required(ErrorMessage = "Ingrese el Usuario")]
        public string Usuario { get; set; }

        [DataType(DataType.Password)]
        [Required(ErrorMessage = "Ingrese el Password")]
        public string Password { get; set; }
    }
}