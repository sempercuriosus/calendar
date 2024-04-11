CREATE FUNCTION udf_DateIsHoliday (
	@date_checked VARCHAR(20)
	,@country VARCHAR(20)
	)
RETURNS BIT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result BIT

	-- ===== USA Holida Check
	IF (upper(@country) = 'USA')
	BEGIN
		SELECT @Result = isnull((
					SELECT cast(1 AS BIT)
					FROM [dbo].[Calendar]
					WHERE [IsUSEnabled] = 1
						AND [IsUSHoliday] = 1
						AND [DateValue] = cast(@date_checked AS SMALLDATETIME)
					), 0);
	END;
			-- ===== Canadian Holiday Check
	ELSE IF (upper(@country) = 'CANADA')
	BEGIN
		SELECT @Result = isnull((
					SELECT cast(1 AS BIT)
					FROM [dbo].[Calendar]
					WHERE [IsCanadianEnabled] = 1
						AND [IsCanadianHoliday] = 1
						AND [DateValue] = cast(@date_checked AS SMALLDATETIME)
					), 0);
	END;
	ELSE
	BEGIN
		SET @Result = 0;
	END;

	-- Return the result of the function
	RETURN @Result
END
GO

