/*
   Copyright 2011 tSQLt

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
USE tempdb;

IF(db_id('tSQLt_Example') IS NOT NULL)
EXEC('
ALTER DATABASE tSQLt_Example SET RESTRICTED_USER WITH ROLLBACK IMMEDIATE;
USE tSQLt_Example;
ALTER DATABASE tSQLt_Example SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
USE tempdb;
DROP DATABASE tSQLt_Example;
');

CREATE DATABASE tSQLt_Example WITH TRUSTWORTHY ON;
GO
USE tSQLt_Example;
GO


------------------------------------------------------------------------------------
CREATE SCHEMA Accelerator;
GO

IF OBJECT_ID('Accelerator.Particle') IS NOT NULL DROP TABLE Accelerator.Particle;
GO
CREATE TABLE Accelerator.Particle(
  Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Point_Id PRIMARY KEY,
  X DECIMAL(10,2) NOT NULL,
  Y DECIMAL(10,2) NOT NULL,
  Value NVARCHAR(MAX) NOT NULL,
  ColorId INT NOT NULL
);
GO

IF OBJECT_ID('Accelerator.Color') IS NOT NULL DROP TABLE Practice.Color;
GO
CREATE TABLE Accelerator.Color(
  Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Color_Id PRIMARY KEY,
  ColorName NVARCHAR(MAX) NOT NULL
);
GO
---Build+
/*
   Copyright 2011 tSQLt

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
DECLARE @Msg NVARCHAR(MAX);SELECT @Msg = 'Compiled at '+CONVERT(NVARCHAR,GETDATE(),121);RAISERROR(@Msg,0,1);
GO

IF TYPE_ID('tSQLt.Private') IS NOT NULL DROP TYPE tSQLt.Private;
IF TYPE_ID('tSQLtPrivate') IS NOT NULL DROP TYPE tSQLtPrivate;
GO
IF OBJECT_ID('tSQLt.DropClass') IS NOT NULL
    EXEC tSQLt.DropClass tSQLt;
GO

IF EXISTS (SELECT 1 FROM sys.assemblies WHERE name = 'tSQLtCLR')
    DROP ASSEMBLY tSQLtCLR;
GO

CREATE SCHEMA tSQLt;
GO
SET QUOTED_IDENTIFIER ON;
GO
---Build-

GO

IF OBJECT_ID('tSQLt.DropClass') IS NOT NULL DROP PROCEDURE tSQLt.DropClass;
GO
---Build+
CREATE PROCEDURE tSQLt.DropClass
    @ClassName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Cmd NVARCHAR(MAX);

    WITH A(name, type) AS
           (SELECT QUOTENAME(SCHEMA_NAME(schema_id))+'.'+QUOTENAME(name) , type
              FROM sys.objects
             WHERE schema_id = SCHEMA_ID(@ClassName)
          ),
         B(no,cmd) AS
           (SELECT 0,'DROP ' +
                    CASE type WHEN 'P' THEN 'PROCEDURE'
                              WHEN 'PC' THEN 'PROCEDURE'
                              WHEN 'U' THEN 'TABLE'
                              WHEN 'IF' THEN 'FUNCTION'
                              WHEN 'TF' THEN 'FUNCTION'
                              WHEN 'FN' THEN 'FUNCTION'
                              WHEN 'V' THEN 'VIEW'
                     END +
                   ' ' + name + ';'
              FROM A
             UNION ALL
            SELECT -1,'DROP SCHEMA ' + QUOTENAME(name) +';'
              FROM sys.schemas
             WHERE schema_id = SCHEMA_ID(@ClassName)
           ),
         C(xml)AS
           (SELECT cmd [text()]
              FROM B
             ORDER BY no DESC
               FOR XML PATH(''), TYPE
           )
    SELECT @Cmd = xml.value('/', 'NVARCHAR(MAX)') 
      FROM C;

    EXEC(@Cmd);
END;
---Build-
GO


GO

IF OBJECT_ID('tSQLt.Private_GetFullTypeName') IS NOT NULL DROP FUNCTION tSQLt.Private_GetFullTypeName;
---Build+
GO
CREATE FUNCTION tSQLt.Private_GetFullTypeName(@TypeId INT, @Length INT, @Precision INT, @Scale INT, @CollationName NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN SELECT SchemaName + '.' + Name + Suffix + Collation AS TypeName, SchemaName, Name, Suffix
FROM(
  SELECT QUOTENAME(SCHEMA_NAME(schema_id)) SchemaName, QUOTENAME(name) Name,
              CASE WHEN max_length = -1
                    THEN ''
                   WHEN @Length = -1
                    THEN '(MAX)'
                   WHEN name LIKE 'n%char'
                    THEN '(' + CAST(@Length / 2 AS NVARCHAR) + ')'
                   WHEN name LIKE '%char' OR name LIKE '%binary'
                    THEN '(' + CAST(@Length AS NVARCHAR) + ')'
                   WHEN name IN ('decimal', 'numeric')
                    THEN '(' + CAST(@Precision AS NVARCHAR) + ',' + CAST(@Scale AS NVARCHAR) + ')'
                   ELSE ''
               END Suffix,
              CASE WHEN @CollationName IS NULL THEN ''
                   ELSE ' COLLATE ' + @CollationName
               END Collation
          FROM sys.types WHERE user_type_id = @TypeId
          )X;
---Build-
GO


GO

IF OBJECT_ID('tSQLt.Private_DisallowOverwritingNonTestSchema') IS NOT NULL DROP PROCEDURE tSQLt.Private_DisallowOverwritingNonTestSchema;
GO
---Build+
CREATE PROCEDURE tSQLt.Private_DisallowOverwritingNonTestSchema
  @ClassName NVARCHAR(MAX)
AS
BEGIN
  IF SCHEMA_ID(@ClassName) IS NOT NULL AND tSQLt.Private_IsTestClass(@ClassName) = 0
  BEGIN
    RAISERROR('Attempted to execute tSQLt.NewTestClass on ''%s'' which is an existing schema but not a test class', 16, 10, @ClassName);
  END
END;
---Build-
GO


GO

IF OBJECT_ID('tSQLt.Private_QuoteClassNameForNewTestClass') IS NOT NULL DROP FUNCTION tSQLt.Private_QuoteClassNameForNewTestClass;
GO
---Build+
CREATE FUNCTION tSQLt.Private_QuoteClassNameForNewTestClass(@ClassName NVARCHAR(MAX))
  RETURNS NVARCHAR(MAX)
AS
BEGIN
  RETURN 
    CASE WHEN @ClassName LIKE '[[]%]' THEN @ClassName
         ELSE QUOTENAME(@ClassName)
     END;
END;
---Build-
GO
 

GO

IF OBJECT_ID('tSQLt.Private_MarkSchemaAsTestClass') IS NOT NULL DROP PROCEDURE tSQLt.Private_MarkSchemaAsTestClass;
GO
---Build+
CREATE PROCEDURE tSQLt.Private_MarkSchemaAsTestClass
  @QuotedClassName NVARCHAR(MAX)
AS
BEGIN
  DECLARE @UnquotedClassName NVARCHAR(MAX);

  SELECT @UnquotedClassName = name
    FROM sys.schemas
   WHERE QUOTENAME(name) = @QuotedClassName;

  EXEC sp_addextendedproperty @name = N'tSQLt.TestClass', 
                              @value = 1,
                              @level0type = 'SCHEMA',
                              @level0name = @UnquotedClassName;
END;
---Build-
GO


GO

IF OBJECT_ID('tSQLt.NewTestClass') IS NOT NULL DROP PROCEDURE tSQLt.NewTestClass;
GO
---Build+
CREATE PROCEDURE tSQLt.NewTestClass
    @ClassName NVARCHAR(MAX)
AS
BEGIN
  BEGIN TRY
    EXEC tSQLt.Private_DisallowOverwritingNonTestSchema @ClassName;

    EXEC tSQLt.DropClass @ClassName = @ClassName;

    DECLARE @QuotedClassName NVARCHAR(MAX);
    SELECT @QuotedClassName = tSQLt.Private_QuoteClassNameForNewTestClass(@ClassName);

    EXEC ('CREATE SCHEMA ' + @QuotedClassName);  
    EXEC tSQLt.Private_MarkSchemaAsTestClass @QuotedClassName;
  END TRY
  BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(MAX);SET @ErrMsg = ERROR_MESSAGE() + ' (Error originated in ' + ERROR_PROCEDURE() + ')';
    DECLARE @ErrSvr INT;SET @ErrSvr = ERROR_SEVERITY();
    
    RAISERROR(@ErrMsg, @ErrSvr, 10);
  END CATCH;
END;
---Build-
GO


GO


CREATE TABLE tSQLt.TestResult(
    Id INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    Class NVARCHAR(MAX) NOT NULL,
    TestCase NVARCHAR(MAX) NOT NULL,
    Name AS (QUOTENAME(Class) + '.' + QUOTENAME(TestCase)),
    TranName NVARCHAR(MAX) NOT NULL,
    Result NVARCHAR(MAX) NULL,
    Msg NVARCHAR(MAX) NULL
);
GO
CREATE TABLE tSQLt.TestMessage(
    Msg NVARCHAR(MAX)
);
GO
CREATE TABLE tSQLt.Run_LastExecution(
    TestName NVARCHAR(MAX),
    SessionId INT,
    LoginTime DATETIME
);
GO

CREATE PROCEDURE tSQLt.Private_Print 
    @Message NVARCHAR(MAX),
    @Severity INT = 0
AS 
BEGIN
    DECLARE @SPos INT;SET @SPos = 1;
    DECLARE @EPos INT;
    DECLARE @Len INT; SET @Len = LEN(@Message);
    DECLARE @SubMsg NVARCHAR(MAX);
    DECLARE @Cmd NVARCHAR(MAX);
    
    DECLARE @CleanedMessage NVARCHAR(MAX);
    SET @CleanedMessage = REPLACE(@Message,'%','%%');
    
    WHILE (@SPos <= @Len)
    BEGIN
      SET @EPos = CHARINDEX(CHAR(13)+CHAR(10),@CleanedMessage+CHAR(13)+CHAR(10),@SPos);
      SET @SubMsg = SUBSTRING(@CleanedMessage, @SPos, @EPos - @SPos);
      SET @Cmd = N'RAISERROR(@Msg,@Severity,10) WITH NOWAIT;';
      EXEC sp_executesql @Cmd, 
                         N'@Msg NVARCHAR(MAX),@Severity INT',
                         @SubMsg,
                         @Severity;
      SELECT @SPos = @EPos + 2,
             @Severity = 0; --Print only first line with high severity
    END

    RETURN 0;
END;
GO

CREATE PROCEDURE tSQLt.Private_PrintXML
    @Message XML
AS 
BEGIN
    SELECT @Message FOR XML PATH('');--Required together with ":XML ON" sqlcmd statement to allow more than 1mb to be returned
    RETURN 0;
END;
GO


CREATE PROCEDURE tSQLt.GetNewTranName
  @TranName CHAR(32) OUTPUT
AS
BEGIN
  SELECT @TranName = LEFT('tSQLtTran'+REPLACE(CAST(NEWID() AS NVARCHAR(60)),'-',''),32);
END;
GO

CREATE PROCEDURE tSQLt.Fail
    @Message0 NVARCHAR(MAX) = '',
    @Message1 NVARCHAR(MAX) = '',
    @Message2 NVARCHAR(MAX) = '',
    @Message3 NVARCHAR(MAX) = '',
    @Message4 NVARCHAR(MAX) = '',
    @Message5 NVARCHAR(MAX) = '',
    @Message6 NVARCHAR(MAX) = '',
    @Message7 NVARCHAR(MAX) = '',
    @Message8 NVARCHAR(MAX) = '',
    @Message9 NVARCHAR(MAX) = ''
AS
BEGIN
   INSERT INTO tSQLt.TestMessage(Msg)
   SELECT COALESCE(@Message0, '!NULL!')
        + COALESCE(@Message1, '!NULL!')
        + COALESCE(@Message2, '!NULL!')
        + COALESCE(@Message3, '!NULL!')
        + COALESCE(@Message4, '!NULL!')
        + COALESCE(@Message5, '!NULL!')
        + COALESCE(@Message6, '!NULL!')
        + COALESCE(@Message7, '!NULL!')
        + COALESCE(@Message8, '!NULL!')
        + COALESCE(@Message9, '!NULL!');
        
   RAISERROR('tSQLt.Failure',16,10);
END;
GO

CREATE PROCEDURE tSQLt.Private_RunTest
   @TestName NVARCHAR(MAX),
   @SetUp NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @Msg NVARCHAR(MAX); SET @Msg = '';
    DECLARE @Msg2 NVARCHAR(MAX); SET @Msg2 = '';
    DECLARE @Cmd NVARCHAR(MAX); SET @Cmd = '';
    DECLARE @TestClassName NVARCHAR(MAX); SET @TestClassName = '';
    DECLARE @TestProcName NVARCHAR(MAX); SET @TestProcName = '';
    DECLARE @Result NVARCHAR(MAX); SET @Result = 'Success';
    DECLARE @TranName CHAR(32); EXEC tSQLt.GetNewTranName @TranName OUT;
    DECLARE @TestResultId INT;
    DECLARE @PreExecTrancount INT;
    
    TRUNCATE TABLE tSQLt.CaptureOutputLog;

    IF EXISTS (SELECT 1 FROM sys.extended_properties WHERE name = N'SetFakeViewOnTrigger')
    BEGIN
      RAISERROR('Test system is in an invalid state. SetFakeViewOff must be called if SetFakeViewOn was called. Call SetFakeViewOff after creating all test case procedures.', 16, 10) WITH NOWAIT;
      RETURN -1;
    END;

    SELECT @Cmd = 'EXEC ' + @TestName;
    
    SELECT @TestClassName = OBJECT_SCHEMA_NAME(OBJECT_ID(@TestName)), --tSQLt.Private_GetCleanSchemaName('', @TestName),
           @TestProcName = tSQLt.Private_GetCleanObjectName(@TestName);
           
    INSERT INTO tSQLt.TestResult(Class, TestCase, TranName, Result) 
        SELECT @TestClassName, @TestProcName, @TranName, 'A severe error happened during test execution. Test did not finish.'
        OPTION(MAXDOP 1);
    SELECT @TestResultId = SCOPE_IDENTITY();

    BEGIN TRAN;
    SAVE TRAN @TranName;

    SET @PreExecTrancount = @@TRANCOUNT;
    
    TRUNCATE TABLE tSQLt.TestMessage;

    BEGIN TRY
        IF (@SetUp IS NOT NULL) EXEC @SetUp;
        EXEC (@Cmd);
    END TRY
    BEGIN CATCH
        IF ERROR_MESSAGE() LIKE '%tSQLt.Failure%'
        BEGIN
            SELECT @Msg = Msg FROM tSQLt.TestMessage;
            SET @Result = 'Failure';
        END
        ELSE
        BEGIN
            SELECT @Msg = COALESCE(ERROR_MESSAGE(), '<ERROR_MESSAGE() is NULL>') + '{' + COALESCE(ERROR_PROCEDURE(), '<ERROR_PROCEDURE() is NULL>') + ',' + COALESCE(CAST(ERROR_LINE() AS NVARCHAR), '<ERROR_LINE() is NULL>') + '}';
            SET @Result = 'Error';
        END;
    END CATCH

    BEGIN TRY
        ROLLBACK TRAN @TranName;
    END TRY
    BEGIN CATCH
        SET @PreExecTrancount = @PreExecTrancount - @@TRANCOUNT;
        IF (@@TRANCOUNT > 0) ROLLBACK;
        BEGIN TRAN;
        IF(   @Result <> 'Success'
           OR @PreExecTrancount <> 0
          )
        BEGIN
          SELECT @Msg = COALESCE(@Msg, '<NULL>') + ' (There was also a ROLLBACK ERROR --> ' + COALESCE(ERROR_MESSAGE(), '<ERROR_MESSAGE() is NULL>') + '{' + COALESCE(ERROR_PROCEDURE(), '<ERROR_PROCEDURE() is NULL>') + ',' + COALESCE(CAST(ERROR_LINE() AS NVARCHAR), '<ERROR_LINE() is NULL>') + '})';
          SET @Result = 'Error';
        END
    END CATCH    

    If(@Result <> 'Success') 
    BEGIN
      SET @Msg2 = @TestName + ' failed: ' + @Msg;
      EXEC tSQLt.Private_Print @Message = @Msg2, @Severity = 0;
    END

    IF EXISTS(SELECT 1 FROM tSQLt.TestResult WHERE Id = @TestResultId)
    BEGIN
        UPDATE tSQLt.TestResult SET
            Result = @Result,
            Msg = @Msg
         WHERE Id = @TestResultId;
    END
    ELSE
    BEGIN
        INSERT tSQLt.TestResult(Class, TestCase, TranName, Result, Msg)
        SELECT @TestClassName, 
               @TestProcName,  
               '?', 
               'Error', 
               'TestResult entry is missing; Original outcome: ' + @Result + ', ' + @Msg;
    END    
      

    COMMIT;
END;
GO

CREATE PROCEDURE tSQLt.Private_CleanTestResult
AS
BEGIN
   DELETE FROM tSQLt.TestResult;
END;
GO

CREATE PROCEDURE tSQLt.RunTest
   @TestName NVARCHAR(MAX)
AS
BEGIN
  RAISERROR('tSQLt.RunTest has been retired. Please use tSQLt.Run instead.', 16, 10);
END;
GO

CREATE PROCEDURE tSQLt.SetTestResultFormatter
    @Formatter NVARCHAR(4000)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM sys.extended_properties WHERE [name] = N'tSQLt.ResultsFormatter')
    BEGIN
        EXEC sp_dropextendedproperty @name = N'tSQLt.ResultsFormatter',
                                    @level0type = 'SCHEMA',
                                    @level0name = 'tSQLt',
                                    @level1type = 'PROCEDURE',
                                    @level1name = 'Private_OutputTestResults';
    END;

    EXEC sp_addextendedproperty @name = N'tSQLt.ResultsFormatter', 
                                @value = @Formatter,
                                @level0type = 'SCHEMA',
                                @level0name = 'tSQLt',
                                @level1type = 'PROCEDURE',
                                @level1name = 'Private_OutputTestResults';
END;
GO

CREATE FUNCTION tSQLt.GetTestResultFormatter()
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @FormatterName NVARCHAR(MAX);
    
    SELECT @FormatterName = CAST(value AS NVARCHAR(MAX))
    FROM sys.extended_properties
    WHERE name = N'tSQLt.ResultsFormatter'
      AND major_id = OBJECT_ID('tSQLt.Private_OutputTestResults');
      
    SELECT @FormatterName = COALESCE(@FormatterName, 'tSQLt.DefaultResultFormatter');
    
    RETURN @FormatterName;
END;
GO

CREATE PROCEDURE tSQLt.DefaultResultFormatter
AS
BEGIN
    DECLARE @Msg1 NVARCHAR(MAX);
    DECLARE @Msg2 NVARCHAR(MAX);
    DECLARE @Msg3 NVARCHAR(MAX);
    DECLARE @Msg4 NVARCHAR(MAX);
    DECLARE @IsSuccess INT;
    DECLARE @SuccessCnt INT;
    DECLARE @Severity INT;
    
    SELECT ROW_NUMBER() OVER(ORDER BY Result DESC, Name ASC) No,Name [Test Case Name], Result
      INTO #Tmp
      FROM tSQLt.TestResult;
    
    EXEC tSQLt.TableToText @Msg1 OUTPUT, '#Tmp', 'No';

    SELECT @Msg3 = Msg, 
           @IsSuccess = 1 - SIGN(FailCnt + ErrorCnt),
           @SuccessCnt = SuccessCnt
      FROM tSQLt.TestCaseSummary();
      
    SELECT @Severity = 16*(1-@IsSuccess);
    
    SELECT @Msg2 = REPLICATE('-',LEN(@Msg3)),
           @Msg4 = CHAR(13)+CHAR(10);
    
    
    EXEC tSQLt.Private_Print @Msg4,0;
    EXEC tSQLt.Private_Print '+----------------------+',0;
    EXEC tSQLt.Private_Print '|Test Execution Summary|',0;
    EXEC tSQLt.Private_Print '+----------------------+',0;
    EXEC tSQLt.Private_Print @Msg4,0;
    EXEC tSQLt.Private_Print @Msg1,0;
    EXEC tSQLt.Private_Print @Msg2,0;
    EXEC tSQLt.Private_Print @Msg3, @Severity;
    EXEC tSQLt.Private_Print @Msg2,0;
END;
GO

CREATE PROCEDURE tSQLt.XmlResultFormatter
AS
BEGIN
    DECLARE @XmlOutput XML;

    SELECT @XmlOutput = (
      SELECT Tag, Parent, [testsuites!1!hide!hide], [testsuite!2!name], [testsuite!2!tests], [testsuite!2!errors], [testsuite!2!failures], [testcase!3!classname], [testcase!3!name], [failure!4!message]  FROM (
        SELECT 1 AS Tag,
               NULL AS Parent,
               'root' AS [testsuites!1!hide!hide],
               NULL AS [testsuite!2!name],
               NULL AS [testsuite!2!tests],
               NULL AS [testsuite!2!errors],
               NULL AS [testsuite!2!failures],
               NULL AS [testcase!3!classname],
               NULL AS [testcase!3!name],
               NULL AS [failure!4!message]
        UNION ALL
        SELECT 2 AS Tag, 
               1 AS Parent,
               'root',
               Class AS [testsuite!2!name],
               COUNT(1) AS [testsuite!2!tests],
               SUM(CASE Result WHEN 'Error' THEN 1 ELSE 0 END) AS [testsuite!2!errors],
               SUM(CASE Result WHEN 'Failure' THEN 1 ELSE 0 END) AS [testsuite!2!failures],
               NULL AS [testcase!3!classname],
               NULL AS [testcase!3!name],
               NULL AS [failure!4!message]
          FROM tSQLt.TestResult
        GROUP BY Class
        UNION ALL
        SELECT 3 AS Tag,
               2 AS Parent,
               'root',
               Class,
               NULL,
               NULL,
               NULL,
               Class,
               TestCase,
               NULL
          FROM tSQLt.TestResult
        UNION ALL
        SELECT 4 AS Tag,
               3 AS Parent,
               'root',
               Class,
               NULL,
               NULL,
               NULL,
               Class,
               TestCase,
               Msg
          FROM tSQLt.TestResult
         WHERE Result IN ('Failure', 'Error')) AS X
       ORDER BY [testsuite!2!name], [testcase!3!name], Tag
       FOR XML EXPLICIT
       );

    EXEC tSQLt.Private_PrintXML @XmlOutput;
END;
GO

CREATE PROCEDURE tSQLt.NullTestResultFormatter
AS
BEGIN
  RETURN 0;
END;
GO

CREATE PROCEDURE tSQLt.Private_OutputTestResults
  @TestResultFormatter NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @Formatter NVARCHAR(MAX);
    SELECT @Formatter = COALESCE(@TestResultFormatter, tSQLt.GetTestResultFormatter());
    EXEC (@Formatter);
END
GO

CREATE PROCEDURE tSQLt.RunTestClass
   @TestClassName NVARCHAR(MAX)
AS
BEGIN
    EXEC tSQLt.Run @TestClassName;
END
GO    

----------------------------------------------------------------------
CREATE FUNCTION tSQLt.Private_GetLastTestNameIfNotProvided(@TestName NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
  IF(LTRIM(ISNULL(@TestName,'')) = '')
  BEGIN
    SELECT @TestName = TestName 
      FROM tSQLt.Run_LastExecution le
      JOIN sys.dm_exec_sessions es
        ON le.SessionId = es.session_id
       AND le.LoginTime = es.login_time
     WHERE es.session_id = @@SPID;
  END

  RETURN @TestName;
END
GO

CREATE PROCEDURE tSQLt.Private_SaveTestNameForSession 
  @TestName NVARCHAR(MAX)
AS
BEGIN
  DELETE FROM tSQLt.Run_LastExecution
   WHERE SessionId = @@SPID;  

  INSERT INTO tSQLt.Run_LastExecution(TestName, SessionId, LoginTime)
  SELECT TestName = @TestName,
         session_id,
         login_time
    FROM sys.dm_exec_sessions
   WHERE session_id = @@SPID;
END
GO

----------------------------------------------------------------------
CREATE VIEW tSQLt.TestClasses
AS
  SELECT s.name AS Name, s.schema_id AS SchemaId
    FROM sys.extended_properties ep
    JOIN sys.schemas s
      ON ep.major_id = s.schema_id
   WHERE ep.name = N'tSQLt.TestClass';
GO

CREATE VIEW tSQLt.Tests
AS
  SELECT classes.SchemaId, classes.Name AS TestClassName, 
         procs.object_id AS ObjectId, procs.name AS Name
    FROM tSQLt.TestClasses classes
    JOIN sys.procedures procs ON classes.SchemaId = procs.schema_id
   WHERE LOWER(procs.name) LIKE 'test%';
GO

CREATE PROCEDURE tSQLt.Private_Run
   @TestName NVARCHAR(MAX),
   @TestResultFormatter NVARCHAR(MAX)
AS
BEGIN
SET NOCOUNT ON;
    DECLARE @FullName NVARCHAR(MAX);
    DECLARE @SchemaId INT;
    DECLARE @IsTestClass BIT;
    DECLARE @IsTestCase BIT;
    DECLARE @IsSchema BIT;
    DECLARE @SetUp NVARCHAR(MAX);SET @SetUp = NULL;
    
    SELECT @TestName = tSQLt.Private_GetLastTestNameIfNotProvided(@TestName);
    EXEC tSQLt.Private_SaveTestNameForSession @TestName;
    
    SELECT @SchemaId = schemaId,
           @FullName = quotedFullName,
           @IsTestClass = isTestClass,
           @IsSchema = isSchema,
           @IsTestCase = isTestCase
      FROM tSQLt.Private_ResolveName(@TestName);
     
    EXEC tSQLt.Private_CleanTestResult;

    IF @IsSchema = 1
    BEGIN
        EXEC tSQLt.Private_RunTestClass @FullName;
    END
    
    IF @IsTestCase = 1
    BEGIN
      SELECT @SetUp = tSQLt.Private_GetQuotedFullName(object_id)
        FROM sys.procedures
       WHERE schema_id = @SchemaId
         AND name = 'SetUp';

      EXEC tSQLt.Private_RunTest @FullName, @SetUp;
    END;

    EXEC tSQLt.Private_OutputTestResults @TestResultFormatter;
END;
GO

CREATE PROCEDURE tSQLt.Run
   @TestName NVARCHAR(MAX) = NULL
AS
BEGIN
  DECLARE @TestResultFormatter NVARCHAR(MAX);
  SELECT @TestResultFormatter = tSQLt.GetTestResultFormatter();
  
  EXEC tSQLt.Private_Run @TestName, @TestResultFormatter;
END;
GO

CREATE PROCEDURE tSQLt.RunWithXmlResults
   @TestName NVARCHAR(MAX) = NULL
AS
BEGIN
  EXEC tSQLt.Private_Run @TestName, 'tSQLt.XmlResultFormatter';
END;
GO

CREATE PROCEDURE tSQLt.RunWithNullResults
    @TestName NVARCHAR(MAX) = NULL
AS
BEGIN
  EXEC tSQLt.Private_Run @TestName, 'tSQLt.NullTestResultFormatter';
END;
GO


CREATE FUNCTION tSQLt.TestCaseSummary()
RETURNS TABLE
AS
RETURN WITH A(Cnt, SuccessCnt, FailCnt, ErrorCnt) AS (
                SELECT COUNT(1),
                       ISNULL(SUM(CASE WHEN Result = 'Success' THEN 1 ELSE 0 END), 0),
                       ISNULL(SUM(CASE WHEN Result = 'Failure' THEN 1 ELSE 0 END), 0),
                       ISNULL(SUM(CASE WHEN Result = 'Error' THEN 1 ELSE 0 END), 0)
                  FROM tSQLt.TestResult
                  
                )
       SELECT 'Test Case Summary: ' + CAST(Cnt AS NVARCHAR) + ' test case(s) executed, '+
                  CAST(SuccessCnt AS NVARCHAR) + ' succeeded, '+
                  CAST(FailCnt AS NVARCHAR) + ' failed, '+
                  CAST(ErrorCnt AS NVARCHAR) + ' errored.' Msg,*
         FROM A;
GO

CREATE PROCEDURE tSQLt.Private_RunTestClass
  @TestClassName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @TestCaseName NVARCHAR(MAX);
    DECLARE @SetUp NVARCHAR(MAX);SET @SetUp = NULL;

    SELECT @SetUp = tSQLt.Private_GetQuotedFullName(object_id)
      FROM sys.procedures
     WHERE schema_id = tSQLt.Private_GetSchemaId(@TestClassName)
       AND LOWER(name) = 'setup';

    DECLARE testCases CURSOR LOCAL FAST_FORWARD 
        FOR
     SELECT tSQLt.Private_GetQuotedFullName(object_id)
       FROM sys.procedures
      WHERE schema_id = tSQLt.Private_GetSchemaId(@TestClassName)
        AND LOWER(name) LIKE 'test%';

    OPEN testCases;
    
    FETCH NEXT FROM testCases INTO @TestCaseName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC tSQLt.Private_RunTest @TestCaseName, @SetUp;

        FETCH NEXT FROM testCases INTO @TestCaseName;
    END;

    CLOSE testCases;
    DEALLOCATE testCases;
END;
GO

CREATE PROCEDURE tSQLt.RunAll
AS
BEGIN
  DECLARE @TestResultFormatter NVARCHAR(MAX);
  SELECT @TestResultFormatter = tSQLt.GetTestResultFormatter();
  
  EXEC tSQLt.Private_RunAll @TestResultFormatter;
END;
GO

CREATE PROCEDURE tSQLt.Private_RunAll
  @TestResultFormatter NVARCHAR(MAX)
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @TestClassName NVARCHAR(MAX);
  DECLARE @TestProcName NVARCHAR(MAX);

  EXEC tSQLt.Private_CleanTestResult;

  DECLARE tests CURSOR LOCAL FAST_FORWARD FOR
   SELECT Name
     FROM tSQLt.TestClasses;

  OPEN tests;
  
  FETCH NEXT FROM tests INTO @TestClassName;
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXEC tSQLt.Private_RunTestClass @TestClassName;
    
    FETCH NEXT FROM tests INTO @TestClassName;
  END;
  
  CLOSE tests;
  DEALLOCATE tests;
  
  EXEC tSQLt.Private_OutputTestResults @TestResultFormatter;
END;
GO

CREATE PROCEDURE tSQLt.Private_ValidateProcedureCanBeUsedWithSpyProcedure
    @ProcedureName NVARCHAR(MAX)
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM sys.procedures WHERE object_id = OBJECT_ID(@ProcedureName))
    BEGIN
      RAISERROR('Cannot use SpyProcedure on %s because the procedure does not exist', 16, 10, @ProcedureName) WITH NOWAIT;
    END;
    
    IF (1020 < (SELECT COUNT(*) FROM sys.parameters WHERE object_id = OBJECT_ID(@ProcedureName)))
    BEGIN
      RAISERROR('Cannot use SpyProcedure on procedure %s because it contains more than 1020 parameters', 16, 10, @ProcedureName) WITH NOWAIT;
    END;
END;
GO


CREATE PROCEDURE tSQLt.AssertEquals
    @Expected SQL_VARIANT,
    @Actual SQL_VARIANT,
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF ((@Expected = @Actual) OR (@Actual IS NULL AND @Expected IS NULL))
      RETURN 0;

    DECLARE @Msg NVARCHAR(MAX);
    SELECT @Msg = 'Expected: <' + ISNULL(CAST(@Expected AS NVARCHAR(MAX)), 'NULL') + 
                  '> but was: <' + ISNULL(CAST(@Actual AS NVARCHAR(MAX)), 'NULL') + '>';
    IF((COALESCE(@Message,'') <> '') AND (@Message NOT LIKE '% ')) SET @Message = @Message + ' ';
    EXEC tSQLt.Fail @Message, @Msg;
END;
GO

CREATE PROCEDURE tSQLt.AssertEqualsString
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF ((@Expected = @Actual) OR (@Actual IS NULL AND @Expected IS NULL))
      RETURN 0;

    DECLARE @Msg NVARCHAR(MAX);
    SELECT @Msg = 'Expected: <' + ISNULL(@Expected, 'NULL') + 
                  '> but was: <' + ISNULL(@Actual, 'NULL') + '>';
    EXEC tSQLt.Fail @Message, @Msg;
END;
GO

CREATE PROCEDURE tSQLt.AssertObjectExists
    @ObjectName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    DECLARE @Msg NVARCHAR(MAX);
    IF(@ObjectName LIKE '#%')
    BEGIN
     IF OBJECT_ID('tempdb..'+@ObjectName) IS NULL
     BEGIN
         SELECT @Msg = '''' + COALESCE(@ObjectName, 'NULL') + ''' does not exist';
         EXEC tSQLt.Fail @Message, @Msg;
         RETURN 1;
     END;
    END
    ELSE
    BEGIN
     IF OBJECT_ID(@ObjectName) IS NULL
     BEGIN
         SELECT @Msg = '''' + COALESCE(@ObjectName, 'NULL') + ''' does not exist';
         EXEC tSQLt.Fail @Message, @Msg;
         RETURN 1;
     END;
    END;
    RETURN 0;
END;
GO

--------------------------------------------------------------------------------------------------------------------------
--below is untested code
--------------------------------------------------------------------------------------------------------------------------
GO
/*******************************************************************************************/
/*******************************************************************************************/
/*******************************************************************************************/
GO
CREATE PROCEDURE tSQLt.StubRecord(@SnTableName AS NVARCHAR(MAX), @BintObjId AS BIGINT)  
AS   
BEGIN  
    DECLARE @VcInsertStmt NVARCHAR(MAX),  
            @VcInsertValues NVARCHAR(MAX);  
    DECLARE @SnColumnName NVARCHAR(MAX); 
    DECLARE @SintDataType SMALLINT; 
    DECLARE @NvcFKCmd NVARCHAR(MAX);  
    DECLARE @VcFKVal NVARCHAR(MAX); 
  
    SET @VcInsertStmt = 'INSERT INTO ' + @SnTableName + ' ('  
      
    DECLARE curColumns CURSOR  
        LOCAL FAST_FORWARD  
    FOR  
    SELECT syscolumns.name,  
           syscolumns.xtype,  
           cmd.cmd  
    FROM syscolumns  
        LEFT OUTER JOIN dbo.sysconstraints ON syscolumns.id = sysconstraints.id  
                                      AND syscolumns.colid = sysconstraints.colid  
                                      AND sysconstraints.status = 1    -- Primary key constraints only  
        LEFT OUTER JOIN (select fkeyid id,fkey colid,N'select @V=cast(min('+syscolumns.name+') as NVARCHAR) from '+sysobjects.name cmd  
                        from sysforeignkeys   
                        join sysobjects on sysobjects.id=sysforeignkeys.rkeyid  
                        join syscolumns on sysobjects.id=syscolumns.id and syscolumns.colid=rkey) cmd  
            on cmd.id=syscolumns.id and cmd.colid=syscolumns.colid  
    WHERE syscolumns.id = OBJECT_ID(@SnTableName)  
      AND (syscolumns.isnullable = 0 )  
    ORDER BY ISNULL(sysconstraints.status, 9999), -- Order Primary Key constraints first  
             syscolumns.colorder  
  
    OPEN curColumns  
  
    FETCH NEXT FROM curColumns  
    INTO @SnColumnName, @SintDataType, @NvcFKCmd  
  
    -- Treat the first column retrieved differently, no commas need to be added  
    -- and it is the ObjId column  
    IF @@FETCH_STATUS = 0  
    BEGIN  
        SET @VcInsertStmt = @VcInsertStmt + @SnColumnName  
        SELECT @VcInsertValues = ')VALUES(' + ISNULL(CAST(@BintObjId AS nvarchar), 'NULL')  
  
        FETCH NEXT FROM curColumns  
        INTO @SnColumnName, @SintDataType, @NvcFKCmd  
    END  
    ELSE  
    BEGIN  
        -- No columns retrieved, we need to insert into any first column  
        SELECT @VcInsertStmt = @VcInsertStmt + syscolumns.name  
        FROM syscolumns  
        WHERE syscolumns.id = OBJECT_ID(@SnTableName)  
          AND syscolumns.colorder = 1  
  
        SELECT @VcInsertValues = ')VALUES(' + ISNULL(CAST(@BintObjId AS nvarchar), 'NULL')  
  
    END  
  
    WHILE @@FETCH_STATUS = 0  
    BEGIN  
        SET @VcInsertStmt = @VcInsertStmt + ',' + @SnColumnName  
        SET @VcFKVal=',0'  
        if @NvcFKCmd is not null  
        BEGIN  
            set @VcFKVal=null  
            exec sp_executesql @NvcFKCmd,N'@V NVARCHAR(MAX) output',@VcFKVal output  
            set @VcFKVal=isnull(','''+@VcFKVal+'''',',NULL')  
        END  
        SET @VcInsertValues = @VcInsertValues + @VcFKVal  
  
        FETCH NEXT FROM curColumns  
        INTO @SnColumnName, @SintDataType, @NvcFKCmd  
    END  
      
    CLOSE curColumns  
    DEALLOCATE curColumns  
  
    SET @VcInsertStmt = @VcInsertStmt + @VcInsertValues + ')'  
  
    IF EXISTS (SELECT 1   
               FROM syscolumns  
               WHERE status = 128   
                 AND id = OBJECT_ID(@SnTableName))  
    BEGIN  
        SET @VcInsertStmt = 'SET IDENTITY_INSERT ' + @SnTableName + ' ON ' + CHAR(10) +   
                             @VcInsertStmt + CHAR(10) +   
                             'SET IDENTITY_INSERT ' + @SnTableName + ' OFF '  
    END  
  
    EXEC (@VcInsertStmt)    -- Execute the actual INSERT statement  
  
END  

GO

/*******************************************************************************************/
/*******************************************************************************************/
/*******************************************************************************************/
CREATE FUNCTION tSQLt.Private_GetCleanSchemaName(@SchemaName NVARCHAR(MAX), @ObjectName NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN (SELECT SCHEMA_NAME(schema_id) 
              FROM sys.objects 
             WHERE object_id = CASE WHEN ISNULL(@SchemaName,'') in ('','[]')
                                    THEN OBJECT_ID(@ObjectName)
                                    ELSE OBJECT_ID(@SchemaName + '.' + @ObjectName)
                                END);
END;
GO

CREATE FUNCTION [tSQLt].[Private_GetCleanObjectName](@ObjectName NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN (SELECT OBJECT_NAME(OBJECT_ID(@ObjectName)));
END;
GO

CREATE FUNCTION tSQLt.Private_ResolveFakeTableNamesForBackwardCompatibility 
 (@TableName NVARCHAR(MAX), @SchemaName NVARCHAR(MAX))
RETURNS TABLE AS 
RETURN
  SELECT QUOTENAME(OBJECT_SCHEMA_NAME(object_id)) AS CleanSchemaName,
         QUOTENAME(OBJECT_NAME(object_id)) AS CleanTableName
     FROM (SELECT CASE
                    WHEN @SchemaName IS NULL THEN OBJECT_ID(@TableName)
                    ELSE COALESCE(OBJECT_ID(@SchemaName + '.' + @TableName),OBJECT_ID(@TableName + '.' + @SchemaName)) 
                  END object_id
          ) ids;
GO

CREATE PROCEDURE tSQLt.TableCompare
       @Expected NVARCHAR(MAX),
       @Actual NVARCHAR(MAX),
       @Txt NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
    DECLARE @Cmd NVARCHAR(MAX);
    DECLARE @R INT;
    DECLARE @En NVARCHAR(MAX);
    DECLARE @An NVARCHAR(MAX);
    DECLARE @Rn NVARCHAR(MAX);
    SELECT @En = QUOTENAME('#TSQLt_TempTable'+CAST(NEWID() AS NVARCHAR(100))),
           @An = QUOTENAME('#TSQLt_TempTable'+CAST(NEWID() AS NVARCHAR(100))),
           @Rn = QUOTENAME('#TSQLt_TempTable'+CAST(NEWID() AS NVARCHAR(100)));

    WITH TA AS (SELECT column_id,name,is_identity
                  FROM sys.columns 
                 WHERE object_id = OBJECT_ID(@Actual)
                 UNION ALL
                SELECT column_id,name,is_identity
                  FROM tempdb.sys.columns 
                 WHERE object_id = OBJECT_ID('tempdb..'+@Actual)
               ),
         TB AS (SELECT column_id,name,is_identity
                  FROM sys.columns 
                 WHERE object_id = OBJECT_ID(@Expected)
                 UNION ALL
                SELECT column_id,name,is_identity
                  FROM tempdb.sys.columns 
                 WHERE object_id = OBJECT_ID('tempdb..'+@Expected)
               ),
         T AS (SELECT TA.column_id,TA.name,
                      CASE WHEN TA.is_identity = 1 THEN 1
                           WHEN TB.is_identity = 1 THEN 1
                           ELSE 0
                      END is_identity
                 FROM TA
                 LEFT JOIN TB
                   ON TA.column_id = TB.column_id
              ),
         A AS (SELECT column_id,
                      P0 = ', '+QUOTENAME(name)+
                           CASE WHEN is_identity = 1
                                THEN '*1'
                                ELSE ''
                           END+
                         ' AS C'+CAST(column_id AS NVARCHAR),
                      P1 = CASE WHEN column_id = 1 THEN '' ELSE ' AND ' END+
                           '((A.C'+
                           CAST(column_id AS NVARCHAR)+
                           '=E.C'+
                           CAST(column_id AS NVARCHAR)+
                           ') OR (COALESCE(A.C'+ 
                           CAST(column_id AS NVARCHAR)+
                           ',E.C'+
                           CAST(column_id AS NVARCHAR)+
                           ') IS NULL))',
                      P2 = ', COALESCE(E.C'+
                           CAST(column_id AS NVARCHAR)+
                           ',A.C'+
                           CAST(column_id AS NVARCHAR)+
                           ') AS '+
                           QUOTENAME(name)
                 FROM T),
         B(m,p) AS (SELECT 0,0 UNION ALL 
                    SELECT 1,0 UNION ALL 
                    SELECT 2,1 UNION ALL 
                    SELECT 3,2),
         C(n,cmd) AS (SELECT 100+2000*B.m+column_id,
                             CASE B.p WHEN 0 THEN P0
                                      WHEN 1 THEN P1
                                      WHEN 2 THEN P2
                             END
                        FROM A
                       CROSS JOIN B),
         D(n,cmd) AS (SELECT * FROM C
                      UNION ALL
                      SELECT 1,'SELECT IDENTITY(int,1,1) no'
                      UNION ALL
                      SELECT 2001,' INTO '+@An+' FROM '+@Actual+';SELECT IDENTITY(int,1,1) no'
                      UNION ALL
                      SELECT 4001,' INTO '+@En+' FROM '+
                                  @Expected+';'+
                                  'WITH Match AS (SELECT A.no Ano, E.no Eno FROM '+@An+' A FULL OUTER JOIN '+@En+' E ON '
                      UNION ALL
                      SELECT 6001,'),MatchWithRowNo AS (SELECT Ano, Eno, r1=ROW_NUMBER() OVER(PARTITION BY Ano ORDER BY Eno), r2=ROW_NUMBER() OVER(PARTITION BY Eno ORDER BY Ano) FROM Match)'+
                                  ',CleanMatch AS (SELECT Ano,Eno FROM MatchWithRowNo WHERE r1 = r2)'+
                                  'SELECT CASE WHEN A.no IS NULL THEN ''<'' WHEN E.no IS NULL THEN ''>'' ELSE ''='' END AS _m_'
                      UNION ALL
                      SELECT 8001,' INTO '+@Rn+' FROM CleanMatch FULL JOIN '+@En+' E ON E.no = CleanMatch.Eno FULL JOIN '+@An+' A ON A.no = CleanMatch.Ano;'+
                                  ' SELECT @R = CASE WHEN EXISTS(SELECT 1 FROM '+@Rn+' WHERE _m_<>''='') THEN -1 ELSE 0 END;'+
--' SELECT * FROM '+@Rn+';'+
                                  ' EXEC tSQLt.TableToText @Txt OUTPUT,'''+@Rn+''',''_m_'';'+
--' PRINT @Txt;'+
                                  ' DROP TABLE '+@An+'; DROP TABLE '+@En+'; DROP TABLE '+@Rn+';'
                     ),
         E(xml) AS (SELECT cmd AS [data()]  FROM D ORDER BY n FOR XML PATH(''), TYPE)
    select @Cmd = xml.value( '/', 'NVARCHAR(max)' ) from E;

--    PRINT @Cmd;
    EXEC sp_executesql @Cmd, N'@R INT OUTPUT, @Txt NVARCHAR(MAX) OUTPUT', @R OUTPUT, @Txt OUTPUT;;

--    PRINT 'Outcome:'+CAST(@R AS NVARCHAR);
--    PRINT @Txt; 
    RETURN @R;
END;
GO

/*******************************************************************************************/
/*******************************************************************************************/
/*******************************************************************************************/
CREATE PROCEDURE tSQLt.AssertEqualsTable
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @FailMsg NVARCHAR(MAX) = 'unexpected/missing resultset rows!'
AS
BEGIN
    DECLARE @TblMsg NVARCHAR(MAX);
    DECLARE @R INT;
    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @FailureOccurred BIT;
    SET @FailureOccurred = 0;

    EXEC @FailureOccurred = tSQLt.AssertObjectExists @Actual;
    IF @FailureOccurred = 1 RETURN 1;
    EXEC @FailureOccurred = tSQLt.AssertObjectExists @Expected;
    IF @FailureOccurred = 1 RETURN 1;
        
    EXEC @R = tSQLt.TableCompare @Expected, @Actual, @TblMsg OUT;

    IF (@R <> 0)
    BEGIN
        IF ISNULL(@FailMsg,'')<>'' SET @FailMsg = @FailMsg + CHAR(13) + CHAR(10);
        EXEC tSQLt.Fail @FailMsg, @TblMsg;
    END;
    
END;
GO
/*******************************************************************************************/
/*******************************************************************************************/
/*******************************************************************************************/
CREATE FUNCTION tSQLt.Private_GetOriginalTableName(@SchemaName NVARCHAR(MAX), @TableName NVARCHAR(MAX)) --DELETE!!!
RETURNS NVARCHAR(MAX)
AS
BEGIN
  RETURN (SELECT CAST(value AS NVARCHAR(4000))
    FROM sys.extended_properties
   WHERE class_desc = 'OBJECT_OR_COLUMN'
     AND major_id = OBJECT_ID(@SchemaName + '.' + @TableName)
     AND minor_id = 0
     AND name = 'tSQLt.FakeTable_OrgTableName');
END;
GO

CREATE FUNCTION tSQLt.Private_GetOriginalTableInfo(@TableObjectId INT)
RETURNS TABLE
AS
  RETURN SELECT CAST(value AS NVARCHAR(4000)) OrgTableName,
                OBJECT_ID(QUOTENAME(OBJECT_SCHEMA_NAME(@TableObjectId)) + '.' + QUOTENAME(CAST(value AS NVARCHAR(4000)))) OrgTableObjectId
    FROM sys.extended_properties
   WHERE class_desc = 'OBJECT_OR_COLUMN'
     AND major_id = @TableObjectId
     AND minor_id = 0
     AND name = 'tSQLt.FakeTable_OrgTableName';
GO

CREATE FUNCTION tSQLt.Private_GetQuotedTableNameForConstraint(@ConstraintObjectId INT)
RETURNS TABLE
AS
RETURN
  SELECT QUOTENAME(SCHEMA_NAME(newtbl.schema_id)) + '.' + QUOTENAME(OBJECT_NAME(newtbl.object_id)) QuotedTableName,
         SCHEMA_NAME(newtbl.schema_id) SchemaName,
         OBJECT_NAME(newtbl.object_id) TableName,
         OBJECT_NAME(constraints.parent_object_id) OrgTableName
      FROM sys.objects AS constraints
      JOIN sys.extended_properties AS p
      JOIN sys.objects AS newtbl
        ON newtbl.object_id = p.major_id
       AND p.minor_id = 0
       AND p.class_desc = 'OBJECT_OR_COLUMN'
       AND p.name = 'tSQLt.FakeTable_OrgTableName'
        ON OBJECT_NAME(constraints.parent_object_id) = CAST(p.value AS NVARCHAR(4000))
       AND constraints.schema_id = newtbl.schema_id
       AND constraints.object_id = @ConstraintObjectId;
GO

CREATE FUNCTION tSQLt.Private_FindConstraint
(
  @TableObjectId INT,
  @ConstraintName NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN
  SELECT TOP(1) constraints.object_id AS ConstraintObjectId, type_desc AS ConstraintType
    FROM sys.objects constraints
    CROSS JOIN tSQLt.Private_GetOriginalTableInfo(@TableObjectId) orgTbl
   WHERE @ConstraintName IN (constraints.name, QUOTENAME(constraints.name))
     AND constraints.parent_object_id = orgTbl.OrgTableObjectId
   ORDER BY LEN(constraints.name) ASC;
GO

CREATE FUNCTION tSQLt.Private_ResolveApplyConstraintParameters
(
  @A NVARCHAR(MAX),
  @B NVARCHAR(MAX),
  @C NVARCHAR(MAX)
)
RETURNS TABLE
AS 
RETURN
  SELECT ConstraintObjectId, ConstraintType
    FROM tSQLt.Private_FindConstraint(OBJECT_ID(@A), @B)
   WHERE @C IS NULL
   UNION ALL
  SELECT *
    FROM tSQLt.Private_FindConstraint(OBJECT_ID(@A + '.' + @B), @C)
   UNION ALL
  SELECT *
    FROM tSQLt.Private_FindConstraint(OBJECT_ID(@C + '.' + @A), @B);
GO

CREATE PROCEDURE tSQLt.Private_ApplyCheckConstraint
  @ConstraintObjectId INT
AS
BEGIN
  DECLARE @Cmd NVARCHAR(MAX);
  SELECT @Cmd = 'CONSTRAINT ' + QUOTENAME(name) + ' CHECK' + definition 
    FROM sys.check_constraints
   WHERE object_id = @ConstraintObjectId;
  
  DECLARE @QuotedTableName NVARCHAR(MAX);
  
  SELECT @QuotedTableName = QuotedTableName FROM tSQLt.Private_GetQuotedTableNameForConstraint(@ConstraintObjectId);

  EXEC tSQLt.Private_RenameObjectToUniqueNameUsingObjectId @ConstraintObjectId;
  SELECT @Cmd = 'ALTER TABLE ' + @QuotedTableName + ' ADD ' + @Cmd
    FROM sys.objects 
   WHERE object_id = @ConstraintObjectId;

  EXEC (@Cmd);

END; 
GO

CREATE PROCEDURE tSQLt.Private_ApplyForeignKeyConstraint 
  @ConstraintObjectId INT
AS
BEGIN
  DECLARE @SchemaName NVARCHAR(MAX);
  DECLARE @OrgTableName NVARCHAR(MAX);
  DECLARE @TableName NVARCHAR(MAX);
  DECLARE @ConstraintName NVARCHAR(MAX);
  DECLARE @CreateFkCmd NVARCHAR(MAX);
  DECLARE @AlterTableCmd NVARCHAR(MAX);
  DECLARE @CreateIndexCmd NVARCHAR(MAX);
  DECLARE @FinalCmd NVARCHAR(MAX);
  
  SELECT @SchemaName = SchemaName,
         @OrgTableName = OrgTableName,
         @TableName = TableName,
         @ConstraintName = OBJECT_NAME(@ConstraintObjectId)
    FROM tSQLt.Private_GetQuotedTableNameForConstraint(@ConstraintObjectId);
      
  SELECT @CreateFkCmd = cmd, @CreateIndexCmd = CreIdxCmd
    FROM tSQLt.Private_GetForeignKeyDefinition(@SchemaName, @OrgTableName, @ConstraintName);
  SELECT @AlterTableCmd = 'ALTER TABLE ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + 
                          ' ADD ' + @CreateFkCmd;
  SELECT @FinalCmd = @CreateIndexCmd + @AlterTableCmd;

  EXEC tSQLt.Private_RenameObjectToUniqueName @SchemaName, @ConstraintName;
  EXEC (@FinalCmd);
END;
GO

CREATE FUNCTION tSQLt.Private_GetConstraintType(@TableObjectId INT, @ConstraintName NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
  SELECT object_id,type,type_desc
    FROM sys.objects 
   WHERE object_id = OBJECT_ID(SCHEMA_NAME(schema_id)+'.'+@ConstraintName)
     AND parent_object_id = @TableObjectId;
GO

CREATE PROCEDURE tSQLt.ApplyConstraint
       @TableName NVARCHAR(MAX),
       @ConstraintName NVARCHAR(MAX),
       @SchemaName NVARCHAR(MAX) = NULL --parameter preserved for backward compatibility. Do not use. Will be removed soon.
AS
BEGIN
  DECLARE @ConstraintType NVARCHAR(MAX);
  DECLARE @ConstraintObjectId INT;
  
  SELECT @ConstraintType = ConstraintType, @ConstraintObjectId = ConstraintObjectId
    FROM tSQLt.Private_ResolveApplyConstraintParameters (@TableName, @ConstraintName, @SchemaName);

  IF @ConstraintType = 'CHECK_CONSTRAINT'
  BEGIN
    EXEC tSQLt.Private_ApplyCheckConstraint @ConstraintObjectId;
    RETURN 0;
  END

  IF @ConstraintType = 'FOREIGN_KEY_CONSTRAINT'
  BEGIN
    EXEC tSQLt.Private_ApplyForeignKeyConstraint @ConstraintObjectId;
    RETURN 0;
  END;  
   
  RAISERROR ('ApplyConstraint could not resolve the object names, ''%s'', ''%s''. Be sure to call ApplyConstraint and pass in two parameters, such as: EXEC tSQLt.ApplyConstraint ''MySchema.MyTable'', ''MyConstraint''', 
             16, 10, @TableName, @ConstraintName);
  RETURN 0;
