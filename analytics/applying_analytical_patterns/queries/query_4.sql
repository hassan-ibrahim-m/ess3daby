with grouped as (
select 
gd.player_name,
gd.team_abbreviation,
g.season,
sum(pts) as total_points
from bootcamp.nba_game_details gd
join bootcamp.nba_games g
on g.game_id = gd.game_id
GROUP BY
  GROUPING SETS (
    (gd.player_name, gd.team_abbreviation),
    (gd.player_name, g.season),
    (gd.team_abbreviation)
  ))
select * from grouped
where season is not null
order by total_points desc
limit 1