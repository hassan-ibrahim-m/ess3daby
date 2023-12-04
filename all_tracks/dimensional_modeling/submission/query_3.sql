INSERT INTO
    ess3daby.user_devices_cumulated 
    WITH yesterday AS(
            SELECT
                *
            FROM
                ess3daby.user_devices_cumulated
            WHERE
                date = DATE('2022-12-31')
        ),
        today AS(
            SELECT
                user_id,
                browser_type,
                ARRAY[date_trunc('day', event_time)] as dates_active,
                date_trunc('day', event_time) as event_date,
                count(1) as cnt
            FROM
                bootcamp.web_events ev
                Left Join bootcamp.devices dev
                On ev.device_id = dev.device_id  
            Where date_trunc('day', event_time) = DATE('2023-01-01')        
            GROUP BY
            user_id,
            browser_type,
            date_trunc('day', event_time)
        )

        SELECT
            COALESCE(yesterday.user_id, today.user_id) as user_id,
            COALESCE(yesterday.browser_type, today.browser_type) as browser_type,
            CASE
                WHEN today.dates_active IS NULL THEN yesterday.dates_active
                WHEN today.dates_active IS NOT NULL
                AND yesterday.dates_active IS NULL THEN today.dates_active
                WHEN today.dates_active IS NOT NULL
                AND yesterday.dates_active IS NOT NULL THEN today.dates_active || yesterday.dates_active
            END AS dates_active,
            today.dates_active IS NOT NULL AS is_active,
            COALESCE(today.event_date, date_add('day', 1, yesterday.date)) AS date
        FROM
            yesterday FULL
            OUTER JOIN today ON yesterday.user_id = today.user_id and yesterday.browser_type = today.browser_type