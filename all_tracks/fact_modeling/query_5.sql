CREATE TABLE ess3daby.hosts_cumulated (
    host varchar,
    host_activity_datelist ARRAY(DATE),
    date DATE
) WITH (
    format = 'PARQUET',
    partitioning = ARRAY ['date']
)
