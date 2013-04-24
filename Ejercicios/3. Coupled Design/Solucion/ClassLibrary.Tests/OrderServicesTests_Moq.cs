namespace ClassLibrary.Tests
{
    using System;

    using ClassLibrary;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using Moq;

    [TestClass]
    public class OrderServicesTests_Moq
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
            var dataAccess = new Mock<IDataAccess>();
            dataAccess.Setup(x => x.GetPromotionalDiscount(order.CouponCode)).Returns(10);
            OrderServices orderServices = new OrderServices(dataAccess.Object);

            var total = orderServices.CalculateTotal(order);

            Assert.AreEqual(90, total);
        }

        [TestMethod]
        public void Save_ValidOrder_TheOrderIsPersisted()
        {
            Order order = new Order { Id = 1, ItemTotal = 100, Total = 110 };
            var dataAccess = new Mock<IDataAccess>();
            OrderServices orderProcessor = new OrderServices(dataAccess.Object);

            orderProcessor.Save(order);

            dataAccess.Verify(x => x.SaveOrder(order));
        }

        public class SimpleDataAccess : IDataAccess
        {
            public int CouponPercentage;
            public int GetPromotionalDiscount(string coupon)
            {
                return CouponPercentage;
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
