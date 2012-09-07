namespace ClassLibrary
{
    public interface IDataAccess
    {
        Order GetOrder(int id);
        decimal GetShippingCosts(Order order);
        void SaveOrder(Order order);
    }
}
