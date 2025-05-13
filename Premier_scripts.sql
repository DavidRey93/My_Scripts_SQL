-- 1. Union Tables
-- Insert a Season column into each table and performa a union
SELECT *, "1992-1993" as Season FROM premier_league.s1992_93
union
SELECT *, "1993-1994" as Season FROM premier_league.s1993_94
union
SELECT *, "1994-1995" as Season FROM premier_league.s1994_95
union
SELECT *, "1995-1996" as Season FROM premier_league.s1995_96
union
SELECT *, "1996-1997" as Season FROM premier_league.s1996_97
union
SELECT *, "1997-1998" as Season FROM premier_league.s1997_98
union
SELECT *, "1998-1999" as Season FROM premier_league.s1998_99
union
SELECT *, "1999-2000" as Season FROM premier_league.s1999_00
union
SELECT *, "2000-2001" as Season FROM premier_league.s2000_01
union
SELECT *, "2001-2002" as Season FROM premier_league.s2001_02
union
SELECT *, "2002-2003" as Season FROM premier_league.s2002_03
union
SELECT *, "2003-2004" as Season FROM premier_league.s2003_04
union
SELECT *, "2004-2005" as Season FROM premier_league.s2004_05
union
SELECT *, "2005-2006" as Season FROM premier_league.s2005_06
union
SELECT *, "2006-2007" as Season FROM premier_league.s2006_07
union
SELECT *, "2007-2008" as Season FROM premier_league.s2007_08
union
SELECT *, "2008-2009" as Season FROM premier_league.s2008_09
union
SELECT *, "2009-2010" as Season FROM premier_league.s2009_10
union
SELECT *, "2010-2011" as Season FROM premier_league.s2010_11
union
SELECT *, "2011-2012" as Season FROM premier_league.s2011_12
union
SELECT *, "2012-2013" as Season FROM premier_league.s2012_13
union
SELECT *, "2013-2014" as Season FROM premier_league.s2013_14
union
SELECT *, "2014-2015" as Season FROM premier_league.s2014_15
union
SELECT *, "2015-2016" as Season FROM premier_league.s2015_16
union
SELECT *, "2016-2017" as Season FROM premier_league.s2016_17
union
SELECT *, "2017-2018" as Season FROM premier_league.s2017_18
union
SELECT *, "2018-2019" as Season FROM premier_league.s2018_19
union
SELECT *, "2019-2020" as Season FROM premier_league.s2019_20
union
SELECT *, "2020-2021" as Season FROM premier_league.s2020_21
union
SELECT *, "2021-2022" as Season FROM premier_league.s2021_22
union
SELECT *, "2022-2023" as Season FROM premier_league.s2022_23
union
SELECT *, "2023-2024" as Season FROM premier_league.s2023_24;
-- I decided to download the new table and name it dirty_table




-- 2. Cleaning Teams
-- check how many teams are in `team 1` column in the table
select distinct `team 1`
from dirty_table
order by 1;

-- remove " FC" and update
update dirty_table
set `team 1`  = replace(`team 1`," FC","");

-- remove "AFC " | " AFC" and update
update dirty_table
set `team 1`  = replace(`team 1`," AFC","");
update dirty_table
set `team 1`  = replace(`team 1`,"AFC ","");

-- check again
select distinct `team 1`
from dirty_table
order by 1;

-- remove duplicates
update dirty_table
set `team 1` = replace(`team 1`,"Brighton & Hove Albion","Brighton");
update dirty_table
set `team 1` = replace(`team 1`,"Manchester Utd","Manchester United");
update dirty_table
set `team 1` = replace(`team 1`,"Newcastle Utd","Newcastle United");
update dirty_table
set `team 1` = replace(`team 1`,"Nott'ham Forest","Nottingham Forest");
update dirty_table
set `team 1` = replace(`team 1`,"Sheffield Utd","Sheffield United");
update dirty_table
set `team 1` = replace(`team 1`,"Tottenham Hotspur","Tottenham");
update dirty_table
set `team 1` = replace(`team 1`,"West Bromwich Albion","West Brom");
update dirty_table
set `team 1` = replace(`team 1`,"West Ham United","West Ham");
update dirty_table
set `team 1` = replace(`team 1`,"Wolverhampton Wanderers","Wolves");

