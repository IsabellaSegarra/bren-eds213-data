-- Initial new duckdb database
duckdb walkability.duckdb 

-- Load spatial extension
LOAD spatial;
LOAD httpfs;

---- Data ----
-- Fips table
CREATE TABLE Fips AS SELECT * FROM read_csv('https://apps.bren.ucsb.edu/eds213-data/walkability/fips_state_county.csv');

-- Filtering walkability data for California 
CREATE VIEW Walkability_ca AS (SELECT GEOID10, STATEFP, COUNTYFP, TRACTCE, BLKGRPCE, CBSA, CBSA_Name, TotPop, NatWalkInd, geom_wgs84
  FROM read_parquet('https://apps.bren.ucsb.edu/eds213-data/walkability/walkability_wgs84.parquet')
  WHERE STATEFP = '06'
);

---- Join tables----
CREATE TABLE Walkind_mystate AS S

CREATE VIEW Walkind_ca AS
-- select all columns in walkability_ca and state name and county name
SELECT W.*, F.State_name, F.County_name
FROM Walkability_ca W
JOIN Fips F ON W.STATEFP = F.STATEFP AND W.COUNTYFP = F.COUNTYFP;


----- Walkability index at your location----
-- Location: Tiburon, CA
-- Latitude: 37.5236
-- Longitude: -122.2725

SELECT  * FROM Walkind_ca
WHERE ST_Within(ST_Point(-122.2725, 37.5236), geom_wgs84);

SELECT *, NatWalkInd, TRACTCE FROM Walkind_ca
WHERE ST_Within(ST_Point(-122.2725, 37.5236), geom_wgs84);
-- 15.5 NatWalkInd indicates a walking index that is above average which aligns with my expectations. 

----- Average Walkability index at your Census Tract ----- 
SELECT 
    TRACTCE,
    COUNT(*) AS Block_count,
    AVG(NatWalkInd) AS WalkInd_avg
FROM Walkind_ca
WHERE TRACTCE = '608600'
GROUP BY TRACTCE;

---- Average Walkability index at your County Level ----
SELECT 
    COUNTYFP, County_name,
    COUNT(*) AS Block_count,
    AVG(NatWalkInd) AS WalkInd_avg
FROM Walkind_ca
WHERE COUNTYFP = '081'
GROUP BY COUNTYFP, County_name;

-- The walkability of Tiburon is higher than the walkability of the surrounding 
-- San Mateo county. This makes sense as Tiburon is a relatively small location with a centralized downtown. 
-- Many of the streets are hilly and require a car so I thought the walkability might be lower or closer to the 
-- average walkability of the county. 

---  Export results --- 
CREATE VIEW tiburon_walkability AS
SELECT *,
    AVG(NatWalkInd) OVER (PARTITION BY TRACTCE) AS tract_avg_walkability,
    AVG(NatWalkInd) OVER (PARTITION BY COUNTYFP) AS county_avg_walkability
FROM Walkind_ca
WHERE TRACTCE = '608600';

-- Save CSV --
COPY tiburon_walkability TO 'walkability_tiburon_ca.csv' (HEADER, DELIMITER ',');
