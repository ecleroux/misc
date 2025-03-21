/*****************************
This will generate a script that will drop all foreign keys, truncate all the tables and recreate the foreign keys

Use the following query to check what table will be truncated. If tables need to be excluded, update [Truncate all Tables] section appropriately
It excludes tSQLt and DeploymentMetadata

SELECT * FROM [INFORMATION_SCHEMA].[TABLES] 
WHERE [TABLE_TYPE] = 'BASE TABLE'
AND [TABLE_SCHEMA] NOT IN ('tSQLt')
AND [TABLE_NAME] NOT IN ('DeploymentMetadata')
ORDER BY [TABLE_SCHEMA], [TABLE_NAME]

*****************************/

USE [TruncateDBName]
GO

DECLARE @ForeignKeyConstraintName NVARCHAR(500)
		,@SchemaName NVARCHAR(128)
		,@TableName NVARCHAR(128)
		,@ColumnName NVARCHAR(128)
		,@ReferencedSchemaName NVARCHAR(128)
		,@ReferencedTableName NVARCHAR(128)
		,@ReferencedColumnName NVARCHAR(128)
		,@Truncate NVARCHAR(1000)
		,@DBName NVARCHAR(128) = DB_NAME()

/*************************************
	Drop All FK Constraints
*************************************/
PRINT '--Drop All FK Constraints'
PRINT ''

DECLARE cursorFKDrop CURSOR FAST_FORWARD READ_ONLY FOR 
	SELECT [obj].[name] AS 'ForeignKeyConstraintName'
		  ,[sch1].[name] AS 'SchemaName'
		  ,[tab1].[name] AS 'TableName'
		  ,[col1].[name] AS 'ColumnName'
		  ,[sch2].[name] AS 'ReferencedSchemaName'
		  ,[tab2].[name] AS 'ReferencedTableName'
		  ,[col2].[name] AS 'ReferencedColumnName'
	FROM [sys].[foreign_key_columns] [fkc]
	INNER JOIN [sys].[objects] [obj]
		ON [obj].[object_id] = [fkc].[constraint_object_id]
	INNER JOIN [sys].[tables] [tab1]
		ON [tab1].[object_id] = [fkc].[parent_object_id]
	INNER JOIN [sys].[schemas] [sch1]
		ON [tab1].[schema_id] = [sch1].[schema_id]
	INNER JOIN [sys].[columns] [col1]
		ON	[col1].[column_id] = [fkc].[parent_column_id]
		AND [col1].[object_id] = [tab1].[object_id]
	INNER JOIN [sys].[tables] [tab2]
		ON [tab2].[object_id] = [fkc].[referenced_object_id]
	INNER JOIN [sys].[columns] [col2]
		ON	[col2].[column_id] = [fkc].[referenced_column_id]
		AND [col2].[object_id] = [tab2].[object_id]
	INNER JOIN [sys].[schemas] [sch2]
		ON [tab2].[schema_id] = [sch2].[schema_id]
	
OPEN cursorFKDrop FETCH NEXT FROM cursorFKDrop INTO @ForeignKeyConstraintName
												,@SchemaName
												,@TableName
												,@ColumnName
												,@ReferencedSchemaName
												,@ReferencedTableName
												,@ReferencedColumnName 
	
WHILE @@FETCH_STATUS = 0
BEGIN
	    
	PRINT 'ALTER TABLE [' + @DBName + '].[' + @SchemaName + '].[' + @TableName + '] DROP CONSTRAINT IF EXISTS [' + @ForeignKeyConstraintName +']'
	PRINT 'GO'
	PRINT ''

	FETCH NEXT FROM cursorFKDrop INTO @ForeignKeyConstraintName
									,@SchemaName
									,@TableName
									,@ColumnName
									,@ReferencedSchemaName
									,@ReferencedTableName
									,@ReferencedColumnName 
END
	
CLOSE cursorFKDrop
DEALLOCATE cursorFKDrop

/*************************************
	Truncate all Tables
*************************************/
PRINT '--Truncate all Tables'
PRINT ''
	
