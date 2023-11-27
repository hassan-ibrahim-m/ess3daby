INSERT INTO ess3daby.actors
WITH data AS 
(
WITH ly AS(
SELECT *
FROM ess3daby.actors
WHERE current_year = 2021
),
ty AS(
SELECT actor, actor_id, year,
ARRAY_AGG(ROW(film, votes, rating, film_id)) AS films
FROM bootcamp.actor_films
WHERE year = 2022
GROUP BY actor, actor_id, year
)
SELECT 
COALESCE(ly.actor, ty.actor) as actor,
COALESCE(ly.actor_id, ty.actor_id) as actor_id,
CASE
WHEN ty.films IS NULL THEN ly.films
WHEN ty.films IS NOT NULL AND ly.films IS NULL THEN ty.films
WHEN ty.films IS NOT NULL AND ly.films IS NOT NULL THEN ty.films || ly.films
END AS films,
NULL AS quality_class,
ty.films IS NOT NULL AS is_active,
COALESCE(ty.year, ly.current_year+1) AS current_year
FROM ly
FULL OUTER JOIN ty
ON ly.actor_id = ty.actor_id
)
Select
actor, 
actor_id, 
films,
CASE
WHEN AVG(item.rating) > 8 Then 'star'
WHEN AVG(item.rating) > 7 and AVG(item.rating) <= 8 Then 'good'
WHEN AVG(item.rating) > 6 and AVG(item.rating) <= 7 Then 'average'
ELSE 'bad'
END as quality_class,
is_active,
current_year
FROM data LEFT JOIN UNNEST(films) AS item (film, votes, rating, film_id) ON TRUE
GROUP BY actor, actor_id, films, quality_class, is_active, current_year