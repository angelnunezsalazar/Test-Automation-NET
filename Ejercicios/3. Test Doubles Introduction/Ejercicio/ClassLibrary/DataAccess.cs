using System.Collections.Generic;
using System.IO;
using System.Linq;
using CsvHelper;

namespace ClassLibrary
{
    using System;
    using System.Configuration;

    public class DataAccess
    {
        private string dataDirectory = ConfigurationManager.AppSettings["data-directory"];

        public int GetPromotionalDiscount(string coupon)
        {
            using (TextReader textReader = new StreamReader(dataDirectory + "/discounts.txt"))
            {
                var csv = new CsvReader(textReader);
                var discounts = csv.GetRecords<Discount>();
                var discount = discounts.SingleOrDefault(x => x.Coupon == coupon);
                if (discount == null)
                    throw new Exception("Coupon not found");
                return discount.Percentage;
            }
        }

        public void SaveOrder(Order order)
        {
            var orders = new List<Order>();
            using (TextReader textReader = new StreamReader(dataDirectory + "/orders.txt"))
            {
                var csvReader = new CsvReader(textReader);
                orders = csvReader.GetRecords<Order>().ToList();
            }

            var orderSaved = orders.SingleOrDefault(x => x.Id == order.Id);
            if (orderSaved != null)
                throw new Exception("Primary Constraint Exception: another object already exists with same Id");
            orders.Add(order);

            using (TextWriter textWriter = new StreamWriter(dataDirectory + "/orders.txt"))
            {
                var csvWriter = new CsvWriter(textWriter);
                csvWriter.WriteRecords(orders);
            }
        }

        public Order GetOrder(int id)
        {
            TextReader textReader = File.OpenText(dataDirectory + "/orders.txt");
            var csv = new CsvReader(textReader);
            var orders = csv.GetRecords<Order>();
            return orders.SingleOrDefault(x => x.Id == id);
        }
    }
}