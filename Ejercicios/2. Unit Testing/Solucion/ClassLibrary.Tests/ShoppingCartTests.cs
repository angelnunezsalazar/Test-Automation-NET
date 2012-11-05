namespace ClassLibrary.Tests
{
    using System;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ShoppingCartTests
    {
        private ShoppingCart cart;

        [TestInitialize]
        public void Setup()
        {
            cart = new ShoppingCart();
        }

        [TestMethod]
        //AddItem_2DifferentItems_2ItemsAdded
        public void AddsItemsToTheCart()
        {
            this.cart.AddItem(new Product("SKU1"), 1);
            this.cart.AddItem(new Product("SKU2"), 1);

            Assert.AreEqual(2, cart.TotalItems);
        }

        [TestMethod]
        //AddItem_NewProductAndZeroQuantity_NothingAdded
        public void DoesntAddAnItemWhenQuantityZero()
        {
            this.cart.AddItem(new Product("SKU"), 0);

            Assert.AreEqual(0, cart.TotalItems);
        }

        [TestMethod]
        //AddItem_2SameProducts_1ProductAddedWithQuantityAdjusted()
        public void AdjustsTheItemQuantityWhenAddingAnItemThatAlreadyExists()
        {
            this.cart.AddItem(new Product("SKU"), 1);
            this.cart.AddItem(new Product("SKU"), 2);

            Assert.AreEqual(2, cart.TotalProducts);
        }

        [TestMethod]
        //AddItem_ProductAlreadyAddedAndZeroQuantity_ProductRemoved
        public void RemovesAnItemWhenAddingAndItemWithQuantityZero()
        {
            this.cart.AddItem(new Product("SKU"), 1);
            this.cart.AddItem(new Product("SKU"), 0);

            Assert.AreEqual(0, cart.TotalItems);
        }

        [TestMethod]
        public void AddItem_2DifferentItemsWith2ProductsEach_4ProductsAdded()
        {
            this.cart.AddItem(new Product("SKU1"), 2);
            this.cart.AddItem(new Product("SKU2"), 2);

            Assert.AreEqual(4, cart.TotalProducts);
        }

        [TestMethod]
        public void FindItem_ItemExits_ReturnsItem()
        {
            this.cart.AddItem(new Product("SKU"), 1);

            var item = cart.FindItem("SKU");

            Assert.IsNotNull(item);
        }

        [TestMethod]
        public void FindItem_ItemDoesNotExit_ReturnsNull()
        {
            this.cart.AddItem(new Product("SKU"), 1);

            var item = cart.FindItem("SKU1");

            Assert.IsNull(item);
        }

        [TestMethod]
        public void RemoveItem_1ProductAdded_CartEmpty()
        {
            this.cart.AddItem(new Product("SKU"), 1);

            cart.RemoveItem("SKU");

            Assert.AreEqual(0, cart.TotalItems);
        }

        [TestMethod]
        public void ClearItems_RemovesAllItems()
        {
            this.cart.AddItem(new Product("SKU"), 1);
            this.cart.AddItem(new Product("SKU2"), 1);

            cart.ClearItems();

            Assert.AreEqual(0, cart.TotalItems);
        }

        [TestMethod]
        public void SubTotal_2ItemsOfPrice10_Returns20()
        {
            var product1 = new Product("SKU");
            product1.Price = 10;
            cart.AddItem(product1, 1);
            var product2 = new Product("SKU2");
            product2.Price = 10;
            cart.AddItem(product2, 1);

            Assert.AreEqual(20, cart.SubTotal);
        }

        [TestMethod]
        public void Total_SubTotal90AndTax10_Returns100()
        {
            var product = new Product("SKU");
            product.Price = 90;
            cart.AddItem(product, 1);

            cart.TaxAmount = 10;

            Assert.AreEqual(100, cart.Total);
        }

        [TestMethod]
        [ExpectedException(typeof(Exception))]
        public void RemoveItem_ItemDoesNoExist_ThrowsException()
        {
            this.cart.RemoveItem("SKU");
        }

    }
}