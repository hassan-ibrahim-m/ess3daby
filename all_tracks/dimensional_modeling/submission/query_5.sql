-- Writing an "incremental" query that populates a single year's worth of the actors_history_scd table
-- by combining the previous year's SCD data with the new incoming data from the actors table for this year.
-- Doing that for the data from 2000 to 2010

WITH actors_one_year AS (
    select
        *
    from
        ess3daby.actors
    where
        current_year = '1999' -- Doing this for the years from 1999 to 2010 increamentally
) MERGE INTO ess3daby.actors_history_scd scd USING new_year ON (scd.actor_id = new_year.actor_id)
-- In case of matching and because we're using (Type 2):
-- the only update on the (old record) is the (end_date) to be the end of the (start_date)
-- And inserting the new record with the end_date = '9999-12-31' to be the current effective record.
WHEN MATCHED THEN
UPDATE
SET
    end_date = cast(
        concat(cast(new_year.current_year as VARCHAR), '-12-31') as date
    ),
    currentDate = cast('2010-12-31' as date)
    
INSERT
    (
        actor,
        actor_id,
        films,
        quality_class,
        is_active,
        start_date,
        end_date,
        currentDate
    )
VALUES
    (
        new_year.actor,
        new_year.actor_id,
        new_year.films,
        new_year.quality_class,
        new_year.is_active,
        cast(
            concat(cast(new_year.current_year as VARCHAR), '-01-01') as date
        ),
        cast('9999-12-31' as date),
        cast(
            concat(cast(new_year.current_year as VARCHAR), '-12-31') as date
        )
    )
WHEN NOT MATCHED THEN
INSERT
    (
        actor,
        actor_id,
        films,
        quality_class,
        is_active,
        start_date,
        end_date,
        currentDate
    )
VALUES
    (
        new_year.actor,
        new_year.actor_id,
        new_year.films,
        new_year.quality_class,
        new_year.is_active,
        cast(
            concat(cast(new_year.current_year as VARCHAR), '-01-01') as date
        ),
        cast('9999-12-31' as date),
        cast(
            concat(cast(new_year.current_year as VARCHAR), '-12-31') as date
        )
    )