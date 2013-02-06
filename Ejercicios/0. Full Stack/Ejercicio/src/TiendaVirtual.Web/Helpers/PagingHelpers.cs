namespace TiendaVirtual.Web.Helpers
{
    using System;
    using System.Text;
    using System.Web.Mvc;

    using TiendaVirtual.Web.Pagination;

    public static class PagingHelpers
    {
        public static MvcHtmlString PageLinks(this HtmlHelper html,
                                              IPagedList pagedList,
                                              Func<int, string> pageUrl)
        {
            StringBuilder liHtml = new StringBuilder();
            
            if (pagedList.HasPreviousPage)
            {
                TagBuilder liTag = CreatePageLinkTag(pageUrl, pagedList.CurrentPage - 1, "&lt;&lt;Anterior");
                liHtml.AppendLine(liTag.ToString());
            }
 
 
            for (int i = 1; i <= pagedList.TotalPages; i++)
            {
                TagBuilder liTag = CreatePageLinkTag(pageUrl, i, i.ToString());
                if (pagedList.CurrentPage==i)
                {
                    liTag=new TagBuilder("li");
                    liTag.AddCssClass("active");
                    liTag.InnerHtml = i.ToString();
                }
 
                liHtml.AppendLine(liTag.ToString());
            }
 
            if (pagedList.HasNextPage)
            {
                TagBuilder liTag = CreatePageLinkTag(pageUrl, pagedList.CurrentPage + 1, "Siguiente&gt;&gt;");
                liHtml.AppendLine(liTag.ToString());
            }
 
            TagBuilder ul = new TagBuilder("ul");
            ul.InnerHtml = liHtml.ToString();
 
            return MvcHtmlString.Create(ul.ToString());
        }
 
        private static TagBuilder CreatePageLinkTag(Func<int, string> pageUrl, int pageNumber, string tagText)
        {
            TagBuilder aTag=new TagBuilder("a");
            aTag.MergeAttribute("href", pageUrl(pageNumber));
            aTag.InnerHtml = tagText;
            TagBuilder liTag=new TagBuilder("li");
            liTag.InnerHtml = aTag.ToString();
            return liTag;
        }
 
    }
}