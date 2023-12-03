# All Tracks Fact Data Modeling Homework

For this week, we'll be using the `nba_game_details`, the `web_events` and the `devices` datasets.

Make sure to choose a convention for doing linting of your SQL code so that it's easier to read!

It is okay to leave comments inside your queries. In fact, we'd encourage it to show your reasoning for each step. Please make sure to use the `--` syntax for comments.

You may choose 5 out of the 8 following questions to implement.

## De-dupe Query (query_1)

Write a query to de-duplicate the `nba_game_details` table from the day 1 lab of the fact modeling week 2 so there are no duplicate values.
You should de-dupe based on the combination of `game_id`, `team_id` and `player_id`, since a player cannot have more than 1 entry per game.
Feel free to take the first value here.

## User Devices Activity Datelist DDL (query_2)

Similarly to what was done in day 2 of the fact data modeling week, write a DDL statement to create a cumulating user activity table by device.

This table will be the result of joining the `devices` table onto the `web_events` table, so that you can get both the `user_id` and the `browser_type`.

The name of this table should be `user_devices_cumulated`.

The schema of this table should look like:

- `user_id bigint`
- `browser_type varchar`
- `dates_active array(date)`
- `date date`

The `dates_active` array should be a datelist implementation that tracks how many times a user has been active with a given `browser_type`.

Note that you **can** also do this using a `MAP(VARCHAR, ARRAY(DATE))` type, but then you have to know how to manipulate the contents of those maps correctly (and then you don't include a `browser_type` column).
If you use the `MAP` type, you'd have one row per `user_id`, and the keys of this `MAP` would be the values for `browser_type`, and the values would be the arrays of dates for which we saw activity for that user on that browser type.

Note only that, but you'll need to take care of doing the CROSS JOIN UNNEST correctly - when we did it in lab, we didn't do it against a `MAP` type, but an `ARRAY` type, so it exploded into rows in the way you'd expect.

Doing this by just including a `browser_type` column means it works almost exactly the same as what we did in lab, you just add an additional group by key.

The first index of the date list array should correspond to the most **recent** date (today's date).

## User Devices Activity Datelist Implementation (query_3)

Write the incremental query to populate the table you wrote the DDL for in the above question from the `web_events` and `devices` tables. This should look like the query to generate the cumulation table from the fact modeling day 2 lab.

## User Devices Activity **Int** Datelist Implementation (query_4)

Building on top of the previous question, convert the date list implementation into the base-2 integer datelist representation as shown in the fact data modeling day 2 lab.

Assume that you have access to a table called `user_devices_cumulated` with the output of the above query. To check your work, you can either load the data from your previous query (or the lab) into a `user_devices_cumulated` table, or you can generate the `user_devices_cumulated` table as a CTE in this query.

You can write this query in a single step, but note the three main transformations for this to work:

- unnest the dates, and convert them into powers of 2
- sum those powers of 2 in a group by on `user_id` and `browser_type`
- convert the sum to base 2

## Host Activity Datelist DDL (query_5)

Write a DDL statement to create a `hosts_cumulated` table, as shown in the fact data modeling day 2 lab. Except for in the homework, you'll be doing it by `host`, not `user_id`.

The schema for this table should include:

- `host varchar`
- `host_activity_datelist array(date)`
- `date date`

## Host Activity Datelist Implementation (query_6)

As shown in the fact data modeling day 2 lab, Write a query to incrementally populate the `hosts_cumulated` table from the `web_events` table.

## Reduced Host Fact Array DDL (query_7)

As shown in the fact data modeling day 3 lab, write a DDL statement to create a monthly `host_activity_reduced` table, containing the following fields:

- `host varchar`
- `metric_name varchar`
- `metric_array array(integer)`
- `month_start varchar`

## Reduced Host Fact Array Implementation (query_8)

As shown in fact data modeling day 3 lab, write a query to incrementally populate the `host_activity_reduced` table from a `daily_web_metrics` table. Assume `daily_web_metrics` exists in your query. Don't worry about handling the overwrites or deletes for overlapping data.

Remember to leverage a full outer join, and to properly handle imputing empty values in the array for windows where a host gets a visit in the middle of the array time window.
