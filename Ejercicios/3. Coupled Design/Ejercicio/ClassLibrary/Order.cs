namespace ClassLibrary
{
    public class Order
    {
        public int Id { get; set; }

        public decimal ItemTotal { get; set; }

        public decimal Total { get; set; }

        public string Coupon { get; set; }
    }
}