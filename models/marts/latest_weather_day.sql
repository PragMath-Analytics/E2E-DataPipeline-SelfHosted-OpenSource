with

stg_weatherapi__weather as (
    select * from {{ ref('stg_weatherapi__weather') }}
),

ranked as (
    select *,
        row_number() over (
            partition by city, date_trunc('day', local_time)
            order by local_time desc
        ) as rn
    from stg_weatherapi__weather
),

final as (
    select *
    from ranked
    where rn = 1
)

select * from final
