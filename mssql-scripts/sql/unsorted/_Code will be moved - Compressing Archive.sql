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



   