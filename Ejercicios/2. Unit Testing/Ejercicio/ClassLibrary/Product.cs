namespace ClassLibrary
{
    public class Product
    {

        public Product(string SKU)
        {
            this.SKU = SKU;
        }

        public string SKU { get; set; }

        public decimal Price { get; set; }
    }
}