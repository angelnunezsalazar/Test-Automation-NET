CREATE PROCEDURE [dbo].[uspCreateEmployee]
	@FirstName nvarchar(100), 
	@LastName nvarchar(100),
	@HireDate DateTime
AS
BEGIN
	INSERT INTO [dbo].[Employee]
           ([FirstName]
           ,[LastName]
           ,[HireDate])
     VALUES
           (@FirstName
           ,@LastName
           ,@HireDate);
END
