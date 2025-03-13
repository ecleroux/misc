--TODO: Clean up and make reuseable, add commentary as well

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
--WHERE [CSRowGroups].deleted_rows <> 0
ORDER BY OBJECT_NAME([i].[object_id])
              ,[i].[name]
              ,[CSRowGroups].[row_group_id];


ALTER INDEX [CCSIDX_FactCreditRatingModel_COBDateId] ON [DataWarehouse].[FactCreditRatingModel] REORGANIZE WITH ( COMPRESS_ALL_ROW_GROUPS = ON );
ALTER INDEX [CCSIDX_FactCreditRatingModel_COBDateId] ON [DataWarehouse].[FactCreditRatingModel] REORGANIZE;