END;
GO


CREATE FUNCTION [tSQLt].[F_Num](
       @N INT
)
RETURNS TABLE 
AS 
RETURN WITH C0(c) AS (SELECT 1 UNION ALL SELECT 1),
            C1(c) AS (SELECT 1 FROM C0 AS A CROSS JOIN C0 AS B),
            C2(c) AS (SELECT 1 FROM C1 AS A CROSS JOIN C1 AS B),
            C3(c) AS (SELECT 1 FROM C2 AS A CROSS JOIN C2 AS B),
            C4(c) AS (SELECT 1 FROM C3 AS A CROSS JOIN C3 AS B),
            C5(c) AS (SELECT 1 FROM C4 AS A CROSS JOIN C4 AS B),
            C6(c) AS (SELECT 1 FROM C5 AS A CROSS JOIN C5 AS B)
       SELECT TOP(CASE WHEN @N>0 THEN @N ELSE 0 END) ROW_NUMBER() OVER (ORDER BY c) no
         FROM C6;
GO

CREATE PROCEDURE [tSQLt].[Private_SetFakeViewOn_SingleView]
  @ViewName NVARCHAR(MAX)
AS
BEGIN
  DECLARE @Cmd NVARCHAR(MAX),
          @SchemaName NVARCHAR(MAX),
          @TriggerName NVARCHAR(MAX);
          
  SELECT @SchemaName = OBJECT_SCHEMA_NAME(ObjId),
         @ViewName = OBJECT_NAME(ObjId),
         @TriggerName = OBJECT_NAME(ObjId) + '_SetFakeViewOn'
    FROM (SELECT OBJECT_ID(@ViewName) AS ObjId) X;

  SET @Cmd = 
     'CREATE TRIGGER $$SCHEMA_NAME$$.$$TRIGGER_NAME$$
      ON $$SCHEMA_NAME$$.$$VIEW_NAME$$ INSTEAD OF INSERT AS
      BEGIN
         RAISERROR(''Test system is in an invalid state. SetFakeViewOff must be called if SetFakeViewOn was called. Call SetFakeViewOff after creating all test case procedures.'', 16, 10) WITH NOWAIT;
         RETURN;
      END;
     ';
      
  SET @Cmd = REPLACE(@Cmd, '$$SCHEMA_NAME$$', QUOTENAME(@SchemaName));
  SET @Cmd = REPLACE(@Cmd, '$$VIEW_NAME$$', QUOTENAME(@ViewName));
  SET @Cmd = REPLACE(@Cmd, '$$TRIGGER_NAME$$', QUOTENAME(@TriggerName));
  EXEC(@Cmd);

  EXEC sp_addextendedproperty @name = N'SetFakeViewOnTrigger', 
                               @value = 1,
                               @level0type = 'SCHEMA',
                               @level0name = @SchemaName, 
                               @level1type = 'VIEW',
                               @level1name = @ViewName,
                               @level2type = 'TRIGGER',
                               @level2name = @TriggerName;

  RETURN 0;
