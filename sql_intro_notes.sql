-- To verify that we have the right database open, look what tables are in the database
.table

-- To see the DucDB-specific commands, do this:
.help
.help mode .exi

-- In SQL, comments are delimited with --
-- .table (list tables)
-- .schema (lists the whoel schema)

-- Querying the database
-- the * means all columns; all rows ar eimplied because we didn't specify a where clause 
SELECT * FROM Species;

-- Don't forget:
-- closing semicolon, DuckDB will wait for it forever
-- closing qoutes 

-- Exploring Database 
-- Select first 5 rows
SELECT * FROM Species LIMIT 5; 
-- Can also "page" through the rows
SELECT * FROM Species LIMIT 5 OFFSET 5; 

Select Code, Scientific-name FROM SPECIES; 
SELECT Species FROM Bird_nests;
SELECT DISTINCT Species FROM Bird_nests;

-- Can also get distinct pairs or tuples that occur
SELECT DISTINCT Species, Observer FROM Bird_nests; 

-- ask that the results be ordereed 
SELECT Scientific_name FROM Species; 
SELECT Scientific_name FROM Species ORDER BY Scientific_name DESC;

SELECT DISTINCT Species FROM Bird_nests ORDER BY Species; 
SELECT DISTINCT Species FROM Bird_nests ORDER BY Species LIMIT 3; 

-- In class challenge
-- 
SELECT DISTINCT Location FROM Site;
SELECT DISTINCT Location FROM Site ORDER BY Site_name;

-- 4/15/26
-- Basic query 
SELECT DISTINCT Location 
    FROM Site
    ORDER BY Location
    LIMIT 3; 

-- Filtering: Similar to R/Python
SELECT * FROM Site WHERE Area < 200; 
SELECT * FROM Site WHERE Area < 200 AND Latitude > 60; 

-- Do not select something 
SELECT * FROM Site WHERE != 'iglo'
SELECT * FROM Site WHERE Code <> 'iglor'; 

-- Expressions 
-- Multiple area of each site by 2.45 
SELECT Site_name, Area * 2.47 FROM Site; 

-- Give a name to column
SELECT Site_name, Area * 2.47 AS Area_acres FROM Site; 

-- Concate
SELECT Site_name || ',' || Location AS Full_name FROM Site; 

-- Mathemtical expressions
SELECT 2+2

-- RENAMING
-- adding "AS ..." needs to come right after the thing you want to name 
SELECT Site_name AS some_other_name FROM SIte LImIT 1; 

-- How many rows are in this table?
-- COUNT * =  counts rows 
SELECT COUNT(*) FROM Bird_nests;

-- How many non-NULL values are there?
SELECT COUNT(*) FROM Species;
SELECT COUNT (Scientific_name) FROM Species;
SELECT COUNT(DISTINCT Location) FROM Site; -- number of distinct locations
SELECT COUNT(Location) FROM SITE; -- number of non-NULL locations 
SELECT DISTINCT Location FROM Site; 

-- Want to list 7 locations
SELECT Location, AVG(Area) FROM Site; 

-- Grouping 
SELECT Location, AVG(Area) FROM Site GROUP BY Location;

-- Counting (site %>% group_by(Location) %>% summarize(count=n()))
SELECT Location, COUNT (*) FROM Site GROUP BY Location; 

-- We can site (group rows by location, filter for locations like Canada)
SELECT Location, COUNT(*)
    FROM SIte
    WHERE Location LIKE '%Canada'  -- old style pattern matching, not a full regex, just wildcare %
    GROUP BY Location;

-- the order of the clauses reflect the order of the processing
-- but what if you want to do some filtering on your groups, i.e., *after* you've done thr groupong?

-- HAVING = like where but after you have grouped 

SELECT Location, MAX(Area) AS Max_area
    FROM Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location
    HAVING Max_area > 200 
    ORDER BY Max_area DESC; 

-- Relational Algebra
-- Everything is a table
-- every query, statemet returns a table 

-- you can nest queries 
SELECT DISTINCT Species FROM Bird_nests;

SELECT Code FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);

-- NULL Processing
-- in a table, NULL means no data
-- in an expression, NULL means unknown
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod = 'float';
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod <> 'float';

-- 
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod = NULL;

-- Only way 
SELECT COUNT(*) FROM Bird_nests WHERE ageMETHOD IS NOT NULL;

-- JOINS 
-- 90% of the time, we'll join tables based on a foreign key relationship

SELECT * FROM Camp_assignment; 
SELECT * FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation
    LIMIT 10; 

SELECT * FROM Site CROSS JOIN Species; 

-- any condition can be an expression,we have complete freedom here
-- where there is a foreign key relationship >> the result is the same as the tbale with the foreig, but augmented 
-- with addtional columns 

-- CREATE ALIAS NAMES 
SELECT * FROM Bird_nests BN JOIN Species S -- create alias names 
    ON BN.Species = S.Code 

-- Sometimes if column names are ambiguous where they're coming from, 
-- need qualify them 

SELECT * FROM Bird_nests AS BN JOIN Species AS S  
    ON BN.Species = S.Code;
