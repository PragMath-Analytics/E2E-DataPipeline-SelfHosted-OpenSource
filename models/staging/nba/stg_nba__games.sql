with

source_table as (
    select * from {{ source('nba', 'games') }}
),

final as (

    select
        id::integer as game_id,
        date::timestamp as game_at,
        date::date as game_date,
        time::time as game_time,

        -- teams
        (teams::jsonb->'away'->>'id')::integer as away_team_id,
        teams::jsonb->'away'->>'name' as away_team_name,
        (teams::jsonb->'home'->>'id')::integer as home_team_id,
        teams::jsonb->'home'->>'name' as home_team_name,

        -- league & season
        (league::jsonb->'id')::integer as league_id,
        replace((league::jsonb->'name')::text, '"','') as league_name,
        replace((league::jsonb->'season')::text, '"','') as season,

        -- away team scoring
        (scores::jsonb->'away'->>'total')::integer as away_team_score_total,
        (scores::jsonb->'away'->>'quarter_1')::integer as away_team_score_quarter_1,
        (scores::jsonb->'away'->>'quarter_2')::integer as away_team_score_quarter_2,
        (scores::jsonb->'away'->>'quarter_3')::integer as away_team_score_quarter_3,
        (scores::jsonb->'away'->>'quarter_4')::integer as away_team_score_quarter_4,
        (coalesce(scores::jsonb->'away'->>'over_time', '0'))::integer as away_team_score_overtime,

        -- home team scoring
        (scores::jsonb->'home'->>'total')::integer as home_team_score_total,
        (scores::jsonb->'home'->>'quarter_1')::integer as home_team_score_quarter_1,
        (scores::jsonb->'home'->>'quarter_2')::integer as home_team_score_quarter_2,
        (scores::jsonb->'home'->>'quarter_3')::integer as home_team_score_quarter_3,
        (scores::jsonb->'home'->>'quarter_4')::integer as home_team_score_quarter_4,
        (coalesce(scores::jsonb->'home'->>'over_time', '0'))::integer as home_team_score_overtime,


        -- Custom Metrics
        case
            when (scores::jsonb->'home'->>'total')::integer > (scores::jsonb->'away'->>'total')::integer
                then true
            else false
        end as is_home_team_win,

        case
            when (scores::jsonb->'home'->>'total')::integer < (scores::jsonb->'away'->>'total')::integer
                then true
            else false
        end as is_away_team_win,

        abs((scores::jsonb->'home'->>'total')::integer 
            - (scores::jsonb->'away'->>'total')::integer) as point_differential,


        -- status
        replace((status::jsonb->'long')::text, '"','') as status_long,
        replace((status::jsonb->'short')::text, '"','') as status_short,
            
        -- country
        (country::jsonb->'id')::integer as country_id,
        replace((country::jsonb->'code')::text, '"','') as country_code,
        replace((country::jsonb->'name')::text, '"','') as country_name,
            
        timezone,
        to_timestamp(timestamp) as created_at,

        row_number() over (partition by id order by _airbyte_emitted_at desc) = 1 is_latest

    from source_table

)

select * from final where is_latest
