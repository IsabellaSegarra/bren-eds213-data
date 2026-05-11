-- join bird nests table with observer 
-- only want nome site between 2998 and 2008
-- determine which egg age was determined by floating as Num_floated_nests 


SELECT Name, COUNT(*) AS Num_floated_nests
FROM Bird_nests
JOIN Personnel ON Observer = Abbreviation
WHERE Site = 'nome' AND Year >= 1998 AND Year <= 2008 AND ageMethod = 'float'
GROUP BY Name
HAVING Num_floated_nests = 36;

-- The correct way --

