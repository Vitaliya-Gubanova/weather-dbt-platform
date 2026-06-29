with source as (
    select * from {{ source('weather', 'observations') }}
),

renamed as (
    select
        id,
        city,
        country,
        temperature_c,
        feels_like_c,
        humidity,
        wind_speed_ms,
        wind_direction,
        weather_desc,
        pressure_hpa,
        visibility_m,
        observed_at,
        fetched_at,
        temperature_c - feels_like_c           as feels_diff_c,
        case
            when temperature_c < 0  then 'мороз'
            when temperature_c < 10 then 'холодно'
            when temperature_c < 20 then 'прохладно'
            when temperature_c < 28 then 'тепло'
            else 'жарко'
        end                                    as temp_category,
        case
            when wind_speed_ms < 2  then 'штиль'
            when wind_speed_ms < 6  then 'слабый ветер'
            when wind_speed_ms < 12 then 'умеренный ветер'
            else 'сильный ветер'
        end                                    as wind_category
    from source
)

select * from renamed