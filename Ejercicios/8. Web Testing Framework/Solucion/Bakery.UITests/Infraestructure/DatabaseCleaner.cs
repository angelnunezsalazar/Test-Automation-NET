namespace Bakery.UITests.Infraestructure
{
    using Bakery.Web.Database;

    public class DatabaseCleaner
    {
         public static void Clean(string table)
         {
             var context = new AppDbContext();
             context.Database.ExecuteSqlCommand(string.Format("Delete from {0}",table));
         }
    }
}