namespace TiendaVirtual.DataAccess.Infraestructure
{
    using System;
    using System.Security.Cryptography;
    using System.Text;

    public class Cryptographer
    {
        public string GetHash(string word)
        {
            HashAlgorithm algorithm = SHA512.Create();
            byte[] hash = algorithm.ComputeHash(Encoding.UTF8.GetBytes(word));

            return Convert.ToBase64String(hash);
        }
    }
}