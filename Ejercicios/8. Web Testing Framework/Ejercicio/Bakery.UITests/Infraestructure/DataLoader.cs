using System.Collections.Generic;
using Bakery.Web.Models;

namespace Bakery.UITests.Infraestructure
{
    using Web.Database;

    public class DataLoader
    {
        private List<Entity> savedObjects = new List<Entity>();

        public T LoadData<T>(T obj) where T : Entity
        {
            var dataAccess = new DataAccess();
            dataAccess.Save(obj);
            savedObjects.Add(obj);
            return obj;
        }

        public void Clean()
        {
            foreach (var obj in savedObjects)
            {
                var dataAccess = new DataAccess();
                dataAccess.Delete(obj);
            }
        }
    }
}