END;
GO

CREATE PROCEDURE [tSQLt].[SetFakeViewOn]
  @SchemaName NVARCHAR(MAX)
AS
BEGIN
  DECLARE @ViewName NVARCHAR(MAX);
    
  DECLARE viewNames CURSOR LOCAL FAST_FORWARD FOR
  SELECT QUOTENAME(OBJECT_SCHEMA_NAME(object_id)) + '.' + QUOTENAME([name]) AS viewName
    FROM sys.objects
   WHERE type = 'V'
     AND schema_id = SCHEMA_ID(@SchemaName);
  
  OPEN viewNames;
  
  FETCH NEXT FROM viewNames INTO @ViewName;
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXEC tSQLt.Private_SetFakeViewOn_SingleView @ViewName;
    
    FETCH NEXT FROM viewNames INTO @ViewName;
  END;
  
  CLOSE viewNames;
  DEALLOCATE viewNames;
END;
GO

CREATE PROCEDURE [tSQLt].[SetFakeViewOff]
  @SchemaName NVARCHAR(MAX)
AS
BEGIN
  DECLARE @ViewName NVARCHAR(MAX);
    
  DECLARE viewNames CURSOR LOCAL FAST_FORWARD FOR
   SELECT QUOTENAME(OBJECT_SCHEMA_NAME(t.parent_id)) + '.' + QUOTENAME(OBJECT_NAME(t.parent_id)) AS viewName
     FROM sys.extended_properties ep
     JOIN sys.triggers t
       on ep.major_id = t.object_id
     WHERE ep.name = N'SetFakeViewOnTrigger'  
  OPEN viewNames;
  
  FETCH NEXT FROM viewNames INTO @ViewName;
  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXEC tSQLt.Private_SetFakeViewOff_SingleView @ViewName;
    
    FETCH NEXT FROM viewNames INTO @ViewName;
  END;
  
  CLOSE viewNames;
  DEALLOCATE viewNames;
