namespace TestDoubles
{
    using System.IO;
    using System.Net;
    // ReSharper disable AssignNullToNotNullAttribute
    // ReSharper disable NotAccessedField.Local

    public class HtmlDocument
    {
        private string html;

        public HtmlDocument(string url)
        {
            var request = WebRequest.Create(url);
            var response = request.GetResponse();
            var streamReceive = response.GetResponseStream();
            var streamRead = new StreamReader(streamReceive);
            this.html = streamRead.ReadToEnd();
        }
    }

    // ReSharper restore AssignNullToNotNullAttribute
    // ReSharper restore NotAccessedField.Local


    
}