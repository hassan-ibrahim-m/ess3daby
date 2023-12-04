with deduped as (
SELECT *, ROW_NUMBER() over (Partition by game_id, team_id, player_id) as r
FROM bootcamp.nba_game_details)
select * from deduped where r = 1