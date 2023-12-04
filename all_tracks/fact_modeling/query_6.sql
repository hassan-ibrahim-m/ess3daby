INSERT INTO
  ess3daby.hosts_cumulated
WITH
  yesterday AS (
    SELECT
      *
    FROM
      ess3daby.hosts_cumulated
    WHERE
      DATE = DATE('2022-12-31')
  ),
  today AS (
    SELECT
      host,
      CAST(DATE_TRUNC('day', event_time) AS DATE) AS event_date,
      COUNT(1)
    FROM
      bootcamp.web_events
    WHERE
      DATE_TRUNC('day', event_time) = DATE('2023-01-01')
    GROUP BY
      host,
      CAST(DATE_TRUNC('day', event_time) AS DATE)
  )
SELECT
  COALESCE(yesterday.host, today.host) AS host,
  CASE
    WHEN yesterday.host_activity_datelist IS NOT NULL THEN ARRAY[today.event_date] || yesterday.host_activity_datelist
    ELSE ARRAY[today.event_date]
  END AS host_activity_datelist,
  DATE('2023-01-05') AS DATE
FROM
  yesterday
  FULL OUTER JOIN today ON yesterday.host = today.host