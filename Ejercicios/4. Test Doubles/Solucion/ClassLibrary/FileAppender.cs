using System.IO;

namespace ClassLibrary
{
    public interface IAppender
    {
        void Write(string message);
    }

    public class FileAppender : IAppender
    {
        public void Write(string message)
        {
            StreamWriter fileWrite = new StreamWriter("log.txt", true);
            fileWrite.WriteLine(message);
            fileWrite.Close();
        }
    }
}