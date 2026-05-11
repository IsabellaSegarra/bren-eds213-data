----- PART 1 -------
SELECT Site_name, MAX(Area) FROM Site;
-- The above SQL query is incorrect because MAX(Area) wants to collapse all rows into one value (max)
-- SQL needs to know which site name to perform this calculation on. It thinks it wants to be across
-- all sites when in reality we want the max from the Site column, grouped by site name. 

----- PART 2 ------

SELECT Site_name, MAX(Area) AS max_area
    FROM Site
    GROUP BY Site_name
    ORDER BY max_area DESC
    LIMIT 1;

----- PART 3 ------

SELECT Site_name, Area FROM Site WHERE Area = (SELECT MAX(Area) FROM Site);
