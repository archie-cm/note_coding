-- FIRST_VALUE & LAST_VALUE
SELECT username, posts,
  LAST_VALUE(posts) OVER (
    PARTITION BY username
    ORDER BY posts
    RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) as 'most_post'
FROM social_media;

-- result
-- username	posts	most_post
-- aliaabhatt	5	25
-- aliaabhatt	7	25
-- aliaabhatt	9	25
-- aliaabhatt	9	25
-- aliaabhatt	9	25
-- aliaabhatt	13	25
-- aliaabhatt	14	25
-- aliaabhatt	25	25

-- LAG
select
  artist,
  week,
  streams_millions,
  streams_millions - LAG(streams_millions, 1,streams_millions) OVER (
    ORDER BY week
  ) streams_millions_change,
  chart_position,
  LAG(chart_position, 1, chart_position) OVER (
    PARTITION BY artist
    ORDER BY week
  ) - chart_position as 'chart_position_change'
from streams
where artist='Lady Gaga';

-- result
-- artist	week	streams_millions	streams_millions_change	chart_position	chart_position_change
-- Lady Gaga	1	15.4	0.0	106	0
-- Lady Gaga	2	15.2	-0.2	112	-6
-- Lady Gaga	3	16.6	1.4	98	14
-- Lady Gaga	4	21.0	4.4	75	23
-- Lady Gaga	5	64.0	43.0	10	65
-- Lady Gaga	6	36.0	-28.0	24	-14
-- Lady Gaga	7	30.5	-5.5	36	-12
-- Lady Gaga	8	27.0	-3.5	47	-11


-- LEAD
SELECT
  artist,
  week,
  streams_millions,
  LEAD(streams_millions,1) OVER (
    PARTITION BY artist
    ORDER BY week
  ) - streams_millions as 'streams_millions_change',
  chart_position,
  chart_position - LEAD(chart_position,1) OVER (
    PARTITION BY artist
    ORDER BY week
  ) as 'chart_position_change'
FROM
  streams;
--  result
-- artist	week	streams_millions	streams_millions_change	chart_position	chart_position_change
-- Bad Bunny	1	33.7	35.9	25	14
-- Bad Bunny	2	69.6	-10.6	11	0
-- Bad Bunny	3	59.0	-9.3	11	-5
-- Bad Bunny	4	49.7	-7.4	16	-4
-- Bad Bunny	5	42.3	0.5	20	1
-- Bad Bunny	6	42.8	-1.1	19	-1
-- Bad Bunny	7	41.7	-2.4	20	-1
-- Bad Bunny	8	39.3		21	nan nan


-- NTILE
select
  ntile(4) over (
    partition by week
    order by streams_millions desc
  ) as 'quartile',
  artist,
  week,
  streams_millions
from
  streams;
-- result
-- quartile	artist	week	streams_millions
-- 1	Drake	1	288.2
-- 1	The Weeknd	1	76.3
-- 2	Luke Combs	1	55.8
-- 2	Taylor Swift	1	47.7
-- 3	Doja Cat	1	41.7
-- 3	Bad Bunny	1	33.7
-- 4	Beyoncé	1	26.3
-- 4	Lady Gaga	1	15.4
