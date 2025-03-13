SELECT FeedId, FeedLogId = CAST(FeedLogId AS VARCHAR(1000)) + '.'
FROM Audit.FeedLog
GROUP BY FeedId



SELECT T1.FeedId,   
        STUFF(  
        (  
        SELECT ',' + CAST(FeedLogId AS VARCHAR(1000))  
        FROM Audit.FeedLog T2  
        WHERE T1.FeedId = T2.FeedId 
		ORDER BY T2.FeedLogId
        FOR XML PATH ('')  
        ),1,1,'')  
FROM Audit.FeedLog T1 
GROUP BY T1.FeedId
ORDER BY T1.FeedId