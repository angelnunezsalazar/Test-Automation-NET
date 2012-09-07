ALTER TABLE [dbo].[Employee]
	ADD CONSTRAINT [FK_Employee_Department] 
	FOREIGN KEY (DepartmentId)
	REFERENCES [dbo].Department (Id)
