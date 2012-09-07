namespace ClassLibrary.Tests
{
    using System;

    using ClassLibrary;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OrderServicesTests_ManualTestDoubles
    {
        [TestMethod]
        public void CalculateTotal_OrderFromUS_FreeShipping()
        {
            OrderServices orderServices = new OrderServices(null);
            Order order = new Order { Country = "US", ItemTotal = 100 };

            var total = orderServices.CalculateTotal(order);

            Assert.AreEqual(100, total);
        }

        [TestMethod]
        public void CalculateTotal_OrderOutsideUS_ShippingCostIsAdded()
        {
            Order order = new Order { Country = "PER", ItemTotal = 100 };
            var dataAccess = new SimpleDataAccess();
            dataAccess.ShippingCosts = 10;
            OrderServices orderServices = new OrderServices(dataAccess);

            var total = orderServices.CalculateTotal(order);

            Assert.AreEqual(110, total);
        }

        [TestMethod]
        public void Save_ValidOrder_TheOrderIsPersisted()
        {
            Order order = new Order { Id = 1, Country = "PER", ItemTotal = 100, Total = 110 };
            var dataAccess = new SimpleDataAccess();
            OrderServices orderProcessor = new OrderServices(dataAccess);

            orderProcessor.Save(order);

            Assert.AreEqual(order,dataAccess.OrderSaved);
        }

        private class SimpleDataAccess : IDataAccess
        {
            public decimal ShippingCosts;
            public decimal GetShippingCosts(Order order)
            {
                return this.ShippingCosts;
            }

            public Order GetOrder(int id)
            {
                throw new NotImplementedException();
            }

            public Order OrderSaved;
            public void SaveOrder(Order order)
            {
                OrderSaved = order;
            }
        }
    }
}
