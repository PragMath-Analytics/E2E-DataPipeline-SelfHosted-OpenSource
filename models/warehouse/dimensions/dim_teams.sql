with

teams as (
    select * from {{ ref('stg_nba__teams') }}
),

franchises as (
    select * from {{ ref('stg_gsheets__franchise_actives') }}
),

managers as (
    select * from {{ ref('stg_gsheets__franchise_general_managers') }}
),

coaches as (
    select * from {{ ref('stg_gsheets__franchise_head_coaches') }}
),

final as (
    
    select
        -- Surrogate Key
        {{ dbt_utils.generate_surrogate_key(
            ['teams.team_id',
             'franchises.team_id',
             'coaches.head_coach_id',
             'managers.general_manager_id']
        )}} as team_sk,

        -- Descriptive Values
        teams.team_id,
        teams.team_name,
        teams.team_logo_url,
        teams.country_name,
        franchises.year_started,
        coaches.head_coach,
        managers.general_manager,
        managers.division,
        managers.conference
        
        /*
        -- DW Values
        null as dw_is_active,
        null as dw_created_at,
        null as dw_updated_at,
        null as dw_is_deleted,
        null as dw_deleted_at
        */

    from teams

    left join franchises
        on teams.team_name = franchises.franchise_name
        and franchises.is_current
    
    left join managers
        on teams.team_name = managers.team_name

    left join coaches
        on teams.team_name = coaches.team_name

)

select * from final
