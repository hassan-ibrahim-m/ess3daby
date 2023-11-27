-- Creating a DDL for a SCD table "actors_history_scd" (Type 2)
-- that tracks the fields: [quality_class, is_active, start_date, end_date]
-- for each actor in the actors table.

CREATE TABLE ess3daby.actors_history_scd (
    actor VARCHAR,
    actor_id VARCHAR,
    films ARRAY(
        ROW(
            film VARCHAR,
            votes INTEGER,
            rating DOUBLE,
            film_id VARCHAR
        )
    ),
    quality_class VARCHAR,
    is_active BOOLEAN,
    start_date DATE,
    end_date DATE,
    current_date DATE
) WITH (
    format = 'PARQUET',
    partitioning = ARRAY ['current_date']
)