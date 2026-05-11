----- Step 1 ----- 
-- Load in nests_big into the database
CREATE TABLE Nests_big AS SELECT * FROM 'nests_big.csv';
--Load in eggs_big into the database
CREATE TABLE Eggs_big AS SELECT * FROM 'eggs_big.csv';

-- Investigate
SELECT COUNT(*) FROM Nests_big; -- 13062 rows
SELECT COUNT(*) FROM Eggs_big; -- 25801 rows
DESCRIBE Nests_big;
SELECT * FROM Nests_big LIMIT 5; 

DESCRIBE Eggs_big;

----- Step 2 ----- 
--Perform a 3-way join between Eggs_big, Nests_big, and Species


SELECT * FROM eggs_big
    JOIN nests_big USING (Nest_ID)
    JOIN Species ON Nests_big.Species = Species.Code
    WHERE Species.Scientific_name = 'Calidris alpina';
 

-----  Step 3 ----- 
-- Revise your query to select just the Site column and compute an egg volume column

CREATE TEMP TABLE dunlin AS
SELECT Nests_big.Site,
(3.14/6 * (Width^2) * Length) AS Volume FROM Eggs_big
    JOIN Nests_big USING (Nest_ID)
    JOIN Species ON Nests_big.Species = Species.Code
    WHERE Species.Scientific_name = 'Calidris alpina';
-- View temp table
SELECT * FROM dunlin;


----- Step 4 ----- 

SELECT Site.Longitude, dunlin.Volume
FROM dunlin
JOIN Site ON dunlin.Site = Site.Code;

----- Step 5 ----- 
SELECT MIN(Longitude), MAX(Longitude) FROM Site;

SELECT CASE WHEN Site.Longitude > 0 THEN Site.Longitude - 360 ELSE Site.Longitude END AS Longitude
, dunlin.Volume
FROM dunlin
JOIN Site ON dunlin.Site = Site.Code;

----- Step 6 ----- 
-- Save as new temp table --
CREATE TABLE dunlin_coords AS
    SELECT CASE WHEN Site.Longitude > 0 THEN Site.Longitude - 360 ELSE Site.Longitude END AS Longitude
    , dunlin.Volume
    FROM dunlin
    JOIN Site ON dunlin.Site = Site.Code;

----- Step 7 ----- 
SELECT regr_slope(Volume, Longitude) AS Slope, corr(Volume, Longitude) AS PCC
FROM dunlin_coords;

----- Questions ----- 

-- Question 1: 
--When ingesting the eggs_big and nests_big csv files into the database we did not specify any
--relation to each other via a foreign key relationship. This guarentees that these two columns
--will not relate to each other. 

-- Question 2: 
SUMMARIZE Site;
SELECT MIN(longitude), MAX(longitude) FROM Site;

-- The above lines of SQL code are two ways to find the minimum and max longitude. 

-- Question 3:
--Egg volume has around a near zero correlation with longitude 
--for the eggs of Calidris alpina in the Arctic. 


