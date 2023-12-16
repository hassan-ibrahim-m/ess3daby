-- First, I noticed some duplication in the data to I created a deduped version of it in a new table

-- [1] Creating the Table:
CREATE TABLE ess3daby.nba_players_deduped
  (
    player_name VARCHAR,
    current_season INTEGER,
    height VARCHAR,
    college VARCHAR,
    country VARCHAR,
    years_since_last_active INTEGER,
    is_active BOOLEAN,
  )
WITH
  (FORMAT = 'PARQUET', partitioning = ARRAY['current_season'])


-- [2] Inserting the data afetr deduplication to the deduped table
INSERT INTO ess3daby.nba_players_deduped
WITH
  deduped AS (
    SELECT
      player_name,
      current_season,
      height,
      college,
      country,
      years_since_last_active,
      is_active,
      ROW_NUMBER() OVER (
        PARTITION BY
          player_name,
          current_season,
          height,
          college,
          country,
          years_since_last_active,
          is_active
      ) AS r
    FROM
      bootcamp.nba_players
  )
SELECT
  player_name,
      current_season,
      height,
      college,
      country,
      years_since_last_active,
      is_active
FROM
  deduped
WHERE
  r = 1

-- [3] Creating a new table with the field "Player State" for state tracking.
CREATE TABLE
  ess3daby.players_state_tracking (
    player_name VARCHAR,
    current_season INTEGER,
    height VARCHAR,
    college VARCHAR,
    country VARCHAR,
    years_since_last_active INTEGER,
    is_active BOOLEAN,
    player_state VARCHAR
  )
WITH
  (FORMAT = 'PARQUET', partitioning = ARRAY['current_season'])

-- [4] Filling the new Table with data for the arbitrary period from 1997 until 2002.
Insert into ess3daby.players_state_tracking
WITH
  last_season AS (
    SELECT
      *
    FROM
      ess3daby.players_state_tracking
    WHERE
      current_season = 1997 and player_name = 'Corey Benjamin'
  ),
  this_season AS (
    SELECT
      *
    FROM
      ess3daby.nba_players_deduped
    WHERE
      current_season = 1998 and player_name = 'Corey Benjamin'
  )
SELECT
  COALESCE(ts.player_name, ls.player_name) AS player_name,
  COALESCE(ts.current_season, ls.current_season) AS current_season,
  COALESCE(ts.height, ls.height) AS height,
  COALESCE(ts.college, ls.college) AS college,
  COALESCE(ts.country, ls.country) AS country,
  COALESCE(ts.years_since_last_active, ls.years_since_last_active + 1) AS years_since_last_active,
  COALESCE(ts.is_active, False) AS is_active,
  CASE
    WHEN ls.player_name IS NULL AND ts.player_name IS NOT NULL THEN 'new'
    WHEN ts.is_active = False AND ls.is_active = True THEN 'Retired'
    WHEN ts.is_active = True AND ls.is_active = True THEN 'Continued Playing'
    WHEN ts.is_active = True AND ls.is_active = False THEN 'Returned from Retirement'
    WHEN ts.is_active = False AND ls.is_active = False THEN 'Stayed Retired'
    ELSE 'N/A'
  END AS player_state
FROM
  last_season ls
  FULL OUTER JOIN this_season ts ON ls.player_name = ts.player_name




  


