-- create season column for every table
alter table s2023_2024_regular
add column Season varchar(10);

alter table s2023_2024_playoffs
add column Season varchar(10);

alter table s2022_2023_regular
add column Season varchar(10);

alter table s2022_2023_playoffs
add column Season varchar(10);

alter table s2021_2022_regular
add column Season varchar(10);

alter table s2021_2022_playoffs
add column Season varchar(10);


-- Fill the empty column based on the season information from each table
update s2023_2024_regular
set season = "2023-2024";

update s2023_2024_playoffs
set season = "2023-2024";

update s2022_2023_regular
set season = "2022-2023";

update s2022_2023_playoffs
set season = "2022-2023";

update s2021_2022_regular
set season = "2021-2022";

update s2021_2022_playoffs
set season = "2021-2022";


-- create the table by joining each of the seasons and stages
create table nba as
select * from s2023_2024_regular
union
select * from s2023_2024_playoffs
union
select * from s2022_2023_regular
union
select * from s2022_2023_playoffs
union
select * from s2021_2022_regular
union
select * from s2021_2022_playoffs;


-- drop useless columns and those that can be calculated in excel, power BI, Tableau etc 
alter table nba
drop column RK,
drop column Age,
drop column GS,
drop column `FG%`,
drop column `3P%`,
drop column `2P%`,
drop column `eFG%`,
drop column `FT%`,
drop column TRB,
drop column PTS,
drop column `Trp-Dbl`,
drop column Awards,
drop column `Player-additional`;


-- Some players played for 2 or more different teams. I divided their stats according to each team, 
-- so the remaining summary rows ('2tm', '3tm', '4tm') can be deleted
delete from nba
where team in ("2tm","3tm","4tm");


-- update teams and positions names
update nba
set team = case team
	when "MIL" then "Milwaukee Bucks"
    when "PHO" then "Phoenix Suns"
    when "LAC" then "Los Angeles Clippers" 
    when "ATL" then "Atlanta Hawks" 
    when "BRK" then "Brooklyn Nets" 
    when "UTA" then "Utah Jazz" 
    when "PHI" then "Philadelphia 76ers" 
    when "DEN" then "Denver Nuggets" 
    when "DAL" then "Dallas Mavericks" 
    when "POR" then "Portland Trail Blazers" 
    when "BOS" then "Boston Celtics" 
    when "MEM" then "Memphis Grizzlies" 
    when "WAS" then "Washington Wizards" 
    when "LAL" then "Los Angeles Lakers" 
    when "NYK" then "New York Knicks" 
    when "MIA" then "Miami Heat" 
    when "GSW" then "Golden State Warriors" 
    when "NOP" then "New Orleans Pelicans" 
    when "MIN" then "Minnesota Timberwolves" 
    when "TOR" then "Toronto Raptors" 
    when "CHI" then "Chicago Bulls" 
    when "SAC" then "Sacramento Kings" 
    when "CLE" then "Cleveland Cavaliers" 
    when "IND" then "Indiana Pacers" 
    when "OKC" then "Oklahoma City Thunder" 
    when "ORL" then "Orlando Magic" 
    when "DET" then "Detroit Pistons" 
    when "CHO" then "Charlotte Hornets"
	when "HOU" then "Houston Rockets"
    when "SAS" then "San Antonio Spurs"
    else team
end;

update nba
set Pos = case Pos
	when "PF" then "Power Forward"
    when "SG" then "Shooting Guard"
    when "SF" then "Small Forward"
    when "PG" then "Point Guard"
    when "C" then "Center"
else Pos
end;


-- group by player, team and season because there are 2 tables (regular and playoff) for each season. 
-- Therefore, there will be no duplicate players in the same season. Finally, apply the sum() function for each numerical stats, 
-- rename the columns, create the final table and download it.
create table nba_stats as
select 
	Player,
    Team,
    Season,
    Pos as Position,
    sum(G) as Games,
    sum(MP) as Minutes_played,
    sum(FG) as Field_goals,
    sum(FGA) as Field_goals_attempts,
    sum(3P) as 3pts_fg,
    sum(3PA) as 3pts_fga,
    sum(2P) as 2pts_fg,
    sum(2PA) as 2pts_fga,
    sum(FT) as Free_throws,
    sum(FTA) as Free_throws_attempts,
    sum(ORB) as Offensive_rebounds,
    sum(DRB) as Defensive_rebounds,
    sum(AST) as Assists,
    sum(STL) as Steals,
    sum(BLK) as Blocks,
    sum(TOV) as Turnovers,
    sum(PF) as Personal_fouls
        from nba
group by 1,2,3;