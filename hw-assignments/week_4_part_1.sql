-- Which sites have no egg data?

-- Code not in
SELECT Code FROM Site
    WHERE Code NOT IN (SELECT DISTINCT Site FROM Bird_eggs)
    ORDER BY Code;

-- With an outer join 

SELECT Code
FROM Site 
LEFT JOIN Bird_eggs ON Code = Site
WHERE Site IS NULL
ORDER BY Code;

