namespace ClassLibrary
{
    public class ShoppingCartItem
    {
        public int Quantity { get; private set; }

        public Product Product { get; private set; }

        public decimal LineTotal
        {
            get
            {
                return Product.Price * Quantity;
            }
        }

        public ShoppingCartItem(Product product, int quantity)
        {
            this.Product = product;
            this.Quantity = quantity;
        }

        public void AdjustQuantity(int newQuantity)
        {
            this.Quantity = newQuantity;
        }
    }
}