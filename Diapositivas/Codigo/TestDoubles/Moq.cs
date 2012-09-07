namespace TestDoubles
{
    using System;
    using System.Collections.Generic;

    using global::Moq;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class Moq
    {
        [TestMethod]
        public void MoqAPI()
        {
            var mock = new Mock<IFoo>()   ;

            mock.Setup(foo => foo.GetSomething("param")).Returns(true)  ;

            mock.Setup(foo => foo.GetSomething(It.IsAny<string>())).Returns(true)   ;

            mock.Setup(foo => foo.DoSomething()).Throws(new Exception())    ;

            mock.Verify(foo => foo.Execute())                           ;
            mock.Verify(foo => foo.Execute(),Times.Exactly(2))              ;
        }
    }

    public interface IFoo
    {
        object GetSomething(string p);

        void Execute();

        object DoSomething();
    }
}