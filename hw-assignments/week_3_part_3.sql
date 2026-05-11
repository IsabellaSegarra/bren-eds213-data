-- List the scientific names of bird species in descending order of their maximum average egg volumns

-- Make temporary table for computing the average volumne 
CREATE TEMP TABLE Average AS
    SELECT Nest_ID, AVG(3.14 * (Width^2) * Length) / 6 AS Avg_volume
        FROM Bird_eggs
        GROUP BY (Nest_ID);

-- Join table with bird nest on bird ID column
-- Get the species onto the max average. 
SELECT Species, MAX(Avg_volume)
    FROM Bird_nests JOIN Average USING (Nest_ID)
    GROUP BY Species;

-- Now we need the scientific names. We can join Species column onto code 
SELECT Species, Scientific_name, MAX(Avg_volume)
    FROM Bird_nests JOIN Average USING (Nest_ID)
    JOIN Species ON Species.Code = Bird_nests.Species
    GROUP BY Species, Scientific_name;

-- Last request: no species code and order the results
SELECT Scientific_name, MAX(Avg_volume)
    FROM Bird_nests JOIN Average USING (Nest_ID)
    JOIN Species ON Species.Code = Bird_nests.Species
    GROUP BY Scientific_name
    ORDER BY MAX(Avg_volume) DESC;

    