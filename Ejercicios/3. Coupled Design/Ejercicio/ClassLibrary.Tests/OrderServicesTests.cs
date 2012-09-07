namespace ClassLibrary.Tests
{
    using ClassLibrary;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OrderServicesTests
    {
        [TestMethod]
        public void CalculateTotal_OrderFromUS_FreeShipping()
        {
			Order order = new Order { Country = "US", ItemTotal = 100 };
            OrderServices orderServices = new OrderServices();

            var total = orderServices.CalculateTotal(order);

            Assert.AreEqual(100, total);
        }

        [TestMethod]
        public void CalculateTotal_OrderOutsideUS_ShippingCostIsAdded()
        {
			Order order = new Order { Country = "PER", ItemTotal = 100 };
            OrderServices orderServices = new OrderServices();

            var total = orderServices.CalculateTotal(order);

            Assert.AreEqual(110, total);
        }

        [TestMethod]
        public void Save_ValidOrder_TheOrderIsPersisted()
        {
			Order order = new Order { Id = 1, Country = "PER", ItemTotal = 100, Total = 110 };
            OrderServices orderProcessor = new OrderServices();

            orderProcessor.Save(order);

            Order orderFromDb = orderProcessor.GetOrder(order.Id);
            Assert.IsNotNull(orderFromDb);
        }
    }
}
