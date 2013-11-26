namespace ClassLibrary.Tests
{
    using ClassLibrary;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OrderServicesTests
    {
        [TestMethod]
        public void MyTestMethod()
        {
            var orderService = new OrderServices();
            var order = new Order();
            order.CouponCode = "CHRISTMAS";
            orderService.CalculateTotal(order);

        }
    }
}
