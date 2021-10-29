MERGE data_lake.ghcnd_jp_2021 AS target
USING (
    SELECT
            id
        ,   date
        ,   element
        ,   value
        ,   mflag
        ,   qflag
        ,   sflag
        ,   time
    FROM `bigquery-public-data.ghcn_d.ghcnd_2021`
    WHERE
        1 = 1
        {append_where}
) AS source
ON  target.id      = source.id
AND target.date    = source.date
AND target.element = source.element
WHEN MATCHED THEN
    UPDATE SET
            target.value = source.value
        ,   target.mflag = source.mflag
        ,   target.qflag = source.qflag
        ,   target.sflag = source.sflag
        ,   target.time  = source.time
WHEN NOT MATCHED THEN
    INSERT (id, date, element, value, mflag, qflag, sflag, time)
    VALUES (    source.id
            ,   source.date
            ,   source.element
            ,   source.value
            ,   source.mflag
            ,   source.qflag
            ,   source.sflag
            ,   source.time
            )
