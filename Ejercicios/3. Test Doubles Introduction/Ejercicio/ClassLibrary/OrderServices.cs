using System;
namespace ClassLibrary
{
    public class OrderServices
    {
        private DataAccess dataAccess;

        public OrderServices()
        {
            dataAccess = new DataAccess();
        }

        public decimal CalculateTotal(Order order)
        {
            decimal itemTotal = order.ItemTotal;
            decimal discountPercentage = 0;

            if (!string.IsNullOrEmpty(order.Coupon))
            {
                discountPercentage = this.dataAccess.GetPromotionalDiscount(order.Coupon);
            }
            return itemTotal - itemTotal * discountPercentage / 100;
        }

        public Order GetOrder(int id)
        {
            return dataAccess.GetOrder(id);
        }

        public void Save(Order order)
        {
            if (!IsValid(order))
                throw new Exception("Invalid Order");
            dataAccess.SaveOrder(order);
        }

        private bool IsValid(Order order)
        {
            return order.Id > 0 && order.ItemTotal > 0 && order.Total > 0;
        }
    }
}