-- do not need AS

-------------------------------------------------------------------
-- 4/20/26 Review
-- Expressions can have a value (ifBoolean, T/F) but they can also be NULL. 
-- In selecting rows, nULL doesn't cut it, NULL doesn't count as TRUE

SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge < 7 OR floatAge >= 7;

SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge IS NULL; -- must say "IS NULL" to fnd the NUll calues

-- Relational algebra
-- Everything is a table! Every operation returns a table!
-- Even a simple COUNT(*) returns a table

SELECT COUNT(*) FROM Bird_nests;

-- Nesting selects

SELECT Scientific_name 
    FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);
-- selecting distinct species (19) from bird nests

-- Nested query with HAVING
SELECT Location, MAX(Area) AS Max_area 
    FROM Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location
    HAVING Max_area > 200;

-- Nested query without HAVING
SELECT * FROM 
    (SELECT Location, MAX(Area) AS Max_area 
        FROM Site
        WHERE Location LIKE '%Canada'
        GROUP BY Location)
        WHERE Max_area > 200;

----- Toy database ------
-- 

SELECT * FROM A CROSS JOIN B; 
SELECT * FROM A;
SELECT * FROM B;

-- Join a coniditon, which can be any expression
SELECT * FROM A JOIN B ON acol1 < bcol1

--This is what's referred to as an INNER JOin

SELECT * FROM A INNER JOIN B ON acol1 < bcol1;

-- Outer join: adding rows from one table that never got matched 
SELECT * FROM A RIGHT JOIN B ON acol1 < bcol1;

SELECT * FROM A LEFT JOIN B on acol1 < bcol1;

SELECT * FROM A FULL OUTER JOIN B ON acol1 < bcol1; 

-- Joining on a foreign key relationship is way more common
.schema

SELECT * FROM House;
SELECT * FROM Student;

-- Typical thing to do:
SELECT * FROM Student S JOIN House H ON S.House_ID = H.House_ID; 

-- Without aliases:
SELECT* FROM Student JOIN House ON Student.House_ID = House.House_ID 

-- Benefit of joining on a oclumn that has the same name (i.e., House_ID here), you can use
-- USING clause 

-- Default INNER Join

SELECT * FROM Student JOIN House USING (House_ID);

---- Bird database ----
SELECT COUNT (*) FROM Bird_eggs;

-- View one single row with .mode line 
.mode line 
SELECT * FROM Bird_eggs LIMIT 1; 
SELECT * FROM Bird_eggs JOIN Bird_nests USING (Nest_ID) LIMIT 1;
SELECT COUNT(*) FROM Bird_eggs JOIN Bird_nests USING (Nest_ID);

-- undo 
.mode duckbox 

--- Ordering is the last thing you do, this is lost during a join 

SELECT * FROM
    (SELECT * FROM Bird_eggs ORDER BY Width)
    JOIN Bird_nests
    USING (Nest_ID);

SELECT Nest_ID, COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID;

-- Some databases allow you to say:

SELECT Nest_ID, Species, COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID, Species;

-- Use ANY_VALUE 
SELECT Nest_ID, ANY_VALUE(Species), COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID;

SELECT Nest_ID,Species, Egg_num, Width, Length FROM
    Bird_eggs JOIN Bird_nests USING (Nest_ID)
    ORDER BY Nest_ID, Egg_num
    LIMIT 10;

------ 4/22/26 Notes -----
SELECT * FROM B;
SELECT COUNT(*) FROM B;

-- Will join based on all possible combinations (Cartesian product of all the rows)
SELECT * FROM A CROSS JOIN B;

-- Selecting the output table from B, specifiying which columns you want 
-- Always select columns from the output computed
SELECT acol1, acol2 FROM (SELECT * FROM A CROSS JOIN B);

-- Difference between COUNT(*) == number of rows & COUNT(column) = non-null values in that column or group

SELECT acol1, ANY_VALUE(acol2), COUNT(*)
    FROM(SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1; 

SELECT acol1, ANY_VALUE(acol2), COUNT(bcol3)
    FROM (SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1; 
-- Using a condition (join when column 1 is less than b column between A & B tables)
SELECT * FROM A JOIN B ON acol1 < bcol1;

-- INNER vs. OUTER JOINS
-- default is inner join 
SELECT * FROM Student;

-- Join tables by their house ID 
SELECT * FROM Student AS S JOIN House AS H ON S.House_ID = H.House_ID;

-- Same query as above. Requires the same column names. 
SELECT * FROM Student JOIN House USING (House_ID); 

-- OUTER JOINS 
SELECT * FROM Student FULL JOIN House USING (House_ID);

-- LEFT JOIN
SELECT * FROM Student LEFT JOIN House USING (House_ID);

-- CROSS Join = joining ona ll possible combinations 
SELECT * FROM Student CROSS JOIN House; 


--- ASDN Database ---

-- Create table
CREATE TABLE Snow_cover (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1990 AND 2018),
    Date DATE NOT NULL,
    Plot VARCHAR NOT NULL,
    Location VARCHAR NOT NULL,
    Snow_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130),
    Water_cover REAL CHECK (Water_cover BETWEEN 0 AND 130),
    Land_cover REAL CHECK (Land_cover BETWEEN 0 AND 130),
    Total_cover REAL CHECK (Total_cover BETWEEN 0 AND 130),
    Observer VARCHAR,
    Notes VARCHAR,
    PRIMARY KEY (Site, Plot, Location, Date),
    FOREIGN KEY (Site) REFERENCES Site (Code)
);

