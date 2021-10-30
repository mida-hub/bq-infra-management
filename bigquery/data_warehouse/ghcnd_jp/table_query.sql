MERGE data_warehouse.ghcnd_jp AS target
USING (
    SELECT
            data.id
        ,   data.date
        ,   data.element
        ,   mst.name
        ,   mst.latitude
        ,   mst.longitude
        ,   mst.elevation
        ,   data.value
        ,   data.mflag
        ,   data.qflag
        ,   data.sflag
        ,   data.time
    FROM data_lake.ghcnd_jp_2021 data
    INNER JOIN data_lake.ghcnd_stations_jp mst
    ON data.id = mst.id
    WHERE
        1 = 1
        {append_where}
) AS source
ON  target.id      = source.id
AND target.date    = source.date
AND target.element = source.element
WHEN MATCHED THEN
    UPDATE SET
            target.name      = source.name
        ,   target.latitude  = source.latitude
        ,   target.longitude = source.longitude
        ,   target.elevation = source.elevation
        ,   target.value     = source.value
        ,   target.mflag     = source.mflag
        ,   target.qflag     = source.qflag
        ,   target.sflag     = source.sflag
        ,   target.time      = source.time
WHEN NOT MATCHED THEN
    INSERT (id, date, element, name, latitude, longitude, elevation, value, mflag, qflag, sflag, time)
    VALUES (    source.id
            ,   source.date
            ,   source.element
            ,   source.name
            ,   source.latitude
            ,   source.longitude
            ,   source.elevation
            ,   source.value
            ,   source.mflag
            ,   source.qflag
            ,   source.sflag
            ,   source.time
            )
