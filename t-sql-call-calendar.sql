SELECT
    dbo.udf_DateIsHoliday (CONVERT(VARCHAR(10), getdate (), 110), 'usa')
;