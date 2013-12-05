using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using Bakery.Web.Models;
using CsvHelper;

namespace Bakery.Web.Database
{
    public class DataAccess
    {
        private string dataDirectory = ConfigurationManager.AppSettings["data-directory"];
        public List<T> ListAll<T>() where T : Entity
        {
            string fileName = typeof(T).Name;
            List<T> entities;
            using (TextReader textReader = new StreamReader(dataDirectory + "/" + fileName + ".txt"))
            {
                var csvReader = new CsvReader(textReader);
                entities = csvReader.GetRecords<T>().ToList();
            }
            return entities;
        }

        public Product GetProduct(string id)
        {
            List<Product> products = ListAll<Product>();
            return products.SingleOrDefault(x => x.Id == id);
        }

        public void Save<T>(T entity) where T : Entity
        {
            string fileName = typeof(T).Name;
            var entities = ListAll<T>();
            entity.Id = Guid.NewGuid().ToString("N");
            entities.Add(entity);

            using (TextWriter textWriter = new StreamWriter(dataDirectory + "/" + fileName + ".txt"))
            {
                var csvWriter = new CsvWriter(textWriter);
                csvWriter.WriteRecords(entities);
            }
        }

        public void Delete<T>(T entity) where T : Entity
        {
            string fileName = typeof(T).Name;
            var entities = ListAll<T>();
            T foundEntity = entities.SingleOrDefault(x => x.Id == entity.Id);
            if (foundEntity != null)
                entities.Remove(foundEntity);

            using (TextWriter textWriter = new StreamWriter(dataDirectory + "/" + fileName + ".txt"))
            {
                var csvWriter = new CsvWriter(textWriter);
                csvWriter.WriteRecords(entities);
            }
        }
    }
}