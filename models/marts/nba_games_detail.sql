with

fct_games_played as (
    select * from {{ ref('fct_games_played') }}
),

dim_games as (
    select * from {{ ref('dim_games') }}
),

dim_teams as (
    select * from {{ ref('dim_teams') }}
),

dim_calendar_dates as (
    select * from {{ ref('dim_calendar_dates') }}
),

final as (

  select
      dim_games.game_id,
      dim_games.game_date,
      dim_calendar_dates.short_weekday_name,
      dim_calendar_dates.short_month_name,
      dim_calendar_dates.short_month_year,
      dim_games.status_long,

      home_teams.team_name as home_team_name,
      home_teams.head_coach as home_team_head_coach,
      home_teams.general_manager as home_team_general_manager,
      home_teams.division as home_team_division,
      home_teams.conference as home_team_conference,
  
      away_teams.team_name as away_team_name,
      away_teams.head_coach as away_team_head_coach,
      away_teams.general_manager as away_team_general_manager,
      away_teams.division as away_team_division,
      away_teams.conference as away_team_conference,
  
      fct_games_played.home_team_score_total,
      fct_games_played.home_team_score_quarter_1,
      fct_games_played.home_team_score_quarter_2,
      fct_games_played.home_team_score_quarter_3,
      fct_games_played.home_team_score_quarter_4,
      fct_games_played.home_team_score_overtime,
      fct_games_played.average_home_pts_per_quarter,

      fct_games_played.away_team_score_total,
      fct_games_played.away_team_score_quarter_1,
      fct_games_played.away_team_score_quarter_2,
      fct_games_played.away_team_score_quarter_3,
      fct_games_played.away_team_score_quarter_4,
      fct_games_played.away_team_score_overtime,
      fct_games_played.average_away_pts_per_quarter,

      fct_games_played.point_differential,
      fct_games_played.home_team_win_count,
      fct_games_played.away_team_win_count
    
  from fct_games_played

  left join dim_games
    on fct_games_played.game_sk = dim_games.game_sk

  left join dim_teams as home_teams
    on fct_games_played.home_team_sk = home_teams.team_sk

  left join dim_teams as away_teams
    on fct_games_played.away_team_sk = away_teams.team_sk

  left join dim_calendar_dates
    on fct_games_played.game_date_sk = dim_calendar_dates.calendar_date_sk

  where dim_games.status_long != 'Not Started'

)

select * from final order by game_date desc 
