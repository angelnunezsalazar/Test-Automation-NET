namespace ClassLibrary.Tests
{
    using System;

    using ClassLibrary;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OrderServicesTests_WithoutTestDoubles
    {
        [TestMethod]
        public void CalculateTotal_WithoutCoupon_ReturnLineItemTotal()
        {
            Order order = new Order { ItemTotal = 100 };
            OrderServices orderServices = new OrderServices(new DataAccess());

            var total = orderServices.CalculateTotal(order);

            Assert.AreEqual(100, total);
        }

        [TestMethod]
        public void CalculateTotal_WithCoupon_ReturnLineItemWithDiscount()
        {
            Order order = new Order { CouponCode = "HAPPY", ItemTotal = 100 };
            OrderServices orderServices = new OrderServices(new DataAccess());

            var total = orderServices.CalculateTotal(order);

            Assert.AreEqual(90, total);
        }

        [TestMethod]
        public void Save_ValidOrder_TheOrderIsPersisted()
        {
            Order order = new Order { Id = 1, ItemTotal = 100, Total = 110 };
            OrderServices orderProcessor = new OrderServices(new DataAccess());

            orderProcessor.Save(order);

            Order orderFromDb = orderProcessor.GetOrder(order.Id);
            Assert.IsNotNull(orderFromDb);
        }
    }

}