END;
GO

CREATE PROCEDURE [tSQLt].[Private_SetFakeViewOff_SingleView]
  @ViewName NVARCHAR(MAX)
AS
BEGIN
  DECLARE @Cmd NVARCHAR(MAX),
          @SchemaName NVARCHAR(MAX),
          @TriggerName NVARCHAR(MAX);
          
  SELECT @SchemaName = QUOTENAME(OBJECT_SCHEMA_NAME(ObjId)),
         @TriggerName = QUOTENAME(OBJECT_NAME(ObjId) + '_SetFakeViewOn')
    FROM (SELECT OBJECT_ID(@ViewName) AS ObjId) X;
  
  SET @Cmd = 'DROP TRIGGER %SCHEMA_NAME%.%TRIGGER_NAME%;';
      
  SET @Cmd = REPLACE(@Cmd, '%SCHEMA_NAME%', @SchemaName);
  SET @Cmd = REPLACE(@Cmd, '%TRIGGER_NAME%', @TriggerName);
  
  EXEC(@Cmd);
END;
GO

CREATE FUNCTION tSQLt.Private_GetQuotedFullName(@Objectid INT)
RETURNS NVARCHAR(517)
AS
BEGIN
    DECLARE @QuotedName NVARCHAR(517);
    SELECT @QuotedName = QUOTENAME(OBJECT_SCHEMA_NAME(@Objectid)) + '.' + QUOTENAME(OBJECT_NAME(@Objectid));
    RETURN @QuotedName;
END;
GO

CREATE FUNCTION tSQLt.Private_GetSchemaId(@SchemaName NVARCHAR(MAX))
RETURNS INT
AS
BEGIN
  RETURN (
    SELECT TOP(1) schema_id
      FROM sys.schemas
     WHERE @SchemaName IN (name, QUOTENAME(name), QUOTENAME(name, '"'))
     ORDER BY 
        CASE WHEN name = @SchemaName THEN 0 ELSE 1 END
  );
END;
GO

CREATE FUNCTION tSQLt.Private_IsTestClass(@TestClassName NVARCHAR(MAX))
RETURNS BIT
AS
BEGIN
  RETURN 
    CASE 
      WHEN EXISTS(
             SELECT 1 
               FROM tSQLt.TestClasses
              WHERE SchemaId = tSQLt.Private_GetSchemaId(@TestClassName)
            )
      THEN 1
      ELSE 0
    END;
END;
GO

CREATE FUNCTION tSQLt.Private_ResolveSchemaName(@Name NVARCHAR(MAX))
RETURNS TABLE 
AS
RETURN
  WITH ids(schemaId) AS
       (SELECT tSQLt.Private_GetSchemaId(@Name)
       ),
       idsWithNames(schemaId, quotedSchemaName) AS
        (SELECT schemaId,
         QUOTENAME(SCHEMA_NAME(schemaId))
         FROM ids
        )
  SELECT schemaId, 
         quotedSchemaName,
         CASE WHEN EXISTS(SELECT 1 FROM tSQLt.TestClasses WHERE TestClasses.SchemaId = idsWithNames.schemaId)
               THEN 1
              ELSE 0
         END AS isTestClass, 
         CASE WHEN schemaId IS NOT NULL THEN 1 ELSE 0 END AS isSchema
    FROM idsWithNames;
GO

CREATE FUNCTION tSQLt.Private_ResolveObjectName(@Name NVARCHAR(MAX))
RETURNS TABLE 
AS
RETURN
  WITH ids(schemaId, objectId) AS
       (SELECT SCHEMA_ID(OBJECT_SCHEMA_NAME(OBJECT_ID(@Name))),
               OBJECT_ID(@Name)
       ),
       idsWithNames(schemaId, objectId, quotedSchemaName, quotedObjectName) AS
        (SELECT schemaId, objectId,
         QUOTENAME(SCHEMA_NAME(schemaId)) AS quotedSchemaName, 
         QUOTENAME(OBJECT_NAME(objectId)) AS quotedObjectName
         FROM ids
        )
  SELECT schemaId, 
         objectId, 
         quotedSchemaName,
         quotedObjectName,
         quotedSchemaName + '.' + quotedObjectName AS quotedFullName, 
         CASE WHEN LOWER(quotedObjectName) LIKE '[[]test%]' 
               AND objectId = OBJECT_ID(quotedSchemaName + '.' + quotedObjectName,'P') 
              THEN 1 ELSE 0 END AS isTestCase
    FROM idsWithNames;
    
GO

CREATE FUNCTION tSQLt.Private_ResolveName(@Name NVARCHAR(MAX))
RETURNS TABLE 
AS
RETURN
  WITH resolvedNames(ord, schemaId, objectId, quotedSchemaName, quotedObjectName, quotedFullName, isTestClass, isTestCase, isSchema) AS
  (SELECT 1, schemaId, NULL, quotedSchemaName, NULL, quotedSchemaName, isTestClass, 0, 1
     FROM tSQLt.Private_ResolveSchemaName(@Name)
    UNION ALL
   SELECT 2, schemaId, objectId, quotedSchemaName, quotedObjectName, quotedFullName, 0, isTestCase, 0
     FROM tSQLt.Private_ResolveObjectName(@Name)
    UNION ALL
   SELECT 3, NULL, NULL, NULL, NULL, NULL, 0, 0, 0
   )
   SELECT TOP(1) schemaId, objectId, quotedSchemaName, quotedObjectName, quotedFullName, isTestClass, isTestCase, isSchema
     FROM resolvedNames
    WHERE schemaId IS NOT NULL 
       OR ord = 3
    ORDER BY ord
GO

CREATE PROCEDURE tSQLt.Uninstall
AS
BEGIN
  DROP TYPE tSQLt.Private;

  EXEC tSQLt.DropClass 'tSQLt';  
  
  DROP ASSEMBLY tSQLtCLR;
END;
GO


GO

IF OBJECT_ID('tSQLt.CaptureOutputLog') IS NOT NULL DROP TABLE tSQLt.CaptureOutputLog;
---Build+
CREATE TABLE tSQLt.CaptureOutputLog (
  Id INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
  OutputText NVARCHAR(MAX)
);
---Build-


GO

IF OBJECT_ID('tSQLt.LogCapturedOutput') IS NOT NULL DROP PROCEDURE tSQLt.LogCapturedOutput;
GO
---Build+
CREATE PROCEDURE tSQLt.LogCapturedOutput @text NVARCHAR(MAX)
AS
BEGIN
  INSERT INTO tSQLt.CaptureOutputLog (OutputText) VALUES (@text);
END;
---Build-

GO

