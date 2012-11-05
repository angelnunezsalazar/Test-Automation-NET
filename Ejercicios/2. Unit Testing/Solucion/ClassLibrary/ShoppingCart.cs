namespace ClassLibrary
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class ShoppingCart
    {
        private readonly List<ShoppingCartItem> items;

        public ShoppingCart()
        {
            this.items = new List<ShoppingCartItem>();
        }

        public decimal TaxAmount { get; set; }

        public int TotalItems
        {
            get
            {
                return this.items.Count;
            }
        }

        public int TotalProducts
        {
            get
            {
                return this.items.Sum(x => x.Quantity);
            }
        }

        public decimal SubTotal
        {
            get
            {
                return this.items.Sum(x => x.LineTotal);
            }
        }

        public decimal Total
        {
            get
            {
                return SubTotal + TaxAmount;
            }
        }

        public void AddItem(Product product, int quantity)
        {
            var item = this.FindItem(product.SKU);
            if (item != null)
            {
                if (quantity == 0)
                    this.items.Remove(item);
                else
                    item.AdjustQuantity(quantity);
            }
            else
            {
                if (quantity > 0)
                {
                    item = new ShoppingCartItem(product, quantity);
                    this.items.Add(item);
                }
            }
        }

        public void RemoveItem(string sku)
        {
            var itemToRemove = FindItem(sku);
            if (itemToRemove == null)
                throw new Exception("Product does not exist");
            this.items.Remove(itemToRemove);
        }

        public void ClearItems()
        {
            this.items.Clear();
        }

        public ShoppingCartItem FindItem(string sku)
        {
            return (from items in this.items
                    where items.Product.SKU == sku
                    select items).SingleOrDefault();
        }
    }
}