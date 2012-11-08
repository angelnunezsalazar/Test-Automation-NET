namespace Bakery.UITests.Infraestructure
{
    using Bakery.Web.Database;

    public class Database
    {
        public static T LoadData<T>(T obj) where T : class
        {
            var context = new AppDbContext();
            context.Set<T>().Add(obj);
            context.SaveChanges();
            return obj;
        }

        public static void CleanTable(string table)
        {
            var context = new AppDbContext();
            context.Database.ExecuteSqlCommand(string.Format("Delete from {0}", table));
        }
    }
}