CREATE ASSEMBLY [tSQLtCLR]
AUTHORIZATION [dbo]
FROM 0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000800000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000504500004C0103009813A04F0000000000000000E00002210B0108000042000000060000000000005E60000000200000008000000000400000200000000200000400000000000000040000000000000000C0000000020000792201000300408500001000001000000000100000100000000000001000000000000000000000000C6000004F00000000800000E80300000000000000000000000000000000000000A000000C000000585F00001C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000080000000000000000000000082000004800000000000000000000002E7465787400000064400000002000000042000000020000000000000000000000000000200000602E72737263000000E8030000008000000004000000440000000000000000000000000000400000402E72656C6F6300000C00000000A00000000200000048000000000000000000000000000040000042000000000000000000000000000000004060000000000000480000000200050094320000C42C000009000000000000000000000000000000502000008000000000000000000000000000000000000000000000000000000000000000000000004CA35AF114B2CC9FBA7EE28B74782EFAC7474309267252CBCB9A69CB3F40ED6C11CFA45E2AD23EE1AA1A5DC0794F72CC0AC9A91BD66EAA3B748903B95FF8F3ED019789AB912EBD27650B4BB565F7DC1AB9A5E6057B80FC5B3E85927CFE6911852C30F8ED461020C84E6DB6AA1E6D9C0F7F5065FE12DCD821F7978D083A62CB991B3003006D00000001000011140A18730F00000A0B28020000060C08731000000A0A066F1100000A731200000A0D09066F1300000A090F01FE16070000016F1400000A6F1500000A096F1600000A26DE0A072C06076F1700000ADCDE0F13047201000070110473060000067ADE0A062C06066F1800000ADC2A00000001280000020009003C45000A00000000000002004F51000F30000001020002006062000A00000000133003004E0000000200001173390000060A066F3E0000060B066F3F0000060C731900000A0D0972B6000070076F1A00000A0972CE000070178C330000016F1A00000A0972F6000070086F1A00000A096F1B00000A130411042A1E02281C00000A2A1E02281E00000A2A220203281F00000A2A26020304282000000A2A26020304282100000A2A3A02281C00000A02037D010000042A7A0203280B000006027B01000004027B010000046F3B0000066F440000062A220203280B0000062A0000133002001400000003000011027B01000004036F400000060A066F2200000A2A6A282500000A6F2600000A6F2700000A6F1400000A282800000A2A001330040032000000040000117216010070282A00000A0A1200FE163E0000016F1400000A723A010070723E0100706F2B00000A282C00000A282800000A2A00001B30050015020000050000110F00282D00000A2C0B7240010070731F00000A7A0F01282D00000A2C0C723E010070282800000A100173390000060A0F000F0128110000060B0607282800000A6F400000060C0828120000060D16130409166F2E00000A8E698D400000011305096F2F00000A13102B3B1210283000000A13061613072B1F110511071105110794110611079A6F3100000A283200000A9E110717581307110711068E6932D91104175813041210283300000A2DBCDE0E1210FE160200001B6F1700000ADC1613082B1A110511081105110894209B000000283400000A9E110817581308110811058E6932DE161309110513111613122B161111111294130A110917110A58581309111217581312111211118E6932E21109175813091109110417585A130917130B1109733500000A130C096F2F00000A131338B00000001213283000000A130D110B2D08110C6F3600000A2616130E2B2C110C72760100706F3700000A110D110E9A28100000061105110E94280F0000066F3700000A26110E1758130E110E110D8E6932CC110C72760100706F3700000A26110B2C5116130B110C6F3600000A2616130F2B2C110C727A0100706F3700000A26110C110C6F3800000A723A0100701105110F946F3900000A26110F1758130F110F110D8E6932CC110C727A0100706F3700000A261213283300000A3A44FFFFFFDE0E1213FE160200001B6F1700000ADC110C6F1400000A282800000A733A00000A2A000000011C00000200680048B0000E0000000002003201C3F5010E000000009202733B00000A16727E01007003026F3100000A59283900000A6F1400000A282C00000A2AD2026F3100000A209B000000312502161F4B6F3C00000A728201007002026F3100000A1F4B591F4B6F3C00000A283D00000A2A022A0000133003004500000006000011728E01007002FE16070000016F1400000A282C00000A0A03FE16070000016F1400000A6F3100000A1631180672AC01007003FE16070000016F1400000A283D00000A0A062A000000133004001802000007000011026F3E00000A0A733F00000A0B066F4000000A6F4100000A0C088D3F0000010D1613042B2A066F4000000A11046F4200000A1305091104110572C20100706F4300000A6F1400000AA211041758130411040832D107096F4400000A38AB010000088D3F000001130616130738860100000211076F4500000A2C0F1106110772D8010070A23867010000066F4000000A11076F4200000A72E60100706F4300000AA54600000113081108130911091F0F302411091A59450400000078000000BC000000DA0000000001000011091F0F2E56380901000011091F13594503000000DF000000F3000000DF00000011091F1F59450400000005000000D9000000590000006D00000038D4000000110611070211076F4600000A284700000A2813000006A238CA000000110611070211076F4600000A284700000A2815000006A238AE000000110611070211076F4600000A284700000A2814000006A23892000000110611070211076F4600000A2816000006A22B7E110611070211076F4800000A2817000006A22B6A110611070211076F4900000A130A120AFE16470000016F1400000AA22B4C110611070211076F4A00000A130B120B284B00000A130C120C7200020070284C00000AA22B26110611070211076F4D00000A2818000006A22B12110611070211076F4E00000A6F1400000AA21107175813071107026F4F00000A3F6DFEFFFF0711066F4400000A026F5000000A3A4AFEFFFF072A5E722A0200700F00285100000A8C0E000001285200000A2A5E72480200700F00285100000A8C0E000001285200000A2A5E72800200700F00285100000A8C0E000001285200000A2A7272AA0200700F00285300000A735400000A8C0E000001285200000A2A4672EA020070028C0F000001285200000A2A00133003004400000008000011733B00000A7232030070283700000A0A0F00285500000A0C160D2B1B0809910B0612017238030070285600000A6F3700000A260917580D09088E6932DF066F1400000A2A2E723E030070731F00000A7A2E723E030070731F00000A7A2E723E030070731F00000A7A2E723E030070731F00000A7A1A735700000A7A1A735700000A7A1E02281E00000A2A220203281F00000A2A26020304282000000A2A26020304282100000A2A3A02281C00000A02037D040000042A00001B3003003400000009000011020328250000060A020428250000060B027B0400000406076F42000006DE140C027B04000004086F5800000A6F43000006DE002A01100000000000001F1F0014060000021B300200370000000A000011140A027B04000004036F400000060A066F5000000A26030628270000060B030728280000060728290000060CDE07062826000006DC082A0001100000020002002C2E0007000000002A022C06026F2200000A2A001B3003002F0000000B000011036F3E00000A0BDE240A72B20300700F00FE16070000016F1400000A72CE030070283D00000A0673210000067A072A00011000000000000009090024020000019A032D2272B20300700F00FE16070000016F1400000A7216040070283D00000A73200000067A2A001B3004000F0100000C000011723E0100700A026F4000000A6F5900000A0D38D5000000096F5A00000A74190000010B0772520400706F4300000A6F1400000A7264040070285B00000A39AA00000006726E040070282C00000A0A026F5C00000A6F5900000A13042B6311046F5A00000A74140000010C08282A0000062C4E0613051C8D0100000113061106161105A21106177272040070A2110618086F5D00000AA21106197276040070A211061A07086F5D00000A6F4300000AA211061B727A040070A21106285E00000A0A11046F5F00000A2D94DE1511047506000001130711072C0711076F1700000ADC06727E040070282C00000A0A096F5F00000A3A20FFFFFFDE14097506000001130811082C0711086F1700000ADC062A00011C000002005B0070CB00150000000002001200E7F9001400000000AA026F5D00000A72820400701B6F6000000A2D15026F5D00000A72880400701B6F6000000A16FE012A162A3A02281C00000A02037D050000042A000013300300A50000000D0000110203282D000006027B05000004046F400000060A160B066F4F00000A1631270717580B07286100000A03286200000A286300000A2C0806282E0000062B08066F6400000A2DD9066F2200000A07286100000A03286500000A286300000A2C451B8D3F0000010C08167292040070A208171201286600000AA2081872C4040070A208190F01FE16150000016F1400000AA2081A72F6040070A208286700000A73200000067A2A000000033003004F000000000000000316286100000A286500000A25286300000A2D110F01286800000A286900000A286A00000A286300000A2C22721A0500700F01FE16150000016F1400000A7278050070283D00000A73200000067A2A0013300300290000000E0000110228310000060A286B00000A06736C00000A6F6D00000A0206282F000006286B00000A6F6E00000A2A722B11286B00000A020328300000066F6F00000A026F5000000A2DE72A000013300200250000000F00001103736C00000A0A026F4F00000A8D010000010B02076F7000000A2606076F7100000A26062A0000001B3003005800000010000011026F3E00000A0A0628320000060B076F7200000A8D160000010C160D076F7300000A13052B171205287400000A1304080911042833000006A20917580D1205287500000A2DE0DE0E1205FE160400001B6F1700000ADC082A01100000020024002448000E000000001B3002006600000011000011737600000A0A026F4000000A6F5900000A0C2B35086F5A00000A74190000010B0772520400706F4300000A6F1400000A6F7700000A7294050070285B00000A2C0806076F7800000A26086F5F00000A2DC3DE110875060000010D092C06096F1700000ADC062A000001100000020012004153001100000000133005006F010000120000110272E60100706F4300000AA5460000010A0272C20100706F4300000A743F0000010B02729E0500706F4300000A74540000010C06130411044523000000050000000D000000050000000D000000050000004B000000050000000500000005000000050000000D0000000500000026000000050000000500000005000000050000000500000005000000050000000500000026000000260000000500000086000000050000008600000086000000860000007D0000008600000005000000050000004B0000004B00000038810000000706737900000A2A07060272B00500706F4300000AA5400000016A737A00000A2A0272B00500706F4300000AA5400000010D0920FF7F00003102150D0706096A737A00000A2A07060272C60500706F4300000A287B00000A287C00000A0272E80500706F4300000A287B00000A287C00000A737D00000A2A070608737E00000A2A7202060070068C460000016F1400000A7218060070283D00000A737F00000A7A00133003001400000013000011733900000673230000060A0602036F240000062A1330030014000000140000117339000006732B0000060A0602036F2C0000062A133002000E0000001500001173030000060A06026F010000062A0000133002001300000016000011733900000673080000060A06026F090000062A00133002001300000016000011733900000673080000060A06026F0A0000062A3602281C00000A02283C0000062A72027B080000042D0D02283D00000602177D0800000402288000000A2A1E027B070000042A9E02738100000A7D06000004027B0600000472600600706F8200000A027B060000046F1100000A2A32027B060000046F8300000A2A00133002002800000017000011027292060070282800000A28400000060A066F5000000A2606166F8400000A0B066F2200000A072A32027B060000046F8500000A2A000000133004005100000018000011027E8600000A7D07000004027B0600000402FE0641000006738700000A6F8800000A731200000A0A06027B060000046F1300000A060F01FE16070000016F1400000A6F1500000A061A6F8900000A0B072A000000033004004400000000000000027C07000004282D00000A2C1002723E010070282800000A7D0700000402257B07000004046F8A00000A72DC060070282C00000A282800000A288B00000A7D070000042A133003005000000019000011731200000A0A06027B060000046F1300000A0672E20600706F1500000A066F8C00000A7214070070036F8D00000A26066F8C00000A7226070070046F8D00000A26061A6F8E00000A066F1600000A262A133003003E00000019000011731200000A0A06027B060000046F1300000A0672340700706F1500000A066F8C00000A724A070070036F8D00000A26061A6F8E00000A066F1600000A262A0000133003004300000019000011731200000A0A06027B060000046F1300000A06725C0700706F1500000A066F8C00000A728C070070038C070000016F8D00000A26061A6F8E00000A066F1600000A262A0042534A4201000100000000000C00000076322E302E35303732370000000005006C0000006C0D0000237E0000D80D00008010000023537472696E677300000000581E00009807000023555300F025000010000000234755494400000000260000C406000023426C6F620000000000000002000001579FA2090900000000FA013300160000010000005F0000000A000000080000004400000045000000030000008E000000020000000F000000010000001900000002000000050000000500000004000000010000000400000000000A000100000000000600DA00D3000600E100D3000600EB00D3000A00160101010A003B01200106004C01D3000A00580101010600B50198010600C70198010A005A0201010600B6029B020A00D302BD020A00F502010106003B03D30006005903D3000A00820301010600CB03C1030600DD03C1030A004704F5000A009904F5000A00CF0401010A00270520010A00480520010E008F059B020A009C05F5000A00EF05BD020A007706BD0206001007FE0606002907D30006005E073F0706007207FE0606008B07FE060600A607FE060600C107FE060600DA07FE060600F307FE0606001208FE0606002F08FE060600590846089F006D08000006009C087C080600BC087C081200F608E20812000709E2080A0031091E090A004309BD020A005D091E0906009D098D090A00AF09BD020A00CA091E090600ED09D30006000A0AD3000A00440A1E090A00510A20010A006D0A20010600740A3F0706008A0A3F070600950AFE060600B30AFE060600C80AD3000A00E80A20010600FB0AD3000600080BD30006003D0BD3002F00430B00000600730BD3000600950B890B0A00F10BF5000A000C0CF5000A003E0CF5000A00660C01010A007F0C01010600A00CD3000600F10CD3000600F80CD3000600560D430D0A00700DF5000600A70DD3000A00CF0D01010A001D0E20010A00280E20016300430B00000E008C0E9B020600B30ED3000600CD0EB80E0600EE0ED3000600F60ED30006000D0FD30006002B0FD3000E006A0F540F0A00930FBD020A00BE0FF5000A001010BD020A003610BD020A005010F500000000000100000000000100010000001000170027000500010001000120100030002700090001000400000010004900270005000100080009011000560027000D0002000C000120100063002700090004001F00000010007D0027000500040023000000100096002700050005002B0081011000A600270005000600340000001000B70027000500060039000100D8012C0051802102360051802D0246000100D8012C000100D8012C000100FD053F01010008064301010014064701D02000000000860062010A00010074210000000091006A0110000200CE21000000008618920114000200D621000000008618920114000200DE21000000008618920118000200E72100000000861892011D000300F121000000008418920124000500FB210000000086189201300007000A22000000008300EB010A000800292200000000830003020A000900342200000000830012020A000A0054220000000096003E024E000B00702200000000960043024E000B00B022000000009600630253000B00F02400000000910071025C000D0015250000000091007B0262000F004C250000000091008B0267001000A025000000009100E10271001200C42700000000910001037C001300DC2700000000910011037C001400F42700000000910025037C0015000C2800000000910044038200160029280000000091006803880017003C280000000091008C038E0018008C280000000096089E0394001900982800000000E609A70399001900A428000000009600B2039D001900B02800000000C600B803A4001A00BC2800000000E601D803A8001A00C32800000000E601EA03AE001B00CA28000000008618920114001C00D228000000008618920118001C00DB2800000000861892011D001D00E528000000008418920124001F00EF280000000086189201300021000029000000008600FC03BD00220050290000000081001D04C5002400A4290000000091003B04CB002500B0290000000091005104D1002600FC290000000091006904DA002800242A0000000091008704E2002A005C2B000000009100A404E8002B00872B000000008618920130002C00982B000000008600D804EE002D004C2C000000008100FA04F6002F00A82C0000000091001205CB003000DD2C0000000091003305FC003100FC2C000000009100560505013300302D00000000910074050F013500A42D000000009100A40517013600282E000000009100B80522013700A42F000000009600FC0329013800C42F000000009600960031013A00E42F000000009600D30539013C000030000000009600E10539013D002030000000009600030239013E003F30000000008618920114003F004D3000000000E6011D0614003F006A3000000000860825064A013F007230000000008100350614003F009A300000000081003D0614003F00A8300000000086084806A4003F00DC300000000086085706A4003F00EC3000000000860068064F013F004C310000000084008F06560140009C310000000086009D065D014200F831000000008600AA06180044004432000000008600C8060A00450000000100DA0800000100200A00000100200A00000200280A00000100370A000002003C0A00000100D80100000100DA0800000100DA0800000100DA08000001001E0B00000200280B00000100BC0B00000200C20B00000100C90B000001001E0B00000200280B00000100DB0B00000100CC0C00000100CC0C00000100CC0C00000100CC0C00000100DE0C00000100E70C00000100BC0B00000100F60C00000100100D00000100200A00000100200A00000200280A00000100370A000002003C0A00000100D80100000100120D00000200220D00000100DA0800000100DB0B00000100DA0800000200DB0B00000100DA08000002003C0D000001003C0D00000100A00D00000100D80100000100C30D00000200DA0800000100C30D00000100120E00000100120E00000200590E00000100120E00000200590E00000100120E000001003C0D00000100A50E00000100120D00000200220D000001001F0F00000200DA0800000100DA0800000100DA0800000100DA08000001008B0F00000100DC0F00000200E30F00000100F40F000002000310000001006C10000001007B1005001100050015000A001900E10092011800E90092016C01F10092016C01F90092011800010192011800090192011800110192011800190192011800210192011800290192011800310192011800390192017101490192017801510192011400590192011F02D1009201180069013E09140071019201140071014E0926020900B803A400790167091800790177092C0231001D0614006901870914008901920114009101E4093F029101F509A400090092011400A10192011400110092011400110092011800110092011D00110092012400A90187091400B10192015502C10192018802D1019E0A8F02D101C00A9502D901D00A9B023900DC0AA102E90192011400F101000B3803F9010F0B3E03F901170B44033900A70399000C00340B57030C004E0B5D0314005C0B6F03F901680B2C021102780B740314007C0B99001102850B74031902920178011902A30B7A031902AE0B80031902680B2C021902B50B8703510092010A00190292011400F901D10BC003F901170BC603A901E20BD1030C00920114009900030CD6032902270C2C022102340BDC03C900340BE2030C00310CE703A901350CED03A901480CF2036900DC0AF8036100540CFF036100710C05046100890C0C044102960C13044902B80317046100A70C1C04A901B40C2204A901BD0C2C02A901D80399006900960C4804F9016D0A4D047100D40C53047100920157048100960C5C045102B80317045902920114001100300DA40029024E0B810461025C0B8704F901620D8B049900850D9104A100910DA400F901170B970461027C0B9900F901B80DB204A900DC0ABA04A900DA0DC0047902E60DCA04A901EE0D9900A900F90DC0040102B803A400F901170BD104A900A70399007902DC0ADF047902050EE6048102300EF204B9009201F8048902390EFF0489024A0E140089025E0EFF0461006D0E0B05B9007A0E0B051C00270C2C021C004E0B1F0524005C0B6F0324007C0B99001C0092011400F901840EA4001C009D0E4905B10092016505B10092016D05A902D90E7605B102060F7C05B10092018405B10092018E05C10292011800C9022E0FBB05D1009201140069013F0F1800D1021D061400A901740FC00569017E0FA4003900F0034301D9029201CB05D100AE0FD1057101CE0FD805D900300DA4003900E80FE80571012710F105E9024310F70579015C10FF050E000800390008000C0049002E003B003A062E007300A4062E0013000C062E001B0012062E002B0012062E00330018062E00430045062E004B0012062E00530055062E005B0084062E00630092062E006B009B06A3001B015C02A0014B01A702C0014B01A70200000100000005003002450250024A039003CD03270461046B0472047A049D04D70405051105310555059905A705AC05B105B605C505E0050606050001000A0003000000F003B4000000F503B9000000DA0663010000E60668010000F106680102001900030002001A00050002003B00070002003E00090002003F000B00500367031805290504800000010000009811E452010000007D01270000000200000000000000000000000100CA00000000000200000000000000000000000100F500000000000200000000000000000000000100D300000000000200000000000000000000000100E2080000000000000000003C4D6F64756C653E007453514C74434C522E646C6C00436F6D6D616E644578656375746F72007453514C74434C5200436F6D6D616E644578656375746F72457863657074696F6E004F7574707574436170746F72007453514C745072697661746500496E76616C6964526573756C74536574457863657074696F6E004D65746144617461457175616C697479417373657274657200526573756C7453657446696C7465720053746F72656450726F6365647572657300546573744461746162617365466163616465006D73636F726C69620053797374656D004F626A65637400457863657074696F6E0056616C7565547970650053797374656D2E446174610053797374656D2E446174612E53716C547970657300494E756C6C61626C65004D6963726F736F66742E53716C5365727665722E536572766572004942696E61727953657269616C697A650049446973706F7361626C650053716C537472696E67004578656375746500437265617465436F6E6E656374696F6E537472696E67546F436F6E746578744461746162617365002E63746F720053797374656D2E52756E74696D652E53657269616C697A6174696F6E0053657269616C697A6174696F6E496E666F0053747265616D696E67436F6E746578740074657374446174616261736546616361646500436170747572654F7574707574546F4C6F675461626C650053757070726573734F75747075740045786563757465436F6D6D616E64004E554C4C5F535452494E47004D41585F434F4C554D4E5F574944544800496E666F00437265617465556E697175654F626A6563744E616D650053716C4368617273005461626C65546F537472696E6700506164436F6C756D6E005472696D546F4D61784C656E6774680067657453716C53746174656D656E740053797374656D2E436F6C6C656374696F6E732E47656E65726963004C69737460310053797374656D2E446174612E53716C436C69656E740053716C44617461526561646572006765745461626C65537472696E6741727261790053716C4461746554696D650053716C44617465546F537472696E670053716C4461746554696D65546F537472696E6700536D616C6C4461746554696D65546F537472696E67004461746554696D650053716C4461746554696D6532546F537472696E67004461746554696D654F66667365740053716C4461746554696D654F6666736574546F537472696E670053716C42696E6172790053716C42696E617279546F537472696E67006765745F4E756C6C006765745F49734E756C6C00506172736500546F537472696E670053797374656D2E494F0042696E61727952656164657200526561640042696E617279577269746572005772697465004E756C6C0049734E756C6C00417373657274526573756C74536574734861766553616D654D6574614461746100637265617465536368656D61537472696E6746726F6D436F6D6D616E6400636C6F736552656164657200446174615461626C6500617474656D7074546F476574536368656D615461626C65007468726F77457863657074696F6E4966536368656D614973456D707479006275696C64536368656D61537472696E670044617461436F6C756D6E00636F6C756D6E50726F7065727479497356616C6964466F724D65746144617461436F6D70617269736F6E0053716C496E7433320073656E6453656C6563746564526573756C74536574546F53716C436F6E746578740076616C6964617465526573756C745365744E756D6265720073656E64526573756C747365745265636F7264730053716C4D657461446174610073656E64456163685265636F72644F66446174610053716C446174615265636F7264006372656174655265636F7264506F70756C617465645769746844617461006372656174654D65746144617461466F72526573756C74736574004C696E6B65644C69737460310044617461526F7700676574446973706C61796564436F6C756D6E730063726561746553716C4D65746144617461466F72436F6C756D6E004E6577436F6E6E656374696F6E00436170747572654F75747075740053716C436F6E6E656374696F6E00636F6E6E656374696F6E00696E666F4D65737361676500646973706F73656400446973706F7365006765745F496E666F4D65737361676500636F6E6E65637400646973636F6E6E656374006765745F5365727665724E616D65006765745F44617461626173654E616D650065786563757465436F6D6D616E640053716C496E666F4D6573736167654576656E7441726773004F6E496E666F4D65737361676500617373657274457175616C73006661696C5465737443617365416E645468726F77457863657074696F6E006C6F6743617074757265644F757470757400496E666F4D657373616765005365727665724E616D650044617461626173654E616D650053797374656D2E5265666C656374696F6E00417373656D626C7956657273696F6E41747472696275746500434C53436F6D706C69616E744174747269627574650053797374656D2E52756E74696D652E496E7465726F70536572766963657300436F6D56697369626C6541747472696275746500417373656D626C7943756C7475726541747472696275746500417373656D626C7954726164656D61726B41747472696275746500417373656D626C79436F7079726967687441747472696275746500417373656D626C7950726F6475637441747472696275746500417373656D626C79436F6D70616E7941747472696275746500417373656D626C79436F6E66696775726174696F6E41747472696275746500417373656D626C794465736372697074696F6E41747472696275746500417373656D626C795469746C654174747269627574650053797374656D2E446961676E6F73746963730044656275676761626C6541747472696275746500446562756767696E674D6F6465730053797374656D2E52756E74696D652E436F6D70696C6572536572766963657300436F6D70696C6174696F6E52656C61786174696F6E734174747269627574650052756E74696D65436F6D7061746962696C69747941747472696275746500636F6D6D616E640053797374656D2E5472616E73616374696F6E73005472616E73616374696F6E53636F7065005472616E73616374696F6E53636F70654F7074696F6E0053797374656D2E446174612E436F6D6D6F6E004462436F6E6E656374696F6E004F70656E0053716C436F6D6D616E64007365745F436F6E6E656374696F6E004462436F6D6D616E64007365745F436F6D6D616E645465787400457865637574654E6F6E517565727900436C6F73650053797374656D2E5365637572697479005365637572697479457863657074696F6E0053716C436F6E6E656374696F6E537472696E674275696C646572004462436F6E6E656374696F6E537472696E674275696C646572007365745F4974656D00426F6F6C65616E006765745F436F6E6E656374696F6E537472696E670053657269616C697A61626C65417474726962757465006D65737361676500696E6E6572457863657074696F6E00696E666F00636F6E74657874004462446174615265616465720053716C55736572446566696E65645479706541747472696275746500466F726D6174005374727563744C61796F7574417474726962757465004C61796F75744B696E6400417373656D626C7900476574457865637574696E67417373656D626C7900417373656D626C794E616D65004765744E616D650056657273696F6E006765745F56657273696F6E006F705F496D706C696369740053716C4D6574686F644174747269627574650047756964004E65774775696400537472696E67005265706C61636500436F6E636174005461626C654E616D65004F726465724F7074696F6E006765745F4974656D00496E74333200456E756D657261746F7200476574456E756D657261746F72006765745F43757272656E74006765745F4C656E677468004D617468004D6178004D6F76654E657874004D696E0053797374656D2E5465787400537472696E674275696C64657200417070656E644C696E6500417070656E6400496E7365727400696E707574006C656E67746800726F774461746100537562737472696E670072656164657200476574536368656D615461626C650044617461526F77436F6C6C656374696F6E006765745F526F777300496E7465726E616C44617461436F6C6C656374696F6E42617365006765745F436F756E740041646400497344424E756C6C0053716C446254797065004765744461746554696D65004765744461746554696D654F66667365740053716C446563696D616C0047657453716C446563696D616C0053716C446F75626C650047657453716C446F75626C65006765745F56616C756500446F75626C650047657453716C42696E6172790047657456616C7565006765745F4669656C64436F756E7400647456616C7565006765745F5469636B730064746F56616C75650073716C42696E61727900427974650072004E6F74496D706C656D656E746564457863657074696F6E0077006578706563746564436F6D6D616E640061637475616C436F6D6D616E64006765745F4D65737361676500736368656D610053797374656D2E436F6C6C656374696F6E730049456E756D657261746F72006F705F496E657175616C6974790044617461436F6C756D6E436F6C6C656374696F6E006765745F436F6C756D6E73006765745F436F6C756D6E4E616D6500636F6C756D6E00537472696E67436F6D70617269736F6E005374617274735769746800726573756C747365744E6F0053716C426F6F6C65616E006F705F457175616C697479006F705F54727565004E657874526573756C74006F705F4C6573735468616E006F705F426974776973654F7200646174615265616465720053716C436F6E746578740053716C50697065006765745F506970650053656E64526573756C747353746172740053656E64526573756C7473456E64006D6574610053656E64526573756C7473526F770047657453716C56616C7565730053657456616C75657300546F4C6F776572004C696E6B65644C6973744E6F64656031004164644C61737400636F6C756D6E44657461696C7300547970650053797374656D2E476C6F62616C697A6174696F6E0043756C74757265496E666F006765745F496E76617269616E7443756C7475726500436F6E766572740049466F726D617450726F766964657200546F4279746500417267756D656E74457863657074696F6E00726573756C745365744E6F00474300537570707265737346696E616C697A65007365745F436F6E6E656374696F6E537472696E670053797374656D2E436F6D706F6E656E744D6F64656C00436F6D706F6E656E7400476574537472696E67006765745F446174616261736500436F6D6D616E640053716C496E666F4D6573736167654576656E7448616E646C6572006164645F496E666F4D65737361676500436F6D6D616E644265686176696F7200457865637574655265616465720073656E6465720061726773006F705F4164646974696F6E006578706563746564537472696E670061637475616C537472696E670053716C506172616D65746572436F6C6C656374696F6E006765745F506172616D65746572730053716C506172616D65746572004164645769746856616C756500436F6D6D616E6454797065007365745F436F6D6D616E6454797065006661696C7572654D6573736167650074657874000080B34500720072006F007200200063006F006E006E0065006300740069006E006700200074006F002000640061007400610062006100730065002E00200059006F00750020006D006100790020006E00650065006400200074006F00200063007200650061007400650020007400530051004C007400200061007300730065006D0062006C007900200077006900740068002000450058005400450052004E0041004C005F004100430043004500530053002E0000174400610074006100200053006F007500720063006500002749006E0074006500670072006100740065006400200053006500630075007200690074007900001F49006E0069007400690061006C00200043006100740061006C006F00670000237400530051004C0074005F00740065006D0070006F0062006A006500630074005F0000032D00010100354F0062006A0065006300740020006E0061006D0065002000630061006E006E006F00740020006200650020004E0055004C004C0000037C0000032B0000032000000B3C002E002E002E003E00001D530045004C0045004300540020002A002000460052004F004D002000001520004F0052004400450052002000420059002000001543006F006C0075006D006E004E0061006D006500000D21004E0055004C004C0021000019500072006F00760069006400650072005400790070006500002930002E0030003000300030003000300030003000300030003000300030003000300045002B003000001D7B0030003A0079007900790079002D004D004D002D00640064007D0001377B0030003A0079007900790079002D004D004D002D00640064002000480048003A006D006D003A00730073002E006600660066007D0001297B0030003A0079007900790079002D004D004D002D00640064002000480048003A006D006D007D00013F7B0030003A0079007900790079002D004D004D002D00640064002000480048003A006D006D003A00730073002E0066006600660066006600660066007D0001477B0030003A0079007900790079002D004D004D002D00640064002000480048003A006D006D003A00730073002E00660066006600660066006600660020007A007A007A007D0001053000780000055800320000737400530051004C007400500072006900760061007400650020006900730020006E006F007400200069006E00740065006E00640065006400200074006F002000620065002000750073006500640020006F0075007400730069006400650020006F00660020007400530051004C0074002100001B540068006500200063006F006D006D0061006E00640020005B0000475D00200064006900640020006E006F0074002000720065007400750072006E00200061002000760061006C0069006400200072006500730075006C0074002000730065007400003B5D00200064006900640020006E006F0074002000720065007400750072006E0020006100200072006500730075006C0074002000730065007400001149007300480069006400640065006E000009540072007500650000035B0000037B0000033A0000037D0000035D0000054900730000094200610073006500003145007800650063007500740069006F006E002000720065007400750072006E006500640020006F006E006C00790020000031200052006500730075006C00740053006500740073002E00200052006500730075006C00740053006500740020005B0000235D00200064006F006500730020006E006F0074002000650078006900730074002E00005D52006500730075006C007400530065007400200069006E00640065007800200062006500670069006E007300200061007400200031002E00200052006500730075006C007400530065007400200069006E0064006500780020005B00001B5D00200069007300200069006E00760061006C00690064002E0000097400720075006500001144006100740061005400790070006500001543006F006C0075006D006E00530069007A00650000214E0075006D00650072006900630050007200650063006900730069006F006E0000194E0075006D0065007200690063005300630061006C006500001541007200670075006D0065006E00740020005B0000475D0020006900730020006E006F0074002000760061006C0069006400200066006F007200200052006500730075006C007400530065007400460069006C007400650072002E00003143006F006E007400650078007400200043006F006E006E0065006300740069006F006E003D0074007200750065003B000049530045004C004500430054002000530045005200560045005200500052004F0050004500520054005900280027005300650072007600650072004E0061006D006500270029003B0001050D000A0000317400530051004C0074002E0041007300730065007200740045007100750061006C00730053007400720069006E006700001145007800700065006300740065006400000D410063007400750061006C0000157400530051004C0074002E004600610069006C0000114D006500730073006100670065003000002F7400530051004C0074002E004C006F006700430061007000740075007200650064004F0075007400700075007400000974006500780074000000006F8550E9F9562A4A9D0C94CAA0AD2EDD0008B77A5C561934E08905200101111D0300000E03200001042001010E062002010E120907200201122111250306122805200101122802060E0C21004E0055004C004C002100020608049B000000040000111D0800021229111D111D0500020E0E080400010E0E0900020E10111D10111D0A000115122D011D0E12310500010E11350500010E11390500010E113D0500010E11410400001114032000020600011114111D0320000E05200101124505200101124904080011140328000207200201111D111D0520010E111D050001011231080002124D111D123107000201111D124D0500010E124D050001021251072002011155111D0520010111550800020112311D1259090002125D12311D12590700011D125912310A0001151261011265124D0600011259126507000201111D111D070002011155111D05000101111D030612690306111D020602042000111D0620011231111D062002011C126D052002010E0E042800111D0328000E0420010102062001011180A1042001010880A00024000004800000940000000602000000240000525341310004000001000100590AB8C4CF2A26FA41954EEAABE1E3D152A84C81F41E1FAD58EAE59DFB9D7D3520D36FDFC23567120AF4B46ACC235A150B34CF341AD40147E9DD4F11A1A7A8D20664924F46776FD00AA300F2E09F7BFBE5583FFFBB233B24401A3C0894E805BA8BE5451FDBD81AD24E0897512A842B08E1FC09CC6F35B3B21B5F927687887AC4062001011180B1052001011269032000080E070512691280AD0E1280B91280C1052002010E1C0A070512280E0E1280C50E0407011231062001011180DD2B010002000000020054080B4D61784279746553697A650100000054020D497346697865644C656E67746801062001011180E50500001280E90520001280ED0520001280F1050001111D0E808F010001005455794D6963726F736F66742E53716C5365727665722E5365727665722E446174614163636573734B696E642C2053797374656D2E446174612C2056657273696F6E3D322E302E302E302C2043756C747572653D6E65757472616C2C205075626C69634B6579546F6B656E3D623737613563353631393334653038390A44617461416363657373010000000500001180F90520020E0E0E0500020E0E0E0507011180F90615122D011D0E052001130008092000151181050113000715118105011D0E042000130005000208080805200012810D06200112810D0E08200312810D080E082F071412280E123115122D011D0E081D081D0E080808080212810D1D0E080815118105011D0E1D080815118105011D0E0520020E08080600030E0E0E0E0307010E042000124D0520001281110520011265080420011C0E052001011300042001020805200111390806000111351139052001113D0806200111811D08062001118121080320000D0420010E0E0520011141080420011C0820070D124D15122D011D0E081D0E0812651D0E0811811911811911811D1181210D04200011390500020E0E1C0320000A042001010A0420001D0509070412810D051D05080607030E0E12180707031231124D0E0607021209124D0520001281310320001C050002020E0E0520001281350500010E1D1C1407090E126512511281311281311C1D1C12191219072002020E11813905000111550809000211813D115511550600010211813D0500010E1D0E0707031231081D0E06000111813D020B000211813D11813D11813D050000128145062001011D125905200101125D0507011D1259052001081D1C060702125D1D1C06151261011265092000151181490113000715118149011265170706124D1512610112651D1259081265151181490112650B20011512814D01130013000F070415126101126512651281311219072002010E118119082003010E1181190A050000128155070002051C12815D092004010E11811905050A2003010E1181191281510D07051181190E12815108118119040701121C040701122004070112080407011210040001011C0420010E0805070212310E052002011C180620010112816D07200112311181710707021280B91231080002111D111D111D0520001281750720021281790E1C0620010111817D0507011280B90501000100000501000000002101001C436F7079726967687420C2A92073716C6974792E6E6574203230313000000A0100057453514C7400000F01000A73716C6974792E6E657400002E010029434C527320666F7220746865207453514C7420756E69742074657374696E67206672616D65776F726B00000D0100087453514C74434C5200000801000200000000000801000800000000001E01000100540216577261704E6F6E457863657074696F6E5468726F77730100000000009813A04F000000000200000095000000745F0000744100005253445340C8124359C3AC4D88C93F5C236A856601000000633A5C55736572735C6D65696E736530305C62616D626F6F2D686F6D655C786D6C2D646174615C6275696C642D6469725C5453514C542D5453514C54504C414E2D5453514C544255494C445C7453514C74434C525C7453514C74434C525C6F626A5C437275697365436F6E74726F6C5C7453514C74434C522E706462000000003460000000000000000000004E60000000200000000000000000000000000000000000000000000040600000000000000000000000005F436F72446C6C4D61696E006D73636F7265652E646C6C0000000000FF25002040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100100000001800008000000000000000000000000000000100010000003000008000000000000000000000000000000100000000004800000058800000900300000000000000000000900334000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE0000010000000100E452981100000100E45298113F000000000000000400000002000000000000000000000000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000000B004F0020000010053007400720069006E006700460069006C00650049006E0066006F000000CC02000001003000300030003000300034006200300000006C002A00010043006F006D006D0065006E0074007300000043004C0052007300200066006F007200200074006800650020007400530051004C007400200075006E00690074002000740065007300740069006E00670020006600720061006D00650077006F0072006B00000038000B00010043006F006D00700061006E0079004E0061006D00650000000000730071006C006900740079002E006E0065007400000000003C0009000100460069006C0065004400650073006300720069007000740069006F006E00000000007400530051004C00740043004C0052000000000040000F000100460069006C006500560065007200730069006F006E000000000031002E0030002E0034003500300034002E0032003100320032003000000000003C000D00010049006E007400650072006E0061006C004E0061006D00650000007400530051004C00740043004C0052002E0064006C006C00000000005C001C0001004C006500670061006C0043006F007000790072006900670068007400000043006F0070007900720069006700680074002000A9002000730071006C006900740079002E006E006500740020003200300031003000000044000D0001004F0072006900670069006E0061006C00460069006C0065006E0061006D00650000007400530051004C00740043004C0052002E0064006C006C00000000002C0006000100500072006F0064007500630074004E0061006D006500000000007400530051004C007400000044000F000100500072006F006400750063007400560065007200730069006F006E00000031002E0030002E0034003500300034002E00320031003200320030000000000048000F00010041007300730065006D0062006C0079002000560065007200730069006F006E00000031002E0030002E0034003500300034002E003200310032003200300000000000000000000000000000000000000000000000000000000000006000000C000000603000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
WITH PERMISSION_SET = EXTERNAL_ACCESS
GO



