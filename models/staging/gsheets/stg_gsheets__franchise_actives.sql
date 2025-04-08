with

source_table as (
    select * from {{ source('franchises', 'actives') }}
),

final as (

    select 
        TEAM_ID::int as team_id,
        FRANCHISE_ID::int as franchise_id,
        FRANCHISE_NAME as franchise_name,
        URL as url,
        "start"::int as year_started,
        "end"::int as year_ended,
        YEARS::int as years_active,
        GP::int as games_played,
        WINS::int as wins,
        LOSSES::int as losses,
        WIN::numeric / 100 as winning_percentage,
        PO::int as playoffs_made,
        DIV__TITLES::int as division_titles,
        CONF__TITLES::int as conference_titles,
        LEAGUE_TITLES::int as league_titles,
        "end" is null as is_current

    from source_table

)

select * from final
