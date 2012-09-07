namespace TestDoubles
{
    public class AvoidStaticMethods
    {
         public void UpdateCustomer(int id)
         {
             var customer = CustomerDataAccess.Get(id);
             customer.Name = "New Name";
             CustomerDataAccess.Save(customer);
         }
    }

    public class CustomerDataAccess
    {
        public static Customer Get(int id)
        {
            throw new System.NotImplementedException();
        }

        public static void Save(Customer customer)
        {
            throw new System.NotImplementedException();
        }
    }

    public class Customer
    {
        public string Name
        {
            get
            {
                throw new System.NotImplementedException();
            }
            set
            {
                throw new System.NotImplementedException();
            }
        }
    }
}