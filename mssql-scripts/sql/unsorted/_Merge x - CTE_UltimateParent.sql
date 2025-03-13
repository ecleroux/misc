DECLARE @T TABLE ( Cust VARCHAR(50), ParentCust VARCHAR(50))

INSERT INTO @T VALUES
('001', '001'),
('002', '001'),
('003', '002'),
('004', '003'),
('005', '006'),
('006', '002'),
('011', '011'),
('012', '011'),
('013', '012'),
('014', '013'),
('015', '013');


;WITH RCTE AS
(
    SELECT  Cust, ParentCust, 1 AS Lvl FROM @T 

    UNION ALL

    SELECT rc.Cust, rh.ParentCust, Lvl+1 AS Lvl 
    FROM @T rh
    INNER JOIN RCTE rc 
		ON rh.Cust = rc.ParentCust
	WHERE rh.Cust <> rh.ParentCust
)
,CTE_RN AS 
(
    SELECT *, ROW_NUMBER() OVER (PARTITION BY r.Cust ORDER BY r.Lvl DESC) RN
    FROM RCTE r

)
SELECT t.Cust, t.ParentCust, r.ParentCust AS UltimateParent
FROM CTE_RN r
INNER JOIN @T t
	ON r.Cust = t.Cust
WHERE RN =1