CREATE TABLE user_devices_cumulated (
    user_id bigint,
    browser_type varchar,
    dates_active ARRAY(DATE),
    date DATE
) WITH (
    format = 'PARQUET',
    partitioning = ARRAY ['date']
)
