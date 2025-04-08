with

calendar_dates as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2018-01-01' as date)",
        end_date="cast('2050-12-31' as date)"
    )
    }}

),

final as (

    select
        -- Surrogate Key
        {{ dbt_utils.generate_surrogate_key(
            ['date(date_day)']
        )}} as calendar_date_sk,
 
        -- Descriptive Values
        date_day::date as date_day,
        extract(isodow from date_day) as day_of_week_number,
        extract(day from date_day) as day_of_month_number,
        extract(doy from date_day) as day_of_year_number,

        extract(week from date_day) as week_of_year_number,
        extract(month from date_day) as month_of_year_number,
        extract(quarter from date_day) as quarter_of_year_number,
        extract(year from date_day) as year_number,

        to_char(date_day, 'Dy') as short_weekday_name,
        to_char(date_day, 'Day') as full_weekday_name,
        to_char(date_day, 'Mon') as short_month_name,
        to_char(date_day, 'Month') as full_month_name,

        concat(to_char(date_day, 'Mon'), ' ', extract(year from date_day)) as short_month_year,

        concat(to_char(date_day, 'Month'), ' ', extract(year from date_day)) as full_month_year

    from calendar_dates

)

select * from final