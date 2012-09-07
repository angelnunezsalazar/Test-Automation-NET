namespace DataAccessNH
{
    using FluentNHibernate.Cfg;
    using FluentNHibernate.Cfg.Db;
    using FluentNHibernate.Automapping;

    using NHibernate;

    public class SessionFactory
    {
        private static readonly object Sync = new object();

        private static ISessionFactory sessionFactory;
        private static bool factoryBuilded;

        public static ISessionFactory Create()
        {
            lock (Sync)
            {
                if (!factoryBuilded)
                {
                    var databaseConfiguration = SQLiteConfiguration.Standard
                                                            .ShowSql()
                                                            .ConnectionString(c => c.FromConnectionStringWithKey("DB"));

                    var entities = AutoMap.AssemblyOf<Employee>()
                                          .Where(x => x.Namespace == "ClassLibrary");

                    sessionFactory = Fluently.Configure()
                                             .ExposeConfiguration(c =>
                                             {
                                                 c.Properties.Add("current_session_context_class", "thread_static");
                                                 //c.Properties.Add("hbm2ddl.auto", "create");
                                             })
                                             .Database(databaseConfiguration)
                                             .Mappings(x => x.AutoMappings.Add(entities))
                                             .BuildSessionFactory();
                    factoryBuilded = true;
                }
            }
            return sessionFactory;
        }
    }
}