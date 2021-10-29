TRUNCATE TABLE data_lake.ghcnd_stations_jp;
INSERT INTO data_lake.ghcnd_stations_jp
SELECT
        Id
    ,   latitude
    ,   longitude
    ,   elevation
    ,   state
    ,   name
    ,   gsn_flag
    ,   hcn_crn_flag
    ,   wmoid
FROM `bigquery-public-data.ghcn_d.ghcnd_stations` 
WHERE
    wmoid between 47200 AND 47998
