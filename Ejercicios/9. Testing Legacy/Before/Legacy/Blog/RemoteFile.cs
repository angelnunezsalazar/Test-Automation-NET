using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Legacy.Blog
{
    public class RemoteFile
    {
        private Uri url;
        private bool p;

        public RemoteFile(Uri url, bool p)
        {
            this.url = url;
            this.p = p;
        }

        public string GetFileAsString()
        {
            throw new NotImplementedException();
        }
    }
}
