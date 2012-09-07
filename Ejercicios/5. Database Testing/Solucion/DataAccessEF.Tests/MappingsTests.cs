namespace DataAccessEF.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Reflection;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class MappingsTests
    {
        [TestMethod]
        public void Mappings()
        {
            MethodInfo method = typeof(DbSet<>).GetMethod("ToList");
            var context = new AppDbContext();
            foreach (var type in this.GetAllEntityTypes())
            {
                //MethodInfo genericMethod = method.MakeGenericMethod(new[] { type });
                //genericMethod.Invoke(null, null);
                ////dbSet.Take(0).ToList();
                ////var dbSet = context.Set(type) as dynamic;
                ////dbSet.ToList();
                context.Employees.Take(0).ToList();
            }

        }

        private IEnumerable<Type> GetAllEntityTypes()
        {
            return from p in typeof(AppDbContext).GetProperties()
                       where p.PropertyType.IsGenericType
                             && p.PropertyType.GetGenericTypeDefinition() == typeof(IDbSet<>)
                       select p.PropertyType.GetGenericArguments().First();
        }
    }
}