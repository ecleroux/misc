CREATE TABLE #T (CustId INT,ParentCustId INT, Hierarchy INT, CustRollPerc INT, Val VARCHAR(10))

INSERT INTO [#T] (
	[CustId]
	,[ParentCustId]
	,[Hierarchy]
	,[CustRollPerc]
	,[Val]
)
SELECT 1, 5, 1, 0	,'' UNION ALL
SELECT 1, 4, 2, 0	,'' UNION ALL
SELECT 1, 3, 3, 100 ,'SB18' UNION ALL
SELECT 1, 2, 4, 100 ,'SB16' UNION ALL
SELECT 1, 1, 5, 100 ,'ML' UNION ALL

SELECT 10, 50, 1, 0	,'' UNION ALL
SELECT 10, 40, 2, 0	,'' UNION ALL
SELECT 10, 30, 3, 100 ,'SB18' UNION ALL
SELECT 10, 20, 4, 0 ,'SB16' UNION ALL
SELECT 10, 10, 5, 100 ,'ML' UNION ALL

SELECT 100, 500, 1, 0	,'' UNION ALL
SELECT 100, 400, 2, 0	,'' UNION ALL
SELECT 100, 300, 3, 100 ,'SB18' UNION ALL
SELECT 100, 200, 4, 100 ,'ML' UNION ALL
SELECT 100, 100, 5, 100 ,'ML' UNION ALL

SELECT 1000, 5000, 1, 100,'ML' UNION ALL
SELECT 1000, 4000, 2, 100	,'ML' UNION ALL
SELECT 1000, 3000, 3, 100 ,'ML' UNION ALL
SELECT 1000, 2000, 4, 100 ,'ML' UNION ALL
SELECT 1000, 1000, 5, 100 ,'ML' UNION ALL

SELECT 1001, 5001, 1, 100,'ML' UNION ALL
SELECT 1001, 4001, 2, 100	,'ML' UNION ALL
SELECT 1001, 3001, 3, 100 ,'ML' UNION ALL
SELECT 1001, 2001, 4, 100 ,'SB19' UNION ALL
SELECT 1001, 1001, 5, 100 ,'SB18' UNION ALL

SELECT 1002, 5002, 1, 0,'ML' UNION ALL
SELECT 1002, 4002, 2, 0	,'ML' UNION ALL
SELECT 1002, 3002, 3, 100 ,'SB20' UNION ALL
SELECT 1002, 2002, 4, 0 ,'ML' UNION ALL
SELECT 1002, 1002, 5, 100 ,'ML';

WITH cte_name AS
(
	SELECT [CustId],[ParentCustId],[Hierarchy],[CustRollPerc],[Val]
	FROM [#T] T1
	WHERE [CustId] = [ParentCustId]
	UNION ALL
	SELECT T2.[CustId],T2.[ParentCustId],T2.[Hierarchy],T2.[CustRollPerc],T2.[Val]
	FROM [#T] T2
	INNER JOIN cte_name
		ON T2.[CustId] = cte_name.[CustId]
		AND T2.[Hierarchy] = (cte_name.[Hierarchy] - 1)
	WHERE cte_name.[CustRollPerc] = 100
)

SELECT [M].[CustId]
	  ,[M].[ParentCustId]
	  ,[M].[Hierarchy]
	  ,[M].[CustRollPerc]
	  ,ISNULL(P.[Val], [M].[Val]) AS Val
FROM [#T] M
LEFT OUTER JOIN (SELECT [#T].[CustId]
					   ,[#T].[ParentCustId]
					   ,[#T].[Hierarchy]
					   ,[#T].[CustRollPerc]
					   ,[#T].[Val]
					FROM
					(	SELECT [cte_name].[CustId]
							  ,MAX([cte_name].[Hierarchy]) AS 'Hierarchy'
						FROM [cte_name]
						WHERE [cte_name].[Val] <> 'ML'
						GROUP BY [cte_name].[CustId] ) [cte]
					INNER JOIN [#T]
						ON	[#T].[CustId] = [cte].[CustId]
						AND [#T].[Hierarchy] = [cte].[Hierarchy]) P
 ON [P].[CustId] = M.[CustId]
WHERE M.[CustId] = M.[ParentCustId]


DROP TABLE [#T]