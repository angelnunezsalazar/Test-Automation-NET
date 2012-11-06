namespace ClassLibrary
{
    using System;
    using System.Configuration;
    using System.Data.Sql;

    public class DataAccess
    {
        public decimal GetShippingCosts(Order order)
        {
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DB"].ConnectionString))
            {
                var command = new SqlCommand("select Cost from Shipping where Country=@Country", conn);
                command.Parameters.AddWithValue("Country", order.Country);
                conn.Open();

                object value = command.ExecuteScalar();

                if (value == null)
                    throw new Exception("No shipping cost found");
                return (decimal)value;
            }
        }

        public void SaveOrder(Order order)
        {
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DB"].ConnectionString))
            {
                var command = new SqlCommand("insert into 'Order' values(@Id, @Country, @ItemTotal, @Total)", conn);
                command.Parameters.AddWithValue("Id", order.Id);
                command.Parameters.AddWithValue("Country", order.Country);
                command.Parameters.AddWithValue("ItemTotal", order.ItemTotal);
                command.Parameters.AddWithValue("Total", order.Total);
                conn.Open();

                int rowsAffected = command.ExecuteNonQuery();
                if (rowsAffected == 0)
                    throw new Exception("Order not saved");
            }
        }

        public Order GetOrder(int id)
        {
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DB"].ConnectionString))
            {
                var command = new SqlCommand("select Id, Country, ItemTotal, Total from 'Order' where Id=@Id", conn);
                command.Parameters.AddWithValue("Id", id);
                conn.Open();

                var reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    return new Order
                        {
                            Id = (int)reader.GetValue(0),
                            Country = (string)reader.GetValue(1),
                            ItemTotal = (decimal)reader.GetValue(2),
                            Total   =(decimal)reader.GetValue(3)
                        };
                }
                return null;
            }
        }
    }
}