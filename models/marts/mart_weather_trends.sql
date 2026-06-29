with stg as (
    select * from {{ ref('stg_observations') }}
),

trends as (
    select
        city,
        observed_at,
        temperature_c,
        feels_like_c,
        humidity,
        wind_speed_ms,
        weather_desc,
        temp_category,
        avg(temperature_c) over (
            partition by city
            order by observed_at
            rows between 3 preceding and current row
        )                                           as temp_moving_avg_4h,
        lag(temperature_c) over (
            partition by city
            order by observed_at
        )                                           as prev_temp_c,
        temperature_c - lag(temperature_c) over (
            partition by city
            order by observed_at
        )                                           as temp_change_c,
        row_number() over (
            partition by city
            order by observed_at desc
        )                                           as recency_rank
    from stg
)

select
    *,
    case
        when temp_change_c > 2  then 'потепление'
        when temp_change_c < -2 then 'похолодание'
        else 'стабильно'
    end as trend
from trends