with cte as (
select host, avg(num_hits) from sessionized_events
group by host)
insert into average_web_events
select * from cte