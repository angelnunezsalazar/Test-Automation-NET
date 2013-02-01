namespace ClassLibrary
{
    public class OrderServices
    {
        private IDataAccess dataAccess;

        public OrderServices(IDataAccess dataAccess)
        {
            this.dataAccess = dataAccess;
        }

        public decimal CalculateTotal(Order order)
        {
            decimal itemTotal = order.ItemTotal;
            decimal discountPercentage = 0;

            if (!string.IsNullOrEmpty(order.CouponCode))
            {
                discountPercentage = this.dataAccess.GetPromotionalDiscount(order.CouponCode);
            }

            return itemTotal - itemTotal * discountPercentage / 100;
        }

        public Order GetOrder(int id)
        {
            return dataAccess.GetOrder(id);
        }

        public void Save(Order order)
        {
            if (IsValid(order))
            {
                dataAccess.SaveOrder(order);
            }
        }

        private bool IsValid(Order order)
        {
            return order.Id > 0 && order.ItemTotal > 0 && order.Total > 0;
        }
    }
}
