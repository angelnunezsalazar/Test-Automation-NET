namespace Bakery.UITests.Infraestructure
{
    using Bakery.Web.Database;

    public class DataFactory
    {
        public static T Load<T>(T obj) where T : class
        {
            var context = new AppDbContext();
            context.Set<T>().Add(obj);
            context.SaveChanges();
            return obj;
        }
    }
}