--------- PART 1 ---------

-- Question: If there are null values in a dataset, how does that affect the average?
-- An experiment you can run is to create a temperaroy verision of your table, one with NULL values and one 
-- without NULL values. Then you can perform the AVG function on a column and compare the output. 


SELECT * FROM column
    WHERE column IS NULL

-- This will return a table of all the rows where the value is NULL. Then you can change these values
-- to be 0 and perform your calculation with the values as 0 or NULL. 

-- Step 1. Make a table in our toy database 
CREATE TEMP TABLE mytable(
    row_id REAL, 
);

-- Step 2. Insert values into mytable
INSERT INTO mytable VALUES
(1, 3.6, 2, NULL, 5.5, NULL, 6.8, 1.2, 4.9); -- Cannot insert values all at one, must do it as a row

-- Insert values as a row
INSERT INTO mytable VALUES
(1),
(3.6),
(2),
(NULL),
(5.5),
(NULL),
(6.8),
(1.2),
(4.9);


-- Step 3. Perform AVG of this column 

-- Default AVG function that includes NULL values. 
SELECT AVG(row_id) FROM mytable; -- AVG = ~3.571 

-- Function if NULL values are ignored. The value is the same. SQL must ignore NULL values during algebra. 
SELECT AVG(row_id) FROM mytable
    WHERE row_id IS NOT NULL; 

-- Function if NULL values are selected. This returns an average of NULL since only NULL values are selected
SELECT AVG(row_id) FROM mytable
    WHERE row_id IS NULL;

------- PART 2 ------

SELECT SUM(row_id)/COUNT(*) FROM mytable; -- This returns ~2.778 which is not the value that the AVG function
-- calculated. 

SELECT SUM(row_id)/COUNT(row_id) FROM mytable; -- This is the correct AVG of the column. 

-- The first SQL query is incorrect because it is dividing by the number of rows in row_id. 
-- The second SQL qeury is correct because it is counting the values within the rows. 


DROP TABLE mytable;