-- final check 
select distinct `team 1`
from dirty_table
order by 1;

-- Repeat with column `team 2`

select distinct `team 2`
from dirty_table
order by 1;

update dirty_table
set `team 2`  = replace(`team 2`," FC","");

update dirty_table
set `team 2`  = replace(`team 2`," AFC","");
update dirty_table
set `team 2`  = replace(`team 2`,"AFC ","");

update dirty_table
set `team 2` = replace(`team 2`,"Brighton & Hove Albion","Brighton");
update dirty_table
set `team 2` = replace(`team 2`,"Manchester Utd","Manchester United");
update dirty_table
set `team 2` = replace(`team 2`,"Newcastle Utd","Newcastle United");
update dirty_table
set `team 2` = replace(`team 2`,"Nott'ham Forest","Nottingham Forest");
update dirty_table
set `team 2` = replace(`team 2`,"Sheffield Utd","Sheffield United");
update dirty_table
set `team 2` = replace(`team 2`,"Tottenham Hotspur","Tottenham");
update dirty_table
set `team 2` = replace(`team 2`,"West Bromwich Albion","West Brom");
update dirty_table
set `team 2` = replace(`team 2`,"West Ham United","West Ham");
update dirty_table
set `team 2` = replace(`team 2`,"Wolverhampton Wanderers","Wolves");




-- 3. Cleaning Columns
-- insert and update columns based on `team 1`
select 
		row_number() over (order by season) as Match_No, 
        Round,
        STR_TO_DATE(date,'%a %b %d %Y') as Date,
        Season,
        `team 1` as Team,
        left(FT,1) as GF,
        right(FT,1) as GA,
        left(FT,1) - right(FT,1) as GD,
        case
			when left(FT,1) - right(FT,1) > 0 then "Win"
            when left(FT,1) - right(FT,1) = 0 then "Draw"
            else "Loss" end as Result,
		case
			when left(FT,1) - right(FT,1) > 0 then 3
            when left(FT,1) - right(FT,1) = 0 then 1
            else 0 end as PTS,
        "Home" as Home_Away
from dirty_table
order by 3;

-- copy and paste the code, repeat the process for `team 2`, and perform an union
select 
		row_number() over (order by season) as Match_No,
        Round,
        STR_TO_DATE(date,'%a %b %d %Y') as Date,
        Season,
        `team 1` as Team,
        left(FT,1) as GF,
        right(FT,1) as GA,
        left(FT,1) - right(FT,1) as GD,
        case
			when left(FT,1) - right(FT,1) > 0 then "Win"
            when left(FT,1) - right(FT,1) = 0 then "Draw"
            else "Loss" end as Result,
		case
			when left(FT,1) - right(FT,1) > 0 then 3
            when left(FT,1) - right(FT,1) = 0 then 1
            else 0 end as PTS,
        "Home" as Home_Away
from dirty_table

union

select 
		row_number() over (order by season) as Match_No,
        Round,
        STR_TO_DATE(date,'%a %b %d %Y') as Date,
        Season,
        `team 2` as Team,
        right(FT,1) as GF,
        left(FT,1) as GA,
        right(FT,1) - left(FT,1) as GD,
        case
			when right(FT,1) - left(FT,1) > 0 then "Win"
            when right(FT,1) - left(FT,1) = 0 then "Draw"
            else "Loss" end as Result,
		case
			when right(FT,1) - left(FT,1) > 0 then 3
            when right(FT,1) - left(FT,1) = 0 then 1
            else 0 end as PTS,
        "Away" as Home_Away
from dirty_table
order by 3,1,11 desc;

-- finally, download the new table
