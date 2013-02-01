namespace TiendaVirtual.Web.Pagination
{
    public interface IPagedList
    {
        int TotalItems { get; set; }

        int ItemsPerPage { get; set; }

        int CurrentPage { get; set; }

        int TotalPages { get; }

        bool HasPreviousPage { get; }

        bool HasNextPage { get; }
    }

}