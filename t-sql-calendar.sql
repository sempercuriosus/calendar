\IF EXISTS (
		SELECT name
		FROM sys.objects
		WHERE object_id = object_id(N'Calendar')
		)

BEGIN
	DROP TABLE Calendar;
END;

DECLARE @StartDate DATE = '2000' + '01' + '01'
	,@EndDate DATE = '2100' + '12' + '31';

CREATE TABLE [Calendar] (
	[DateID] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY
	,[Name] [Varchar](35) NOT NULL DEFAULT('')
	,[DateValue] [date] NOT NULL UNIQUE
	,[Day] AS DAY(DateValue)
	,[Week] AS DATEPART(WEEK, DateValue)
	,[Month] AS MONTH(DateValue)
	,[MonthWeek] AS ((DAY(DateValue) - 1) / 7 + 1)
	,[Year] AS YEAR(DateValue)
	,[DayOfWeek] AS DATEPART(WEEKDAY, DateValue)
	,[IsUSHoliday] [bit] NOT NULL DEFAULT((0))
	,[IsUSEnabled] [bit] NOT NULL DEFAULT((0))
	);
	-- End Create [Calendar]
	-- Tally Table CTE
	-- Ben-Gan 
	;

WITH N10 (n)
AS (
	SELECT 1
	FROM (
		VALUES (0)
			,(1)
			,(2)
			,(3)
			,(4)
			,(5)
			,(6)
			,(7)
			,(8)
			,(9)
		) v(n)
	)
	,N100 (n)
AS (
	SELECT 1
	FROM N10
		,N10 n
	)
	,N10000 (n)
AS (
	SELECT 1
	FROM N100
		,N100 n
	)
	,N100000 (n)
AS (
	SELECT 1
	FROM N100
		,N10000 n
	)
	--, N1000000(n) AS (SELECT 1 FROM N10000, N100000 n)
	,N
AS (
	SELECT TOP (DATEDIFF(DAY, @startdate, @enddate) + 1) n = ROW_NUMBER() OVER (
			ORDER BY (
					SELECT NULL
					)
			) - 1
	FROM N100000
	)
INSERT INTO [Calendar] (DateValue)
SELECT InsertDate
FROM N
CROSS APPLY (
	SELECT DATEADD(DAY, n, @Startdate)
	) d(InsertDate);

-- =======================================================================================
-- ===== UNITED STATES HOLIDAY LIST
-- =======================================================================================
-- ======================
-- == January
-- ======================
-- ===== US New Years Day
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'New Year''s Day'
	,[IsUSEnabled] = 1
FROM [Calendar]
WHERE [Day] = 1
	AND [Week] = 1
	AND [MonthWeek] = 1
	AND [Month] = 1;

-- ===== Dr. MLK Jr. Day
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'Dr. Martin Luther King Jr. Day'
WHERE [Month] = 1
	AND [MonthWeek] = 3
	AND [DayOfWeek] = 2;

-- ======================
-- == February
-- ======================
-- ===== US Valentine's Day
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'Valentine''s Day'
WHERE [Day] = 14
	AND [MonthWeek] = 2
	AND [Month] = 2;

-- ===== Presidents' Day
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'Presidents'' Day'
WHERE [Month] = 2
	AND [DayOfWeek] = 2
	AND [MonthWeek] = 3;

-- ======================
-- == March
-- ======================
-- ======================
-- == April
-- ======================
UPDATE [Calendar]
SET IsUSHoliday = 1
	,IsCanadianHoliday = 1
	,[Name] = 'Easter Sunday'
FROM [Calendar] AS dimdate
CROSS APPLY (
	SELECT year AS [cur_year]
	) _y
CROSS APPLY (
	SELECT [cur_year] / 100 AS [c]
		,[cur_year] - 19 * ([cur_year] / 19) AS n
	) _nc
CROSS APPLY (
	SELECT ([c] - 17) / 25 AS k
	) _k
CROSS APPLY (
	SELECT [c] - [c] / 4 - ([c] - k) / 3 + 19 * n + 15 AS i1
	) _i1
CROSS APPLY (
	SELECT i1 - 30 * (i1 / 30) AS i2
	) _i2
CROSS APPLY (
	SELECT i2 - (i2 / 28) * (1 - (i2 / 28) * (29 / (i2 + 1)) * ((21 - n) / 11)) AS i
	) _i
CROSS APPLY (
	SELECT [cur_year] + [cur_year] / 4 + i + 2 - [c] + [c] / 4 AS j1
	) _j1
CROSS APPLY (
	SELECT j1 - 7 * (j1 / 7) AS j
	) _j
CROSS APPLY (
	SELECT i - j AS el
	) _el
CROSS APPLY (
	SELECT 3 + (el + 40) / 44 AS [cur_month]
	) _m
CROSS APPLY (
	SELECT el + 28 - 31 * ([cur_month] / 4) AS [cur_day]
	) _d
CROSS APPLY (
	SELECT DATEFROMPARTS([cur_year], [cur_month], [cur_day]) AS EasterSunday
	) _Easter
WHERE DateValue = EasterSunday

-- ======================
-- == May
-- ======================
-- ===== Memorial Day
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'Memorial Day'
WHERE DateID IN (
		SELECT max(DateID)
		FROM [Calendar] c2
		WHERE c2.[Month] = 5
			AND c2.[DayOfWeek] = 2
		GROUP BY [Year]
		);

-- ======================
-- == June
-- ======================
-- ======================
-- == July
-- ======================
-- ===== Independence Day
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'Independence Day'
	,[IsUSEnabled] = 1
WHERE [Month] = 7
	AND [Day] = 4;

-- ======================
-- == August
-- ======================
-- ======================
-- == September
-- ======================
-- ===== Labor Day
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'Labor Day'
	,[IsUSEnabled] = 1
WHERE [Month] = 9
	AND [MonthWeek] = 1
	AND [DayOfWeek] = 2

-- ======================
-- == October
-- ======================
-- ===== Columbus Day
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'Columbus Day'
WHERE [Month] = 10
	AND [MonthWeek] = 2
	AND [DayOfWeek] = 2

UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'Halloween'
WHERE [Month] = 10
	AND [Month] = 10
	AND [Day] = 31

-- ======================
-- == November
-- ======================
-- ===== Veteran's Day
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'Veteran''s Day'
WHERE [Month] = 11
	AND [Day] = 11

-- ===== Thanksgiving Day
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'Thanksgiving Day'
	,[IsUSEnabled] = 1
WHERE [Month] = 11
	AND [MonthWeek] = 4
	AND [DayOfWeek] = 5

-- ======================
-- == December
-- ======================
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'Christmas Eve'
WHERE [Month] = 12
	AND [Day] = 24

-- ===== Christmas Day
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'Christmas Day'
	,[IsUSEnabled] = 1
WHERE [Month] = 12
	AND [Day] = 25

-- ===== New Year's Eve
UPDATE [Calendar]
SET IsUSHoliday = 1
	,[Name] = 'New Year''s Eve'
WHERE [Month] = 12
	AND [Day] = 31
	-- =======================================================================================
	-- ===== UNITED STATES HOLIDAY LIST END
	-- =======================================================================================