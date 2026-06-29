with stg as (
    select * from {{ ref('stg_observations') }}
),

city_stats as (
    select
        city,
        country,
        count(*)                            as total_observations,
        round(avg(temperature_c)::numeric, 1)   as avg_temp_c,
        round(max(temperature_c)::numeric, 1)   as max_temp_c,
        round(min(temperature_c)::numeric, 1)   as min_temp_c,
        round(avg(feels_like_c)::numeric, 1)    as avg_feels_like_c,
        round(avg(humidity)::numeric, 1)        as avg_humidity_pct,
        round(avg(wind_speed_ms)::numeric, 1)   as avg_wind_ms,
        round(avg(pressure_hpa)::numeric, 1)    as avg_pressure_hpa,
        mode() within group (order by temp_category)  as most_common_temp_cat,
        mode() within group (order by wind_category)  as most_common_wind_cat,
        mode() within group (order by weather_desc)   as most_common_weather,
        min(observed_at)                    as first_observed_at,
        max(observed_at)                    as last_observed_at
    from stg
    group by city, country
)

select
    *,
    rank() over (order by avg_temp_c desc)  as temp_rank,
    rank() over (order by avg_humidity_pct desc) as humidity_rank
from city_stats