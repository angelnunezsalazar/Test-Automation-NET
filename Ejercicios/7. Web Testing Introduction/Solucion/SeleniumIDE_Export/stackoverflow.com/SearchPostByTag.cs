using NUnit.Framework;
using NUnit.Core;

namespace SeleniumTests
{
    public class SearchPostByTag
    {
        [Suite] public static TestSuite Suite
        {
            get
            {
                TestSuite suite = new TestSuite("SearchPostByTag");
                suite.Add(new SearchResultHasTheCorrectTag());
                suite.Add(new ReleatedTags());
                return suite;
            }
        }
    }
}
