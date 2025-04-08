with

games as (
    select * from {{ ref('stg_nba__games') }}
),

final as (
    
    select
        -- Surrogate Key
        {{ dbt_utils.generate_surrogate_key(
            ['game_id']
        )}} as game_sk,

        -- Descriptive Values
        game_id,
        home_team_id,
        home_team_name,
        away_team_id,
        away_team_name,
        league_id,
        league_name,
        season,
        
        status_long,
        status_short,
        country_id,
        country_code,
        country_name,
        timezone,
    
        -- Booleans
        is_home_team_win,
        is_away_team_win,

        -- Dates
        game_date,
        game_time,
        game_at,
        created_at  
        
        /*
        -- DW Values
        null as dw_is_active,
        null as dw_created_at,
        null as dw_updated_at,
        null as dw_is_deleted,
        null as dw_deleted_at
        */

    from games

)

select * from final
