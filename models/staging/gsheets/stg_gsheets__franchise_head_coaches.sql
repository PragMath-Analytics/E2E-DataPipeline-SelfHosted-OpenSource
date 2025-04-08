with

source_table as (
    select * from {{ source('franchises', 'head_coaches') }}
),

final as (

    select 
        ID as head_coach_id,
        HEAD_COACH as head_coach,
        TEAM as team_name,
        DIVISION as division,
        CONFERENCE as conference,
        START_DATE::date as start_date,
        AS_OF_DATE::date as as_of_date,
        date_part('year', AS_OF_DATE::date) - date_part('year', START_DATE::date) as years_active

    from source_table

)

select * from final
