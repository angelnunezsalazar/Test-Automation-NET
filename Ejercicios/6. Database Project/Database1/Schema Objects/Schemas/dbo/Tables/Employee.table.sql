CREATE TABLE [dbo].[Employee] (
	[Id]			INT            IDENTITY (1, 1) NOT NULL,
	[FirstName]		NVARCHAR (MAX) NULL,
	[LastName]		NVARCHAR (MAX) NULL,
	[HireDate]		DATETIME       NULL,	
	[DepartmentId]	INT			   NULL
);

