namespace DataAccessADO
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;

    public class EmployeeADOTests_Self_Transaction
    {
        public List<Employee> Find(String lastName, DateTime? startHireDate, DateTime? endHireDate)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["DB"].ConnectionString))
            {
                var query = "select Id, FirstName, LastName, HireDate from Employee";

                using (var command = new SqlCommand("", connection))
                {
                    String filters = "";
                    if (lastName != null)
                    {
                        filters += " where LastName=@LastName";
                        command.Parameters.AddWithValue("LastName", lastName);
                    }
                    if (startHireDate != null && endHireDate != null)
                    {
                        filters += filters == "" ? " where " : " and ";
                        filters += "HireDate between @StartHireDate and @EndHireDate";
                        command.Parameters.AddWithValue("StartHireDate", startHireDate.Value);
                        command.Parameters.AddWithValue("EndHireDate", endHireDate.Value);
                    }

                    command.CommandText = query + filters;
                    connection.Open();
                    var reader = command.ExecuteReader();
                    List<Employee> employees = new List<Employee>();
                    while (reader.Read())
                    {
                        Employee employee = new Employee
                        {
                            Id = reader.GetInt32(0),
                            FirstName = reader.GetValue(1) as string,
                            LastName = reader.GetValue(2) as string,
                            HireDate = reader.GetValue(3) as DateTime?
                        };
                        employees.Add(employee);
                    }
                    return employees;
                }
            }
        }

        public Employee Get(int id)
        {
            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["DB"].ConnectionString))
            {
                var sql = "select Id, FirstName, LastName, HireDate from Employee where Id=@Id";
                using (var command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("Id", id);
                    connection.Open();

                    using (var reader = command.ExecuteReader())
                    {
                        Employee employee = null;
                        if (reader.Read())
                        {
                            employee = new Employee
                            {
                                Id = reader.GetInt32(0),
                                FirstName = reader.GetValue(1) as string,
                                LastName = reader.GetValue(2) as string,
                                HireDate = reader.GetValue(3) as DateTime?
                            };
                        }
                        return employee;
                    }
                }
            }
        }

        public void Create(Employee employee)
        {
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DB"].ConnectionString))
            {
                var sql = @"insert into Employee(FirstName,LastName,HireDate) values(@FirstName,@LastName,@HireDate);
                            ;select SCOPE_IDENTITY() ";
                using (var command = new SqlCommand(sql, conn))
                {
                    command.Parameters.AddWithValue("FirstName", employee.FirstName);
                    command.Parameters.AddWithValue("LastName", employee.LastName);
                    command.Parameters.AddWithValue("HireDate", employee.HireDate);
                    conn.Open();

                    int id = Convert.ToInt32(command.ExecuteScalar());
                    employee.Id = id;
                }
            }
        }

        public void Delete(int id)
        {
            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DB"].ConnectionString))
            {
                var sql = @"delete from Employee where Id=@Id";
                using (var command = new SqlCommand(sql, conn))
                {
                    command.Parameters.AddWithValue("Id", id);
                    conn.Open();

                    int rowsAffected = command.ExecuteNonQuery();
                    if (rowsAffected == 0)
                        throw new Exception("Employee not deleted");
                }
            }
        }
    }
}