with

games as (
    select * from {{ ref('stg_nba__games') }}
),

dim_games as (
    select * from {{ ref('dim_games') }}
),

dim_teams as (
    select * from {{ ref('dim_teams') }}
),

final as (

    select
        -- Surrogate Key
        {{ dbt_utils.generate_surrogate_key(
            ['dim_games.game_sk',
            'home_teams.team_sk',
            'away_teams.team_sk',
            'date(games.game_at)'
            ]
        )}} as fct_game_played_sk,

        -- Dimension Keys
        dim_games.game_sk,
        home_teams.team_sk as home_team_sk,
        away_teams.team_sk as away_team_sk,
                
        {{ dbt_utils.generate_surrogate_key(
            ['date(games.game_at)']
        )}} as game_date_sk,

        -- Numeric Values        
        games.home_team_score_total,
        games.home_team_score_quarter_1,
        games.home_team_score_quarter_2,
        games.home_team_score_quarter_3,
        games.home_team_score_quarter_4,
        games.home_team_score_overtime,
        round(games.home_team_score_total / 4, 2) as average_home_pts_per_quarter,

        games.away_team_score_total,
        games.away_team_score_quarter_1,
        games.away_team_score_quarter_2,
        games.away_team_score_quarter_3,
        games.away_team_score_quarter_4,
        games.away_team_score_overtime,
        round(games.home_team_score_total / 4, 2) as average_away_pts_per_quarter,

        games.point_differential,

        case
            when games.is_home_team_win then 1
            else 0
        end as home_team_win_count,

        case
            when not games.is_home_team_win then 1
            else 0
        end as home_team_loss_count,

        case
            when games.is_away_team_win then 1
            else 0
        end as away_team_win_count,

        case
            when not games.is_away_team_win then 1
            else 0
        end as away_team_loss_count,

        -- Dates (for simplicity)
        games.game_at

    from games

    left join dim_games
        on games.game_id = dim_games.game_id

    left join dim_teams as home_teams
        on games.home_team_id = home_teams.team_id

    left join dim_teams as away_teams
        on games.away_team_id = away_teams.team_id

)

select * from final
