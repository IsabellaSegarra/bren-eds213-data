-- Find all pairs of people who worked at the same site (overlapping date ranges)

-- Step 1:
SELECT * FROM Camp_assignment A JOIN Camp_assignment B ON A.Site = B.Site;

-- Step 2:
SELECT * FROM Camp_assignment A JOIN Camp_assignment B ON A.Site = B.Site
WHERE A.End >= B.Start AND A.Start <= B.End;

-- Step 3:
SELECT * FROM Camp_assignment A JOIN Camp_assignment B ON A.Site = B.Site
    WHERE A.End >= B.Start AND A.Start <= B.End 
    AND A.Site = 'lkri' 
    AND A.Observer < B.Observer;


-- Step 4: Cleaned up table

SELECT A.Site, A.Observer AS observer_1, B.Observer AS observer_2
FROM Camp_assignment A JOIN Camp_assignment B ON A.Site = B.Site
    WHERE A.End >= B.Start AND A.Start <= B.End 
    AND A.Site = 'lkri' 
    AND A.Observer < B.Observer;

-- BONUS 

SELECT A.Site, p1.Name AS Name_1, p2.Name AS Name_2
FROM Camp_assignment A JOIN Camp_assignment B ON A.Site = B.Site
    JOIN Personnel p1 ON A.Observer = p1.Abbreviation
    JOIN Personnel p2 ON B.Observer = p2.Abbreviation
    WHERE A.End >= B.Start AND A.Start <= B.End 
    AND A.Site = 'lkri' 
    AND A.Observer < B.Observer
    ORDER BY Name_1, Name_2;