using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Legacy.Blog
{
    public class TrackbackMessage
    {
        private IPublishable item;
        private Uri trackbackUrl;
        private Uri itemUrl;

        public TrackbackMessage(IPublishable item, Uri trackbackUrl, Uri itemUrl)
        {
            this.item = item;
            this.trackbackUrl = trackbackUrl;
            this.itemUrl = itemUrl;
        }
    }
}
