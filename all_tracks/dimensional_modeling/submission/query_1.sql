-- Creating a DDL for the actors table with the fields [actor, actor_id, films, quality_class, is_active, current_year]
CREATE TABLE ess3daby.actors (
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
    current_year INTEGER
) WITH (
    format = 'PARQUET',
    partitioning = ARRAY ['current_year']
)