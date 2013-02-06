namespace TiendaVirtual.Web.Pagination
{
    using System.Linq;

    public static class Extensions
    {
        public static PagedList<T> ToPagedList<T>(this IQueryable<T> source, int currentPage, int pageSize)
        {
            var items = source.Skip((currentPage - 1) * pageSize).Take(pageSize).ToList();
            var totalItems = source.Count();
            return new PagedList<T>(items, totalItems, currentPage, pageSize);
        }
    }
}