DECLARE cursorTruncate CURSOR FAST_FORWARD READ_ONLY FOR	
	SELECT 'TRUNCATE TABLE [' + @DBName + '].[' + [TABLE_SCHEMA] + '].[' + [TABLE_NAME] + ']'
	FROM [INFORMATION_SCHEMA].[TABLES]
	WHERE [TABLE_TYPE] = 'BASE TABLE'
	AND [TABLE_SCHEMA] NOT IN ('tSQLt')
	AND [TABLE_NAME] NOT IN ('DeploymentMetadata')
	ORDER BY [TABLE_SCHEMA], [TABLE_NAME]
	
OPEN cursorTruncate
	
FETCH NEXT FROM cursorTruncate INTO @Truncate
	
WHILE @@FETCH_STATUS = 0
BEGIN
	    
	PRINT @Truncate
	
	FETCH NEXT FROM cursorTruncate INTO @Truncate
END
	
CLOSE cursorTruncate
DEALLOCATE cursorTruncate
PRINT ''
	
/*************************************
	Create All FK Constraints
*************************************/
PRINT '--Create All FK Constraints'
PRINT ''
DECLARE cursorFKCreate CURSOR FAST_FORWARD READ_ONLY FOR 
	SELECT [obj].[name] AS 'ForeignKeyConstraintName'
		  ,[sch1].[name] AS 'SchemaName'
		  ,[tab1].[name] AS 'TableName'
		  ,[col1].[name] AS 'ColumnName'
		  ,[sch2].[name] AS 'ReferencedSchemaName'
		  ,[tab2].[name] AS 'ReferencedTableName'
		  ,[col2].[name] AS 'ReferencedColumnName'
	FROM [sys].[foreign_key_columns] [fkc]
	INNER JOIN [sys].[objects] [obj]
		ON [obj].[object_id] = [fkc].[constraint_object_id]
	INNER JOIN [sys].[tables] [tab1]
		ON [tab1].[object_id] = [fkc].[parent_object_id]
	INNER JOIN [sys].[schemas] [sch1]
		ON [tab1].[schema_id] = [sch1].[schema_id]
	INNER JOIN [sys].[columns] [col1]
		ON	[col1].[column_id] = [fkc].[parent_column_id]
		AND [col1].[object_id] = [tab1].[object_id]
	INNER JOIN [sys].[tables] [tab2]
		ON [tab2].[object_id] = [fkc].[referenced_object_id]
	INNER JOIN [sys].[columns] [col2]
		ON	[col2].[column_id] = [fkc].[referenced_column_id]
		AND [col2].[object_id] = [tab2].[object_id]
	INNER JOIN [sys].[schemas] [sch2]
		ON [tab2].[schema_id] = [sch2].[schema_id]
	
OPEN cursorFKCreate FETCH NEXT FROM cursorFKCreate INTO @ForeignKeyConstraintName
												,@SchemaName
												,@TableName
												,@ColumnName
												,@ReferencedSchemaName
												,@ReferencedTableName
												,@ReferencedColumnName 
	
WHILE @@FETCH_STATUS = 0
BEGIN
	    
	PRINT 'ALTER TABLE [' + @DBName + '].[' + @SchemaName + '].[' + @TableName + ']  WITH CHECK ADD  CONSTRAINT [' + @ForeignKeyConstraintName +'] FOREIGN KEY([' + @ColumnName +'])
REFERENCES [' + @ReferencedSchemaName + '].[' + @ReferencedTableName + '] ([' + @ReferencedColumnName +'])'
	PRINT 'GO'
	PRINT ''
	PRINT 'ALTER TABLE [' + @DBName + '].[' + @SchemaName + '].[' + @TableName + '] CHECK CONSTRAINT [' + @ForeignKeyConstraintName +']'
	PRINT 'GO'
	PRINT ''

	FETCH NEXT FROM cursorFKCreate INTO @ForeignKeyConstraintName
									,@SchemaName
									,@TableName
									,@ColumnName
									,@ReferencedSchemaName
									,@ReferencedTableName
									,@ReferencedColumnName 
END
	
CLOSE cursorFKCreate
DEALLOCATE cursorFKCreate