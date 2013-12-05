namespace Bakery.Web.Models
{
    public class Order:Entity
    {
        public string Email { get; set; }

        public string Address { get; set; }

        public int Quantity { get; set; }

        public int ProductId { get; set; }
    }
}