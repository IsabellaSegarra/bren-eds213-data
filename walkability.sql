-- Install spatial extension
INSTALL spatial;
LOAD spatial;

-- Read parquet file
DESCRIBE SELECT * FROM read_parquet('/courses/EDS213/data/walkability/walkability84_hive/**/*.parquet') 
LIMIT 5;

-- Filtering data for SB 
CREATE VIEW SB_data AS (SELECT GEOID10, STATEFP, COUNTYFP, TRACTCE, BLKGRPCE, CBSA, CBSA_Name, TotPop, NatWalkInd, geom
  FROM read_parquet('/courses/EDS213/data/walkability/walkability84_hive/**/*.parquet')
  WHERE STATEFP = '06' AND COUNTYFP = '083'
);

-- Census Tract average walkability
SELECT 
    TRACTCE,
    COUNT(*) AS Block_count,
    AVG(NatWalkInd) AS WalkINd_avg,
    AVG(ST_Area(geom)) AS Avg_area
FROM SB_data
GROUP BY TRACTCE;

-- What is the walkability at the Santa Barbara Mission
SELECT * FROM SB_data
WHERE ST_Within(st_point(-119.721, 34.438), geom);