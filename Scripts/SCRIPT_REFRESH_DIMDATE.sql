USE AdventureWorksDW
GO
CREATE OR ALTER FUNCTION [dbo].[DateToDateId]
(
  @Date DATETIME
)
RETURNS INT
AS
BEGIN

  DECLARE @DateId  AS INT
  DECLARE @TodayId AS INT

  SET @TodayId = YEAR(GETDATE()) * 10000
               + MONTH(GETDATE()) * 100
               + DAY(GETDATE())         

  -- If the date is missing, or a placeholder for a missing date, set to the Id for missing dates
  -- Else convert the date to an integer
  IF @Date IS NULL OR @Date = '1900-01-01' OR @Date = -1
    SET @DateId = -1  
  ELSE
    BEGIN
      SET @DateId = YEAR(@Date) * 10000
                  + MONTH(@Date) * 100
                  + DAY(@Date)         
    END  
  -- If there's any data prior to 2000 it was incorrectly entered, mark it as missing
  IF @DateId BETWEEN 0 AND 19991231 
    SET @DateId = -1
  -- Commented out for this project as future dates are OK
  -- If the date is in the future, don't allow it, change to missing
  -- IF @DateId > @TodayId 
  --   SET @DateId = -1
  RETURN @DateId
END
GO

/*-----------------------------------------------------------------------------------------------*/
/* Step 3. Add new dates to the dbo.DimDate table.                                               */
/*-----------------------------------------------------------------------------------------------*/
PRINT 'Adding new dates to dbo.DimDate'
GO

SET NOCOUNT ON

-- Later we will be writing an INSERT INTO... SELECT FROM to insert the new record. I want to 
-- join the day and month name memory variable tables, but need to have something to join to. 
-- Since everything is calculated, we'll just create this little bogus table to have something
-- to select from.
DECLARE @BogusTable TABLE
  ( PK TINYINT)

INSERT INTO @BogusTable SELECT 1;


-- Create a table variable to hold the days of the week with their various language versions
DECLARE @DayNameTable TABLE
  ( [DayNumberOFWeek]      TINYINT
  , [EnglishDayNameOfWeek] NVARCHAR(10)
  , [SpanishDayNameOfWeek] NVARCHAR(10)
  , [FrenchDayNameOfWeek]  NVARCHAR(10)
  )

INSERT INTO @DayNameTable
SELECT DISTINCT 
       [DayNumberOFWeek]      
     , [EnglishDayNameOfWeek] 
     , [SpanishDayNameOfWeek] 
     , [FrenchDayNameOfWeek]  
  FROM dbo.DimDate

-- Create a month table to hold the months and their language versions.
DECLARE @MonthNameTable TABLE
  ( [MonthNumberOfYear] TINYINT
  , [EnglishMonthName]  NVARCHAR(10)
  , [SpanishMonthName]  NVARCHAR(10)
  , [FrenchMonthName]   NVARCHAR(10)
  )

INSERT INTO @MonthNameTable
SELECT DISTINCT
       [MonthNumberOfYear] 
     , [EnglishMonthName]  
     , [SpanishMonthName]  
     , [FrenchMonthName]   
  FROM dbo.DimDate

-- This is the start and end date ranges to use to populate the 
-- dbo.DimDate dimension. Change if it's 2014 and you run across this script.
DECLARE @FromDate AS DATE = '2020-01-01'
DECLARE @ThruDate AS DATE = '2020-12-31'

-- CurrentDate will be incremented each time through the loop below.
DECLARE @CurrentDate AS DATE
SET @CurrentDate = @FromDate

-- FiscalDate will be set six months into the future from the CurrentDate
DECLARE @FiscalDate  AS DATE

-- Now we simply loop over every date between the From and Thru, inserting the
-- calculated values into DimDate.
WHILE @CurrentDate <= @ThruDate
BEGIN

  SET @FiscalDate = DATEADD(m, 6, @CurrentDate)

  INSERT INTO dbo.DimDate
  SELECT [dbo].[DateToDateId](@CurrentDate)
       , @CurrentDate
       , DATEPART(dw, @CurrentDate) AS DayNumberOFWeek
       , d.EnglishDayNameOfWeek
       , d.SpanishDayNameOfWeek
       , d.FrenchDayNameOfWeek
       , DAY(@CurrentDate) AS DayNumberOfMonth
       , DATEPART(dy, @CurrentDate) AS DayNumberOfYear
       , DATEPART(wk, @CurrentDate) AS WeekNumberOfYear
       , m.EnglishMonthName
       , m.SpanishMonthName
       , m.FrenchMonthName
       , MONTH(@CurrentDate) AS MonthNumberOfYear
       , DATEPART(q, @CurrentDate) AS CalendarQuarter
       , YEAR(@CurrentDate) AS CalendarYear
       , IIF(MONTH(@CurrentDate) < 7, 1, 2) AS CalendarSemester
       , DATEPART(q, @FiscalDate) AS FiscalQuarter
       , YEAR(@FiscalDate) AS FiscalYear
       , IIF(MONTH(@FiscalDate) < 7, 1, 2) AS FiscalSemester
    FROM @BogusTable
    JOIN @DayNameTable d
      ON DATEPART(dw, @CurrentDate) = d.[DayNumberOFWeek]
    JOIN @MonthNameTable m
      ON MONTH(@CurrentDate) = m.MonthNumberOfYear

  SET @CurrentDate = DATEADD(d, 1, @CurrentDate)
END
GO

-- If you want to verify you can uncomment this line.
-- SELECT * FROM dbo.DimDate WHERE DateKey > 20110000

PRINT 'Done adding new dates to dbo.DimDate'
GO
