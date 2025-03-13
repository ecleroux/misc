DECLARE @T TABLE ( DG INT, PDG INT)

INSERT INTO @T VALUES
(2,1),
(5,2),
(6,2),
(3,1),
(7,6),
(7,3),
(7,2),
(4,1),
(8,7),
(8,4),
(9,4)--,
--(11,10),
--(12,10),
--(13,11),
--(14,11),
--(15,14),
--(15,12)








;WITH RCTE AS
(
    SELECT  DG, PDG, 1 AS Lvl FROM @T 

    UNION ALL

    SELECT rc.DG, rh.PDG, Lvl+1 AS Lvl 
    FROM @T rh
    INNER JOIN RCTE rc 
		ON rh.DG = rc.PDG
)
--,CTE_RN AS 
--(
--    SELECT *, ROW_NUMBER() OVER (PARTITION BY r.DG ORDER BY r.Lvl DESC) RN
--    FROM RCTE r

--)

SELECT PDG, MAX([Lvl])
FROM RCTE
GROUP BY PDG
ORDER BY MAX([Lvl]) DESC

--SELECT t.PDG, MAX(RN) 
--FROM CTE_RN r
--INNER JOIN @T t
--	ON r.DG = t.DG
--GROUP BY t.PDG
--ORDER BY MAX(RN) 