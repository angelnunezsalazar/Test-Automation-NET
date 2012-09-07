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
            decimal shippingCosts = 0;

            if (order.Country != "US")
            {
                shippingCosts = this.dataAccess.GetShippingCosts(order);
            }

            return itemTotal + shippingCosts;
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
            return order.Id > 0 && order.Country != null && order.ItemTotal > 0 && order.Total > 0;
        }
    }
}
