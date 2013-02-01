namespace ClassLibrary
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;

    public interface IDataAccess
    {
        int GetPromotionalDiscount(string coupon);

        void SaveOrder(Order order);

        Order GetOrder(int id);
    }

    public class DataAccess : IDataAccess
    {
        public int GetPromotionalDiscount(string coupon)
        {
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DB"].ConnectionString))
            {
                var command = new SqlCommand("select discount from CouponDiscount where coupon=@Coupon", conn);
                command.Parameters.AddWithValue("Coupon", coupon);
                conn.Open();

                object value = command.ExecuteScalar();

                if (value == null)
                    throw new Exception("No shipping cost found");
                return (int)value;
            }
        }

        public void SaveOrder(Order order)
        {
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DB"].ConnectionString))
            {
                var command = new SqlCommand("insert into 'Order' values(@Id, @CouponCode, @ItemTotal, @Total)", conn);
                command.Parameters.AddWithValue("Id", order.Id);
                command.Parameters.AddWithValue("CouponCode", order.CouponCode);
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
                var command = new SqlCommand("select Id, CouponCode, ItemTotal, Total from 'Order' where Id=@Id", conn);
                command.Parameters.AddWithValue("Id", id);
                conn.Open();

                var reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    return new Order
                        {
                            Id = (int)reader.GetValue(0),
                            CouponCode = (string)reader.GetValue(1),
                            ItemTotal = (decimal)reader.GetValue(2),
                            Total = (decimal)reader.GetValue(3)
                        };
                }
                return null;
            }
        }
    }
}