namespace ClassLibrary.Tests
{
    using ClassLibrary;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using Moq;

    [TestClass]
    public class OrderServicesTests
    {
        [TestMethod]
        public void CalculateTotal_OrderFromUS_FreeShipping()
        {
            Order order = new Order { Country = "US", ItemTotal = 100 };
            OrderServices orderServices = new OrderServices(new DataAccess());

            var total = orderServices.CalculateTotal(order);

            Assert.AreEqual(100, total);
        }

        [TestMethod]
        public void CalculateTotal_OrderOutsideUS_ShippingCostIsAdded()
        {
            Order order = new Order { Country = "PER", ItemTotal = 100 };
            var dataAccess = new Mock<IDataAccess>();
            dataAccess.Setup(x => x.GetShippingCosts(order)).Returns(10);
            OrderServices orderServices = new OrderServices(dataAccess.Object);

            var total = orderServices.CalculateTotal(order);

            Assert.AreEqual(110, total);
        }

        [TestMethod]
        public void Save_ValidOrder_TheOrderIsPersisted()
        {
            Order order = new Order { Id = 1, Country = "PER", ItemTotal = 100, Total = 110 };
            var dataAccess = new Mock<IDataAccess>();
            OrderServices orderProcessor = new OrderServices(dataAccess.Object);

            orderProcessor.Save(order);

            dataAccess.Verify(x => x.SaveOrder(order));
        }
    }
}
