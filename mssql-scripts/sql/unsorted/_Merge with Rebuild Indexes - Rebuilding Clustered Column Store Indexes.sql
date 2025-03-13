USE [master]
GO

DECLARE @CCSI TABLE ([SchemaName] NVARCHAR(128), [TableName] NVARCHAR(128), [IndexName] NVARCHAR(128))

DECLARE @DBName NVARCHAR(128)
		,@IndexName NVARCHAR(500)
		,@SchemaName NVARCHAR(128)
		,@TableName NVARCHAR(128)
		,@SQL NVARCHAR(MAX)
		,@Param NVARCHAR(MAX)

DECLARE DB_Cur CURSOR FAST_FORWARD READ_ONLY FOR	SELECT [name]
													FROM [sys].[databases]
													WHERE [name] IN ('Conexus_Warehouse','Compass')
													ORDER BY [name]

OPEN DB_Cur FETCH NEXT FROM DB_Cur INTO @DBName

WHILE @@FETCH_STATUS = 0
BEGIN
    
	PRINT 'Get CCSI List from ' + @DBName
	
	DELETE FROM @CCSI

	SET @SQL = 'SELECT OBJECT_SCHEMA_NAME([object_id])
						,OBJECT_NAME([object_id])
						,[name]
				FROM [' + @DBName + '].[sys].[indexes]
				WHERE [is_hypothetical] = 0
				AND	  [index_id] <> 0
				AND	  [type_desc] IN (''CLUSTERED COLUMNSTORE'')'

	INSERT INTO @CCSI
	EXECUTE [sys].[sp_executesql] @SQL

	DECLARE CCSI_Cur CURSOR FAST_FORWARD READ_ONLY FOR SELECT [SchemaName], [TableName], [IndexName] FROM @CCSI

	OPEN CCSI_Cur FETCH NEXT FROM CCSI_Cur INTO @SchemaName, @TableName, @IndexName

	WHILE @@FETCH_STATUS = 0
	BEGIN
    
		PRINT 'Rebuild CCSI: ' + @IndexName

		SET @SQL = 'ALTER INDEX [' + @IndexName + '] ON [' + @SchemaName + '].[' + @TableName + '] REORGANIZE WITH ( COMPRESS_ALL_ROW_GROUPS = ON );'
		EXECUTE [sys].[sp_executesql] @SQL

		SET @SQL = 'ALTER INDEX [' + @IndexName + '] ON [' + @SchemaName + '].[' + @TableName + '] REORGANIZE;'
		EXECUTE [sys].[sp_executesql] @SQL

		FETCH NEXT FROM CCSI_Cur INTO @SchemaName, @TableName, @IndexName
	END

	CLOSE CCSI_Cur
	DEALLOCATE CCSI_Cur

    FETCH NEXT FROM DB_Cur INTO @DBName
END

CLOSE DB_Cur
DEALLOCATE DB_Cur


/*
--CCSI Status

USE [Compass]
GO

SELECT [i].[object_id]
         ,OBJECT_NAME([i].[object_id]) AS 'TableName'
         ,[i].[name] AS 'IndexName'
         ,[i].[index_id]
         ,[i].[type_desc]
         ,[CSRowGroups].*
         ,100 * ( [CSRowGroups].[total_rows] - ISNULL([CSRowGroups].[deleted_rows], 0)) / [CSRowGroups].[total_rows] AS 'PercentFull'
FROM [sys].[indexes] AS [i]
JOIN [sys].[column_store_row_groups] AS [CSRowGroups]
       ON     [i].[object_id] = [CSRowGroups].[object_id]
       AND [i].[index_id] = [CSRowGroups].[index_id]
--WHERE object_name(i.object_id) = '<table_name>'   
ORDER BY OBJECT_NAME([i].[object_id])
              ,[i].[name]
              ,[CSRowGroups].[row_group_id];


*/