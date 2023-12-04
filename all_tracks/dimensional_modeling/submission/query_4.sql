-- Writing a batch "backfill" query that populates the entire actors_history_scd table in a single query.

INSERT into
    ess3daby.actors_history_scd with cte as(
        select
            actor,
            actor_id,
            films,
            quality_class,
            is_active,
            current_year,
            ROW_NUMBER() OVER (
                Partition by actor_id
                order by
                    current_year desc
            ) as r
        from
            ess3daby.actors
    )
select
    actor,
    actor_id,
    films,
    quality_class,
    is_active,
    cast(
        concat(cast(current_year as VARCHAR), '-01-01') as date
    ) as start_date,
    CASE
        WHEN r = 1 THEN cast('9999-12-31' as date)
        ELSE cast(
            concat(cast(current_year as VARCHAR), '-12-31') as date
        )
    END AS end_date,
    cast('2010-12-31' as date) as currentDate
FROM
    cte