GO

/*
   Copyright 2011 tSQLt

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
GO

CREATE PROCEDURE tSQLt.ResultSetFilter @ResultsetNo INT, @Command NVARCHAR(MAX)
AS
EXTERNAL NAME tSQLtCLR.[tSQLtCLR.StoredProcedures].ResultSetFilter;
GO

CREATE PROCEDURE tSQLt.AssertResultSetsHaveSameMetaData @expectedCommand NVARCHAR(MAX), @actualCommand NVARCHAR(MAX)
AS
EXTERNAL NAME tSQLtCLR.[tSQLtCLR.StoredProcedures].AssertResultSetsHaveSameMetaData;
GO

CREATE TYPE tSQLt.[Private] EXTERNAL NAME tSQLtCLR.[tSQLtCLR.tSQLtPrivate];
GO

CREATE PROCEDURE tSQLt.NewConnection @command NVARCHAR(MAX)
AS
EXTERNAL NAME tSQLtCLR.[tSQLtCLR.StoredProcedures].NewConnection;
GO

CREATE PROCEDURE tSQLt.CaptureOutput @command NVARCHAR(MAX)
AS
EXTERNAL NAME tSQLtCLR.[tSQLtCLR.StoredProcedures].CaptureOutput;
GO

CREATE PROCEDURE tSQLt.SuppressOutput @command NVARCHAR(MAX)
AS
EXTERNAL NAME tSQLtCLR.[tSQLtCLR.StoredProcedures].SuppressOutput;
GO



GO

IF OBJECT_ID('tSQLt.Info') IS NOT NULL DROP FUNCTION tSQLt.Info;
GO
---Build+
CREATE FUNCTION tSQLt.Info()
RETURNS TABLE
AS
RETURN
SELECT
Version = '1.0.4504.21220',
ClrVersion = (SELECT tSQLt.Private::Info());
---Build-


GO

IF OBJECT_ID('tSQLt.TableToText') IS NOT NULL DROP PROCEDURE tSQLt.TableToText;
GO
---Build+
CREATE PROCEDURE tSQLt.TableToText
    @txt NVARCHAR(MAX) OUTPUT,
    @TableName NVARCHAR(MAX),
    @OrderBy NVARCHAR(MAX) = NULL
AS
BEGIN
    SET @txt = tSQLt.Private::TableToString(@TableName,@OrderBy);
END;
---Build-


GO

IF OBJECT_ID('tSQLt.Private_GetForeignKeyDefinition') IS NOT NULL DROP FUNCTION tSQLt.Private_GetForeignKeyDefinition;
GO
---Build+
CREATE FUNCTION tSQLt.Private_GetForeignKeyDefinition(
    @SchemaName NVARCHAR(MAX),
    @ParentTableName NVARCHAR(MAX),
    @ForeignKeyName NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN SELECT 'CONSTRAINT ' + name + ' FOREIGN KEY (' +
              parCol + ') REFERENCES ' + refName + '(' + refCol + ')' cmd,
              CASE 
                WHEN RefTableIsFakedInd = 1
                  THEN 'CREATE UNIQUE INDEX ' + tSQLt.Private::CreateUniqueObjectName() + ' ON ' + refName + '(' + refCol + ');' 
                ELSE '' 
              END CreIdxCmd
         FROM (SELECT QUOTENAME(SCHEMA_NAME(k.schema_id)) AS SchemaName,
                      QUOTENAME(k.name) AS name,
                      QUOTENAME(OBJECT_NAME(k.parent_object_id)) AS parName,
                      QUOTENAME(SCHEMA_NAME(refTab.schema_id)) + '.' + QUOTENAME(refTab.name) AS refName,
                      QUOTENAME(parCol.name) AS parCol,
                      QUOTENAME(refCol.name) AS refCol,
                      CASE WHEN e.name IS NULL THEN 0
                           ELSE 1 
                       END AS RefTableIsFakedInd
                 FROM sys.foreign_keys k
                 JOIN sys.foreign_key_columns c
                   ON k.object_id = c.constraint_object_id
                 JOIN sys.columns parCol
                   ON parCol.object_id = c.parent_object_id
                  AND parCol.column_id = c.parent_column_id
                 JOIN sys.columns refCol
                   ON refCol.object_id = c.referenced_object_id
                  AND refCol.column_id = c.referenced_column_id
                 LEFT JOIN sys.extended_properties e
                   ON e.name = 'tSQLt.FakeTable_OrgTableName'
                  AND e.value = OBJECT_NAME(c.referenced_object_id)
                 JOIN sys.tables refTab
                   ON COALESCE(e.major_id,refCol.object_id) = refTab.object_id
                WHERE k.parent_object_id = OBJECT_ID(@SchemaName + '.' + @ParentTableName)
                  AND k.object_id = OBJECT_ID(@SchemaName + '.' + @ForeignKeyName)
               )x;
---Build-

GO

IF OBJECT_ID('tSQLt.Private_RenamedObjectLog') IS NOT NULL DROP TABLE tSQLt.Private_RenamedObjectLog;
GO
---Build+
CREATE TABLE tSQLt.Private_RenamedObjectLog (
  Id INT IDENTITY(1,1) CONSTRAINT PK__Private_RenamedObjectLog__Id PRIMARY KEY CLUSTERED,
  ObjectId INT NOT NULL,
  OriginalName NVARCHAR(MAX) NOT NULL
);
---Build-
GO

GO

IF OBJECT_ID('tSQLt.Private_MarkObjectBeforeRename') IS NOT NULL DROP PROCEDURE tSQLt.Private_MarkObjectBeforeRename;
GO
---Build+
CREATE PROCEDURE tSQLt.Private_MarkObjectBeforeRename
    @SchemaName NVARCHAR(MAX), 
    @OriginalName NVARCHAR(MAX)
AS
BEGIN
  INSERT INTO tSQLt.Private_RenamedObjectLog (ObjectId, OriginalName) 
  VALUES (OBJECT_ID(@SchemaName + '.' + @OriginalName), @OriginalName);
END;
---Build-
GO


GO

IF OBJECT_ID('tSQLt.Private_RenameObjectToUniqueName') IS NOT NULL DROP PROCEDURE tSQLt.Private_RenameObjectToUniqueName;
GO
---Build+
CREATE PROCEDURE tSQLt.Private_RenameObjectToUniqueName
    @SchemaName NVARCHAR(MAX),
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
   SET @NewName=tSQLt.Private::CreateUniqueObjectName();

   DECLARE @RenameCmd NVARCHAR(MAX);
   SET @RenameCmd = 'EXEC sp_rename ''' + 
                          @SchemaName + '.' + @ObjectName + ''', ''' + 
                          @NewName + ''';';
   
   EXEC tSQLt.Private_MarkObjectBeforeRename @SchemaName, @ObjectName;

   EXEC tSQLt.SuppressOutput @RenameCmd;

END;
---Build-
GO


GO

IF OBJECT_ID('tSQLt.Private_RenameObjectToUniqueNameUsingObjectId') IS NOT NULL DROP PROCEDURE tSQLt.Private_RenameObjectToUniqueNameUsingObjectId;
GO
---Build+
CREATE PROCEDURE tSQLt.Private_RenameObjectToUniqueNameUsingObjectId
    @ObjectId INT,
    @NewName NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
   DECLARE @SchemaName NVARCHAR(MAX);
   DECLARE @ObjectName NVARCHAR(MAX);
   
   SELECT @SchemaName = QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId)), @ObjectName = QUOTENAME(OBJECT_NAME(@ObjectId));
   
   EXEC tSQLt.Private_RenameObjectToUniqueName @SchemaName,@ObjectName, @NewName OUTPUT;
END;
---Build-
GO


GO

IF OBJECT_ID('tSQLt.Private_ValidateFakeTableParameters') IS NOT NULL DROP PROCEDURE tSQLt.Private_ValidateFakeTableParameters;
GO
---Build+
CREATE PROCEDURE tSQLt.Private_ValidateFakeTableParameters
  @SchemaName NVARCHAR(MAX),
  @OrigTableName NVARCHAR(MAX),
  @OrigSchemaName NVARCHAR(MAX)
AS
BEGIN
   IF @SchemaName IS NULL
   BEGIN
        DECLARE @FullName NVARCHAR(MAX); SET @FullName = @OrigTableName + COALESCE('.' + @OrigSchemaName, '');
        
        RAISERROR ('FakeTable could not resolve the object name, ''%s''. Be sure to call FakeTable and pass in a single parameter, such as: EXEC tSQLt.FakeTable ''MySchema.MyTable''', 
                   16, 10, @FullName);
   END;
END;
---Build-
GO



GO

IF OBJECT_ID('tSQLt.Private_GetDataTypeOrComputedColumnDefinition') IS NOT NULL DROP FUNCTION tSQLt.Private_GetDataTypeOrComputedColumnDefinition;
---Build+
GO
CREATE FUNCTION tSQLt.Private_GetDataTypeOrComputedColumnDefinition(@UserTypeId INT, @MaxLength INT, @Precision INT, @Scale INT, @CollationName NVARCHAR(MAX), @ObjectId INT, @ColumnId INT, @ReturnDetails BIT)
RETURNS TABLE
AS
RETURN SELECT 
              COALESCE(IsComputedColumn, 0) AS IsComputedColumn,
              COALESCE(ComputedColumnDefinition, TypeName) AS ColumnDefinition
        FROM tSQLt.Private_GetFullTypeName(@UserTypeId, @MaxLength, @Precision, @Scale, @CollationName)
        LEFT JOIN (SELECT 1 AS IsComputedColumn,' AS '+ definition + CASE WHEN is_persisted = 1 THEN ' PERSISTED' ELSE '' END AS ComputedColumnDefinition,object_id,column_id
                     FROM sys.computed_columns 
                  )cc
               ON cc.object_id = @ObjectId
              AND cc.column_id = @ColumnId
              AND @ReturnDetails = 1;               
---Build-
GO


GO

IF OBJECT_ID('tSQLt.Private_GetIdentityDefinition') IS NOT NULL DROP FUNCTION tSQLt.Private_GetIdentityDefinition;
GO
---Build+
CREATE FUNCTION tSQLt.Private_GetIdentityDefinition(@ObjectId INT, @ColumnId INT, @ReturnDetails BIT)
RETURNS TABLE
AS
RETURN SELECT 
              COALESCE(IsIdentity, 0) AS IsIdentityColumn,
              COALESCE(IdentityDefinition, '') AS IdentityDefinition
        FROM (SELECT 1) X(X)
        LEFT JOIN (SELECT 1 AS IsIdentity,
                          ' IDENTITY(' + CAST(seed_value AS NVARCHAR(MAX)) + ',' + CAST(increment_value AS NVARCHAR(MAX)) + ')' AS IdentityDefinition, 
                          object_id, 
                          column_id
                     FROM sys.identity_columns
                  ) AS id
               ON id.object_id = @ObjectId
              AND id.column_id = @ColumnId
              AND @ReturnDetails = 1;               
---Build-
GO


GO

IF OBJECT_ID('tSQLt.Private_GetDefaultConstraintDefinition') IS NOT NULL DROP FUNCTION tSQLt.Private_GetDefaultConstraintDefinition;
---Build+
GO
CREATE FUNCTION tSQLt.Private_GetDefaultConstraintDefinition(@ObjectId INT, @ColumnId INT, @ReturnDetails BIT)
RETURNS TABLE
AS
RETURN SELECT 
              COALESCE(IsDefault, 0) AS IsDefault,
              COALESCE(DefaultDefinition, '') AS DefaultDefinition
        FROM (SELECT 1) X(X)
        LEFT JOIN (SELECT 1 AS IsDefault,' DEFAULT '+ definition AS DefaultDefinition,parent_object_id,parent_column_id
                     FROM sys.default_constraints
                  )dc
               ON dc.parent_object_id = @ObjectId
              AND dc.parent_column_id = @ColumnId
              AND @ReturnDetails = 1;               
---Build-
GO

GO

IF OBJECT_ID('tSQLt.Private_CreateFakeOfTable') IS NOT NULL DROP PROCEDURE tSQLt.Private_CreateFakeOfTable;
GO
---Build+
CREATE PROCEDURE tSQLt.Private_CreateFakeOfTable
  @SchemaName NVARCHAR(MAX),
  @TableName NVARCHAR(MAX),
  @NewNameOfOriginalTable NVARCHAR(MAX),
  @Identity BIT,
  @ComputedColumns BIT,
  @Defaults BIT
AS
BEGIN
   DECLARE @Cmd NVARCHAR(MAX);
   DECLARE @Cols NVARCHAR(MAX);
   
   SELECT @Cols = 
   (
    SELECT
       ',' +
       QUOTENAME(name) + 
       cc.ColumnDefinition +
       dc.DefaultDefinition + 
       id.IdentityDefinition +
       CASE WHEN cc.IsComputedColumn = 1 OR id.IsIdentityColumn = 1 
            THEN ''
            ELSE ' NULL'
       END
      FROM sys.columns c
     CROSS APPLY tSQLt.Private_GetDataTypeOrComputedColumnDefinition(c.user_type_id, c.max_length, c.precision, c.scale, c.collation_name, c.object_id, c.column_id, @ComputedColumns) cc
     CROSS APPLY tSQLt.Private_GetDefaultConstraintDefinition(c.object_id, c.column_id, @Defaults) AS dc
     CROSS APPLY tSQLt.Private_GetIdentityDefinition(c.object_id, c.column_id, @Identity) AS id
     WHERE object_id = OBJECT_ID(@SchemaName + '.' + @NewNameOfOriginalTable)
     ORDER BY column_id
     FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)');
    
   SELECT @Cmd = 'CREATE TABLE ' + @SchemaName + '.' + @TableName + '(' + STUFF(@Cols,1,1,'') + ')';
   
   EXEC (@Cmd);
END;
---Build-
GO


GO

IF OBJECT_ID('tSQLt.Private_MarkFakeTable') IS NOT NULL DROP PROCEDURE tSQLt.Private_MarkFakeTable;
GO
---Build+
CREATE PROCEDURE tSQLt.Private_MarkFakeTable
  @SchemaName NVARCHAR(MAX),
  @TableName NVARCHAR(MAX),
  @NewNameOfOriginalTable NVARCHAR(4000)
AS
BEGIN
   DECLARE @UnquotedSchemaName NVARCHAR(MAX);SET @UnquotedSchemaName = OBJECT_SCHEMA_NAME(OBJECT_ID(@SchemaName+'.'+@TableName));
   DECLARE @UnquotedTableName NVARCHAR(MAX);SET @UnquotedTableName = OBJECT_NAME(OBJECT_ID(@SchemaName+'.'+@TableName));

   EXEC sys.sp_addextendedproperty 
      @name = N'tSQLt.FakeTable_OrgTableName', 
      @value = @NewNameOfOriginalTable, 
      @level0type = N'SCHEMA', @level0name = @UnquotedSchemaName, 
      @level1type = N'TABLE',  @level1name = @UnquotedTableName;
END;
---Build-
GO

GO

IF OBJECT_ID('tSQLt.FakeTable') IS NOT NULL DROP PROCEDURE tSQLt.FakeTable;
GO
---Build+
CREATE PROCEDURE tSQLt.FakeTable
    @TableName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL, --parameter preserved for backward compatibility. Do not use. Will be removed soon.
    @Identity BIT = NULL,
    @ComputedColumns BIT = NULL,
    @Defaults BIT = NULL
AS
BEGIN
   DECLARE @OrigSchemaName NVARCHAR(MAX);
   DECLARE @OrigTableName NVARCHAR(MAX);
   DECLARE @NewNameOfOriginalTable NVARCHAR(4000);
   
   SELECT @OrigSchemaName = @SchemaName,
          @OrigTableName = @TableName
   
   SELECT @SchemaName = CleanSchemaName,
          @TableName = CleanTableName
     FROM tSQLt.Private_ResolveFakeTableNamesForBackwardCompatibility(@TableName, @SchemaName);
   
   EXEC tSQLt.Private_ValidateFakeTableParameters @SchemaName,@OrigTableName,@OrigSchemaName;

   EXEC tSQLt.Private_RenameObjectToUniqueName @SchemaName, @TableName, @NewNameOfOriginalTable OUTPUT;

   EXEC tSQLt.Private_CreateFakeOfTable @SchemaName, @TableName, @NewNameOfOriginalTable, @Identity, @ComputedColumns, @Defaults;

   EXEC tSQLt.Private_MarkFakeTable @SchemaName, @TableName, @NewNameOfOriginalTable;
END
---Build-
GO


GO

IF OBJECT_ID('tSQLt.Private_CreateProcedureSpy') IS NOT NULL DROP PROCEDURE tSQLt.Private_CreateProcedureSpy;
GO
---Build+
CREATE PROCEDURE tSQLt.Private_CreateProcedureSpy
    @ProcedureObjectId INT,
    @OriginalProcedureName NVARCHAR(MAX),
    @LogTableName NVARCHAR(MAX),
    @CommandToExecute NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @Cmd NVARCHAR(MAX);
    DECLARE @ProcParmList NVARCHAR(MAX),
            @TableColList NVARCHAR(MAX),
            @ProcParmTypeList NVARCHAR(MAX),
            @TableColTypeList NVARCHAR(MAX);
            
    DECLARE @Seperator CHAR(1),
            @ProcParmTypeListSeparater CHAR(1),
            @ParamName sysname,
            @TypeName sysname,
            @IsOutput BIT,
            @IsCursorRef BIT;
            

      
    SELECT @Seperator = '', @ProcParmTypeListSeparater = '', 
           @ProcParmList = '', @TableColList = '', @ProcParmTypeList = '', @TableColTypeList = '';
      
    DECLARE Parameters CURSOR FOR
     SELECT p.name, t.TypeName, is_output, is_cursor_ref
       FROM sys.parameters p
       CROSS APPLY tSQLt.Private_GetFullTypeName(p.user_type_id,p.max_length,p.precision,p.scale,NULL) t
      WHERE object_id = @ProcedureObjectId;
    
    OPEN Parameters;
    
    FETCH NEXT FROM Parameters INTO @ParamName, @TypeName, @IsOutput, @IsCursorRef;
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF @IsCursorRef = 0
        BEGIN
            SELECT @ProcParmList = @ProcParmList + @Seperator + @ParamName, 
                   @TableColList = @TableColList + @Seperator + '[' + STUFF(@ParamName,1,1,'') + ']', 
                   @ProcParmTypeList = @ProcParmTypeList + @ProcParmTypeListSeparater + @ParamName + ' ' + @TypeName + ' = NULL ' + 
                                       CASE WHEN @IsOutput = 1 THEN ' OUT' 
                                            ELSE '' 
                                       END, 
                   @TableColTypeList = @TableColTypeList + ',[' + STUFF(@ParamName,1,1,'') + '] ' + 
                          CASE WHEN @TypeName LIKE '%nchar%'
                                 OR @TypeName LIKE '%nvarchar%'
                               THEN 'nvarchar(MAX)'
                               WHEN @TypeName LIKE '%char%'
                               THEN 'varchar(MAX)'
                               ELSE @TypeName
                          END + ' NULL';

            SELECT @Seperator = ',';        
            SELECT @ProcParmTypeListSeparater = ',';
        END
        ELSE
        BEGIN
            SELECT @ProcParmTypeList = @ProcParmTypeListSeparater + @ParamName + ' CURSOR VARYING OUTPUT';
            SELECT @ProcParmTypeListSeparater = ',';
        END;
        
        FETCH NEXT FROM Parameters INTO @ParamName, @TypeName, @IsOutput, @IsCursorRef;
    END;
    
    CLOSE Parameters;
    DEALLOCATE Parameters;
    
    DECLARE @InsertStmt NVARCHAR(MAX);
    SELECT @InsertStmt = 'INSERT INTO ' + @LogTableName + 
                         CASE WHEN @TableColList = '' THEN ' DEFAULT VALUES'
                              ELSE ' (' + @TableColList + ') SELECT ' + @ProcParmList
                         END + ';';
                         
    SELECT @Cmd = 'CREATE TABLE ' + @LogTableName + ' (_id_ int IDENTITY(1,1) PRIMARY KEY CLUSTERED ' + @TableColTypeList + ');';
    EXEC(@Cmd);

    SELECT @Cmd = 'CREATE PROCEDURE ' + @OriginalProcedureName + ' ' + @ProcParmTypeList + 
                  ' AS BEGIN ' + 
                     @InsertStmt + 
                     ISNULL(@CommandToExecute, '') + ';' +
                  ' END;';
    EXEC(@Cmd);

    RETURN 0;
END;
---Build-
GO


GO

IF OBJECT_ID('tSQLt.SpyProcedure') IS NOT NULL DROP PROCEDURE tSQLt.SpyProcedure;
GO
---Build+
CREATE PROCEDURE tSQLt.SpyProcedure
    @ProcedureName NVARCHAR(MAX),
    @CommandToExecute NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @ProcedureObjectId INT;
    SELECT @ProcedureObjectId = OBJECT_ID(@ProcedureName);

    EXEC tSQLt.Private_ValidateProcedureCanBeUsedWithSpyProcedure @ProcedureName;

    DECLARE @LogTableName NVARCHAR(MAX);
    SELECT @LogTableName = QUOTENAME(OBJECT_SCHEMA_NAME(@ProcedureObjectId)) + '.' + QUOTENAME(OBJECT_NAME(@ProcedureObjectId)+'_SpyProcedureLog');

    EXEC tSQLt.Private_RenameObjectToUniqueNameUsingObjectId @ProcedureObjectId;

    EXEC tSQLt.Private_CreateProcedureSpy @ProcedureObjectId, @ProcedureName, @LogTableName, @CommandToExecute;

    RETURN 0;
END;
---Build-
GO


GO


/*
   Copyright 2011 tSQLt

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
IF OBJECT_ID('Accelerator.IsExperimentReady') IS NOT NULL DROP FUNCTION Accelerator.IsExperimentReady;
GO

CREATE FUNCTION Accelerator.IsExperimentReady()
RETURNS BIT
AS
BEGIN 
  DECLARE @NumParticles INT;
  
  SELECT @NumParticles = COUNT(1) FROM Accelerator.Particle;
  
  IF @NumParticles > 2
    RETURN 1;

  RETURN 0;
END;
GO


IF OBJECT_ID('Accelerator.GetParticlesInRectangle') IS NOT NULL DROP FUNCTION Accelerator.GetParticlesInRectangle;
GO

CREATE FUNCTION Accelerator.GetParticlesInRectangle(
  @X1 DECIMAL(10,2),
  @Y1 DECIMAL(10,2),
  @X2 DECIMAL(10,2),
  @Y2 DECIMAL(10,2)
)
RETURNS TABLE
AS RETURN (
  SELECT Id, X, Y, Value 
    FROM Accelerator.Particle
   WHERE X > @X1 AND X < @X2
         AND
         Y > @Y1 AND Y < @Y2
);
GO

IF OBJECT_ID('Accelerator.SendHiggsBosonDiscoveryEmail') IS NOT NULL DROP PROCEDURE Accelerator.SendHiggsBosonDiscoveryEmail;
GO

CREATE PROCEDURE Accelerator.SendHiggsBosonDiscoveryEmail
  @EmailAddress NVARCHAR(MAX)
AS
BEGIN
  RAISERROR('Not Implemented - yet',16,10);
END;
GO

IF OBJECT_ID('Accelerator.AlertParticleDiscovered') IS NOT NULL DROP PROCEDURE Accelerator.AlertParticleDiscovered;
GO

CREATE PROCEDURE Accelerator.AlertParticleDiscovered
  @ParticleDiscovered NVARCHAR(MAX)
AS
BEGIN
  IF @ParticleDiscovered = 'Higgs Boson'
  BEGIN
    EXEC Accelerator.SendHiggsBosonDiscoveryEmail 'particle-discovery@new-era-particles.tsqlt.org';
  END;
END;
GO

IF OBJECT_ID('Accelerator.GetStatusMessage') IS NOT NULL DROP FUNCTION Accelerator.GetStatusMessage;
GO

CREATE FUNCTION Accelerator.GetStatusMessage()
  RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @NumParticles INT;
  SELECT @NumParticles = COUNT(1) FROM Accelerator.Particle;
  RETURN 'The Accelerator is prepared with ' + CAST(@NumParticles AS NVARCHAR(MAX)) + ' particles.';
END;
GO

IF OBJECT_ID('Accelerator.FK_ParticleColor') IS NOT NULL ALTER TABLE Accelerator.Particle DROP CONSTRAINT FK_ParticleColor;
GO

ALTER TABLE Accelerator.Particle ADD CONSTRAINT FK_ParticleColor FOREIGN KEY (ColorId) REFERENCES Accelerator.Color(Id);
GO
/*
   Copyright 2011 tSQLt

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
EXEC tSQLt.NewTestClass 'AcceleratorTests';
GO

CREATE PROCEDURE 
  AcceleratorTests.[test ready for experimentation if 2 particles]
AS
BEGIN
  --Assemble: Fake the Particle table to make sure 
  --          it is empty and has no constraints
  EXEC tSQLt.FakeTable 'Accelerator.Particle';
  INSERT INTO Accelerator.Particle (Id) VALUES (1);
  INSERT INTO Accelerator.Particle (Id) VALUES (2);
  
  DECLARE @Ready BIT;
  
  --Act: Call the IsExperimentReady function
  SELECT @Ready = Accelerator.IsExperimentReady();
  
  --Assert: Check that 1 is returned from IsExperimentReady
  EXEC tSQLt.AssertEquals 1, @Ready;
  
END;
GO

CREATE PROCEDURE AcceleratorTests.[test we are not ready for experimentation if there is only 1 particle]
AS
BEGIN
  --Assemble: Fake the Particle table to make sure it is empty and has no constraints
  EXEC tSQLt.FakeTable 'Accelerator.Particle';
  INSERT INTO Accelerator.Particle (Id) VALUES (1);
  
  DECLARE @Ready BIT;
  
  --Act: Call the IsExperimentReady function
  SELECT @Ready = Accelerator.IsExperimentReady();
  
  --Assert: Check that 0 is returned from IsExperimentReady
  EXEC tSQLt.AssertEquals 0, @Ready;
  
END;
GO

CREATE PROCEDURE AcceleratorTests.[test no particles are in a rectangle when there are no particles in the table]
AS
BEGIN
  --Assemble: Fake the Particle table to make sure it is empty
  EXEC tSQLt.FakeTable 'Accelerator.Particle';

  DECLARE @ParticlesInRectangle INT;
  
  --Act: Call the  GetParticlesInRectangle Table-Valued Function and capture the number of rows it returns.
  SELECT @ParticlesInRectangle = COUNT(1)
    FROM Accelerator.GetParticlesInRectangle(0.0, 0.0, 1.0, 1.0);
  
  --Assert: Check that 0 rows were returned
  EXEC tSQLt.AssertEquals 0, @ParticlesInRectangle;
END;
GO

CREATE PROCEDURE AcceleratorTests.[test a particle within the rectangle is returned]
AS
BEGIN
  --Assemble: Fake the Particle table to make sure it is empty and that constraints will not be a problem
  EXEC tSQLt.FakeTable 'Accelerator.Particle';
  --          Put a test particle into the table
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES (1, 0.5, 0.5);
  
  --Act: Call the  GetParticlesInRectangle Table-Valued Function and capture the Id column into the #Actual temp table
  SELECT Id
    INTO #Actual
    FROM Accelerator.GetParticlesInRectangle(0.0, 0.0, 1.0, 1.0);
  
  --Assert: Create an empty #Expected temp table that has the same structure as the #Actual table
  SELECT TOP(0) *
    INTO #Expected
    FROM #Actual;
  
  --        A single row with an Id value of 1 is expected
  INSERT INTO #Expected (Id) VALUES (1);

  --        Compare the data in the #Expected and #Actual tables
  EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual';
END;
GO

CREATE PROCEDURE AcceleratorTests.[test a particle within the rectangle is returned with an Id, Point Location and Value]
AS
BEGIN
  --Assemble: Fake the Particle table to make sure it is empty and that constraints will not be a problem
  EXEC tSQLt.FakeTable 'Accelerator.Particle';
  --          Put a test particle into the table
  INSERT INTO Accelerator.Particle (Id, X, Y, Value) VALUES (1, 0.5, 0.5, 'MyValue');
  
  --Act: Call the  GetParticlesInRectangle Table-Valued Function and capture the relevant columns into the #Actual temp table
  SELECT Id, X, Y, Value
    INTO #Actual
    FROM Accelerator.GetParticlesInRectangle(0.0, 0.0, 1.0, 1.0);
    
  --Assert: Create an empty #Expected temp table that has the same structure as the #Actual table
  SELECT TOP(0) *
    INTO #Expected
    FROM #Actual;
    
  --        A single row with the expected data is inserted into the #Expected table
  INSERT INTO #Expected (Id, X, Y, Value) VALUES (1, 0.5, 0.5, 'MyValue');

  --        Compare the data in the #Expected and #Actual tables
  EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual';
END;
GO

CREATE PROCEDURE AcceleratorTests.[test a particle is included only if it fits inside the boundaries of the rectangle]
AS
BEGIN
  --Assemble: Fake the Particle table to make sure it is empty and that constraints will not be a problem
  EXEC tSQLt.FakeTable 'Accelerator.Particle';
  --          Populate the Particle table with rows that hug the rectangle boundaries
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES ( 1, -0.01,  0.50);
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES ( 2,  0.00,  0.50);
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES ( 3,  0.01,  0.50);
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES ( 4,  0.99,  0.50);
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES ( 5,  1.00,  0.50);
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES ( 6,  1.01,  0.50);
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES ( 7,  0.50, -0.01);
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES ( 8,  0.50,  0.00);
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES ( 9,  0.50,  0.01);
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES (10,  0.50,  0.99);
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES (11,  0.50,  1.00);
  INSERT INTO Accelerator.Particle (Id, X, Y) VALUES (12,  0.50,  1.01);
  
  --Act: Call the  GetParticlesInRectangle Table-Valued Function and capture the relevant columns into the #Actual temp table
  SELECT Id, X, Y
    INTO #Actual
    FROM Accelerator.GetParticlesInRectangle(0.0, 0.0, 1.0, 1.0);
    
  --Assert: Create an empty #Expected temp table that has the same structure as the #Actual table
  SELECT TOP(0) *
    INTO #Expected
    FROM #Actual;
    
  --        The expected data is inserted into the #Expected table
  INSERT INTO #Expected (Id, X, Y) VALUES (3,  0.01, 0.50);
  INSERT INTO #Expected (Id, X, Y) VALUES (4,  0.99, 0.50);
  INSERT INTO #Expected (Id, X, Y) VALUES (9,  0.50, 0.01);
  INSERT INTO #Expected (Id, X, Y) VALUES (10, 0.50, 0.99);
    
  --        Compare the data in the #Expected and #Actual tables
  EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual';
END;
GO

CREATE PROCEDURE AcceleratorTests.[test email is sent if we detected a higgs-boson]
AS
BEGIN
  --Assemble: Replace the SendHiggsBosonDiscoveryEmail with a spy. 
  EXEC tSQLt.SpyProcedure 'Accelerator.SendHiggsBosonDiscoveryEmail';
  
  --Act: Call the AlertParticleDiscovered procedure - this is the procedure being tested.
  EXEC Accelerator.AlertParticleDiscovered 'Higgs Boson';
  
  --Assert: A spy records the parameters passed to the procedure in a *_SpyProcedureLog table. 
  --        Copy the EmailAddress parameter values that the spy recorded into the #Actual temp table.
  SELECT EmailAddress
    INTO #Actual
    FROM Accelerator.SendHiggsBosonDiscoveryEmail_SpyProcedureLog;
    
  --        Create an empty #Expected temp table that has the same structure as the #Actual table
  SELECT TOP(0) * INTO #Expected FROM #Actual;
  
  --        Add a row to the #Expected table with the expected email address.
  INSERT INTO #Expected 
    (EmailAddress)
  VALUES 
    ('particle-discovery@new-era-particles.tsqlt.org');

  --        Compare the data in the #Expected and #Actual tables
  EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual';
END;
GO


CREATE PROCEDURE AcceleratorTests.[test email is not sent if we detected something other than higgs-boson]
AS
BEGIN
  --Assemble: Replace the SendHiggsBosonDiscoveryEmail with a spy. 
  EXEC tSQLt.SpyProcedure 'Accelerator.SendHiggsBosonDiscoveryEmail';
  
  --Act: Call the AlertParticleDiscovered procedure - this is the procedure being tested.
  EXEC Accelerator.AlertParticleDiscovered 'Proton';
  
  --Assert: A spy records the parameters passed to the procedure in a *_SpyProcedureLog table. 
  --        Copy the EmailAddress parameter values that the spy recorded into the #Actual temp table.
  SELECT EmailAddress
    INTO #Actual
    FROM Accelerator.SendHiggsBosonDiscoveryEmail_SpyProcedureLog;
    
  --        Create an empty #Expected temp table that has the same structure as the #Actual table
  SELECT TOP(0) * INTO #Expected FROM #Actual;
  
  --        The SendHiggsBosonDiscoveryEmail should not have been called. So the #Expected table is empty.
  
  --        Compare the data in the #Expected and #Actual tables
  EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual';

END;
GO

CREATE PROCEDURE AcceleratorTests.[test status message includes the number of particles]
AS
BEGIN
  --Assemble: Fake the Particle table to make sure it is empty and that constraints will not be a problem
  EXEC tSQLt.FakeTable 'Accelerator.Particle';
  --          Put 3 test particles into the table
  INSERT INTO Accelerator.Particle (Id) VALUES (1);
  INSERT INTO Accelerator.Particle (Id) VALUES (2);
  INSERT INTO Accelerator.Particle (Id) VALUES (3);

  --Act: Call the GetStatusMessageFunction
  DECLARE @StatusMessage NVARCHAR(MAX);
  SELECT @StatusMessage = Accelerator.GetStatusMessage();

  --Assert: Make sure the status message is correct
  EXEC tSQLt.AssertEqualsString 'The Accelerator is prepared with 3 particles.', @StatusMessage;
END;
GO

CREATE PROCEDURE AcceleratorTests.[test foreign key violated if Particle color is not in Color table]
AS
BEGIN
  --Assemble: Fake the Particle and the Color tables to make sure they are empty and other 
  --          constraints will not be a problem
  EXEC tSQLt.FakeTable 'Accelerator.Particle';
  EXEC tSQLt.FakeTable 'Accelerator.Color';
  --          Put the FK_ParticleColor foreign key constraint back onto the Particle table
  --          so we can test it.
  EXEC tSQLt.ApplyConstraint 'Accelerator.Particle', 'FK_ParticleColor';
  
  --Act: Attempt to insert a record into the Particle table without any records in Color table.
  --     We expect an exception to happen, so we capture the ERROR_MESSAGE()
  DECLARE @err NVARCHAR(MAX); SET @err = '<No Exception Thrown!>';
  BEGIN TRY
    INSERT INTO Accelerator.Particle (ColorId) VALUES (7);
  END TRY
  BEGIN CATCH
    SET @err = ERROR_MESSAGE();
  END CATCH
  
  --Assert: Check that trying to insert the record resulted in the FK_ParticleColor foreign key being violated.
  --        If no exception happened the value of @err is still '<No Exception Thrown>'.
  IF (@err NOT LIKE '%FK_ParticleColor%')
  BEGIN
    EXEC tSQLt.Fail 'Expected exception (FK_ParticleColor exception) not thrown. Instead:',@err;
  END;
END;
GO

CREATE PROC AcceleratorTests.[test foreign key is not violated if Particle color is in Color table]
AS
BEGIN
  --Assemble: Fake the Particle and the Color tables to make sure they are empty and other 
  --          constraints will not be a problem
  EXEC tSQLt.FakeTable 'Accelerator.Particle';
  EXEC tSQLt.FakeTable 'Accelerator.Color';
  --          Put the FK_ParticleColor foreign key constraint back onto the Particle table
  --          so we can test it.
  EXEC tSQLt.ApplyConstraint 'Accelerator.Particle', 'FK_ParticleColor';
  
  --          Insert a record into the Color table. We'll reference this Id again in the Act
  --          step.
  INSERT INTO Accelerator.Color (Id) VALUES (7);
  
  --Act: Attempt to insert a record into the Particle table.
  INSERT INTO Accelerator.Particle (ColorId) VALUES (7);
  
  --Assert: If any exception was thrown, the test will automatically fail. Therefore, the test
  --        passes as long as there was no exception. This is one of the VERY rare cases when
  --        at test case does not have an Assert step.
END
GO
