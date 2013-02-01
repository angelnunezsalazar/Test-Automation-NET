namespace TiendaVirtual.Application
{
    using TiendaVirtual.DataAccess.Infraestructure;
    using TiendaVirtual.Domain;

    public class LoginService
    {
        public bool CoincidePassword(Usuario usuario, string password)
        {
            var cryptographer = new Cryptographer();
            var passwordHash = cryptographer.GetHash(password);
            return passwordHash.Equals(usuario.Password);
        }
    }
}