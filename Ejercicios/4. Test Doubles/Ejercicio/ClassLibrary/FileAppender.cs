using System.IO;

namespace ClassLibrary
{
    public class FileAppender
    {
        public void Write(string message)
        {
            StreamWriter fileWrite = new StreamWriter("log.txt", true);
            fileWrite.WriteLine(message);
            fileWrite.Close();
        }
    }
}