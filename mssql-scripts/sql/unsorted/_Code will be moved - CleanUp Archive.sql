
DECLARE @TableName VARCHAR(255)
			,@SQLString NVARCHAR(MAX)
			,@ParmDefinition NVARCHAR(1000)
			,@StartDate DATE

SET @StartDate = '2017-08-01'

PRINT '----------Conexus_Archive------------'

DECLARE CurTT CURSOR FAST_FORWARD READ_ONLY FOR 
			SELECT '[Conexus_Archive].[' + TABLE_SCHEMA + '].[' + TABLE_NAME + ']' AS TableName
FROM [Conexus_Archive].INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
	AND TABLE_SCHEMA = 'Staging'

OPEN CurTT
FETCH NEXT FROM CurTT INTO @TableName

WHILE @@Fetch_Status = 0
	BEGIN

	PRINT 'Cleaning ' + @TableName

	SET @SQLString = 'DECLARE @r INT;
SET @r = 1;
WHILE @r > 0
BEGIN
DELETE TOP (100000) D FROM ' + @TableName + ' D
INNER JOIN [Conexus_Metadata].[Audit].[FeedLog] FL
ON D.[FeedLogId] = FL.[FeedLogId]
WHERE FL.COBDate < @StartDate
SET @R = @@ROWCOUNT;
END'

	SET @ParmDefinition = '@StartDate DATE'

	--PRINT @SQLString;
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @StartDate = @StartDate

	PRINT 'Cleaning ' + @TableName + ' Done'

	FETCH NEXT FROM CurTT INTO @TableName
END

CLOSE CurTT
DEALLOCATE CurTT

/*

USE [Conexus_Archive]
GO

DECLARE @TableName VARCHAR(255)
		,@SQLString NVARCHAR(MAX)

DECLARE CurTT CURSOR FAST_FORWARD READ_ONLY FOR 
		SELECT '[' + TABLE_SCHEMA + '].[' + TABLE_NAME + ']' AS TableName
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_TYPE = 'BASE TABLE'
		AND TABLE_SCHEMA = 'Staging'

OPEN CurTT FETCH NEXT FROM CurTT INTO @TableName

WHILE @@Fetch_Status = 0
BEGIN
		
PRINT 'Compressing ' + @TableName

SET @SQLString = 'ALTER TABLE ' + @TableName + ' REBUILD PARTITION = ALL  
WITH (DATA_COMPRESSION = PAGE)'

--PRINT @SQLString;
EXECUTE sp_executesql @SQLString

PRINT 'Compressing ' + @TableName + ' Done'

FETCH NEXT FROM CurTT INTO @TableName
END

CLOSE CurTT
DEALLOCATE CurTT

*/