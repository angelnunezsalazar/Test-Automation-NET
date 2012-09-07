USE AutomateTesting
GO

EXEC tSQLt.NewTestClass 'EmployeeFind';
GO

IF OBJECT_ID(N'[EmployeeFind].[SetUp]', 'P') > 0
	DROP PROCEDURE EmployeeFind.[SetUp];
GO

CREATE PROCEDURE EmployeeFind.SetUp
AS
BEGIN
	EXEC tSQLt.FakeTable 'Employee'
	
    INSERT INTO [dbo].[Employee](LastName,HireDate) VALUES('Perez','2010-12-30')
    INSERT INTO [dbo].[Employee](LastName,HireDate) VALUES('Garcia','2010-12-29')
    INSERT INTO [dbo].[Employee](LastName,HireDate) VALUES('Tovar','2010-12-28')

    CREATE TABLE EmployeeFind.Expected (
		Id			int,
		FirstName	nvarchar(max),
        LastName	nvarchar(max),
        HireDate	DateTime
    ); 

    CREATE TABLE EmployeeFind.Actual (
		Id			int,
		FirstName	nvarchar(max),
        LastName	nvarchar(max),
        HireDate	DateTime
    ); 
END
GO

IF OBJECT_ID(N'[EmployeeFind].[Test WithLastNameFilter ReturnTheEmployeesWithTheExactLastName]', 'P') > 0
	DROP PROCEDURE EmployeeFind.[Test WithLastNameFilter ReturnTheEmployeesWithTheExactLastName];
GO

CREATE PROCEDURE EmployeeFind.[Test WithLastNameFilter ReturnTheEmployeesWithTheExactLastName]
AS
BEGIN
	-- ARRANGE
    INSERT INTO EmployeeFind.Expected(LastName,HireDate) VALUES('Perez','2010-12-30')
    
    -- ACT
    INSERT INTO EmployeeFind.Actual
    EXEC EmployeeFind 'Perez',null,null
    
    -- ASSERT
    EXEC tSQLt.AssertEqualsTable 'EmployeeFind.Expected', 'EmployeeFind.Actual';
END   
GO

IF OBJECT_ID(N'[EmployeeFind].[Test WithHireDateFilters ReturnTheEmployeesBetweenHireDates]', 'P') > 0
	DROP PROCEDURE EmployeeFind.[Test WithHireDateFilters ReturnTheEmployeesBetweenHireDates];
GO

CREATE PROCEDURE EmployeeFind.[Test WithHireDateFilters ReturnTheEmployeesBetweenHireDates]
AS
BEGIN
    INSERT INTO EmployeeFind.Expected(LastName,HireDate) VALUES('Garcia','2010-12-29')
    INSERT INTO EmployeeFind.Expected(LastName,HireDate) VALUES('Perez','2010-12-30')
    
    INSERT INTO EmployeeFind.Actual
    EXEC EmployeeFind null,'2010-12-29','2010-12-30'
    
    EXEC tSQLt.AssertEqualsTable 'EmployeeFind.Expected', 'EmployeeFind.Actual';
END   
GO

EXEC tSQLt.NewTestClass 'EmployeeCreate';
GO

IF OBJECT_ID(N'[EmployeeCreate].[Test WithExplicitHireDate TheEmployeeHasTheExplicitTheHireDate]', 'P') > 0
	DROP PROCEDURE EmployeeCreate.[Test WithExplicitHireDate TheEmployeeHasTheExplicitTheHireDate];
GO

CREATE PROCEDURE EmployeeCreate.[Test WithExplicitHireDate TheEmployeeHasTheExplicitTheHireDate]
AS
BEGIN
	-- ARRANGE
	EXEC tSQLt.FakeTable 'Employee'
	
	-- Store Expected Values
	SELECT 'Juan'		as FirstName
		  ,'Marquez'	as LastName
		  ,'2010-12-31'	as HireDate
	INTO #Expected
	
    -- ACT
    EXEC EmployeeCreate 'Juan','Marquez','2010-12-31'
    
    -- Collect Actual Data
    SELECT FirstName,LastName,HireDate 
    INTO #Actual
    FROM Employee 
    
    EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual';
END   
GO

IF OBJECT_ID(N'[EmployeeCreate].[Test WithoutHireDate TheEmployeeHasTheCurrentHireDate]', 'P') > 0
	DROP PROCEDURE EmployeeCreate.[Test WithoutHireDate TheEmployeeHasTheCurrentHireDate];
GO

CREATE PROCEDURE EmployeeCreate.[Test WithoutHireDate TheEmployeeHasTheCurrentHireDate]
AS
BEGIN
	EXEC tSQLt.FakeTable 'Employee'
	
    EXEC EmployeeCreate 'Juan','Marquez',null
    DECLARE @HireDate DateTime=(SELECT TOP 1 HireDate FROM Employee);
    
    IF @HireDate IS NULL
		EXEC tSQLt.Fail 'Expected: NOT NULL but was: NULL'
END   
GO

--EXEC tSQLt.RunAll
 