-- Create temporary table
CREATE TEMP TABLE Camp_assignment_copy AS
   SELECT * FROM Camp_assignment; 

-- Which person worked at a specific site?
SELECT Year, Site, Name 
   FROM Camp_assignment_copy JOIN Personnel ON Observer = Abbreviation LIMIT 5;

-------------------------------------------------------------------
--4/27/26---
-- Recap: Views
-- A view is kind of virtual table, sotred in the database (view .schema and its there)
-- In effect, a view is a kind of shortcut 

-- Example: suppose we wnat to look at bird nests without species code 

CREATE VIEW Nest_view AS
    SELECT Book_page, Year, Site, Nest_ID, Scientific_name, Observer
    FROM Bird_nests JOIN Species
    ON Species = Code; 

-- for comparison:
SELECT * FROM Nest_view LIMIT 1;
SELECT * FROM Bird_nests LIMIT 1; 

-- Another view 
-- use any_value() because scientific name has many values, similar to group by 
SELECT Nest_ID, ANY_VALUE(Scientific_name) AS Scientific_name, COUNT(*) AS Num_eggs
    FROM Nest_view JOIN Bird_eggs
    USING (Nest_ID)
    GROUP BY Nest_ID;

-- View compared to temp tables:
-- Temp table is more like a variable in a programming language 
-- only lasts for the session 

-- The WITH clause
WITH x AS (
    SELECT Nest_ID, ANY_VALUE(Scientific_name) AS Scientific_name, COUNT(*) AS Num_eggs
        FROM Nest_view JOIN Bird_eggs
        USING (Nest_ID)
        GROUP BY Nest_ID;
)   SELECT Scientific_name, AVG(Num_eggs) AS Avg_num_eggs FROM x
    GROUP BY Scientific_name;

-- The variable ("X") only lasts for the statement; it's really a kind of abbreviation

-- SET operations
-- Recall that tables are **sets** of rows, not ordered lists
-- We can do set operations on tables; UNION, INTERSECT, EXCEPT
-- one note: these are set operations, so duplicates are elimination in UNIONS
-- If you want to preserve all rows, UNION ALL 

-- We want a table of brid nests and egg coutns, but we alos want entries for nests that have no eggs 

SELECT Nest_ID, COUNT(Egg_num) AS Num_egs
    FROM Bird_nests LEFT JOIN Bird_eggs
    USING (Nest_ID)
    GROUP BY Nest_ID; 

-- Use UNION for the same problem 
SELECT Nest_ID, COUNT(*) AS Num_eggs
    FROM Bird_eggs
    GROUP BY Nest_ID; 

SELECT Nest_ID, 0 AS Num_eggs
    FROM Bird_nests
    WHERE Nest_ID NOT IN (SELECT DISTINCT Nest_ID FROM Bird_eggs);

-- JOIN conditions on a foreign key, two ways:
-- 1. ON Species = Code
-- 2. ON Bird_nests.Nest_ID = Bird_eggs.Nest_ID

-- EXCEPT clause:
-- Question: Which species do we *not* have data for?
-- 1.)
SELECT Code FROM Species    
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);

-- 2.)
SELECT Code
    FROM Bird_nests RIGHT JOIN Species
    ON Species = Code
    WHERE Species IS NULL;

-- 3.) 
SELECT Code FROM Species
    EXCEPT
    SELECT DISTINCT Species FROM Bird_nests; 

-- INSERT Statments 
SELECT * FROM Personnel;
    INSERT INTO Personnel VALUES ('gjanee', 'Greg Janee');
SELECT * FROM Personnel;


--Nam ethe columns
INSERT INTO Personnel (Abbreviation, Name) VALUES ('jbrun', 'Julien Brun');

-- Databases typically have some kind of load functions to load data in bulk 

---- UPDATES & DELETS

SELECT * FROM Bird_nests LIMIT 10;
UPDATE Bird_nests SET floatAge = 6.5, ageMethod = 'float'
    WHERE Nest_ID = '14HPE1';

-- DELETE FROM Bird_nests WHERE...;
-- If you forget the WHERE clause, this operates on all rows in the table 
-- we can undo with git restore database.duckdb because it it git version controlled, however that is not realistic for all databases 

-- To prevent this mistake:
-- First do a select to confirm the rows you want to operate on, then edit the statement to do an update 
SELECT * FROM Bird_nests WHERE Nest_ID = '98nome7';

-- ANother idea: use a gake table name, then change to the real name 
UPDATE Bird_nests2 SET ... WHERE ...; 