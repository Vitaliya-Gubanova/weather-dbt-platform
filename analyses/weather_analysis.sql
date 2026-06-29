-- Топ-3 самых тёплых города
select city, avg_temp_c, temp_rank
from {{ ref('mart_city_weather') }}
where temp_rank <= 3
order by temp_rank;

-- Города где наблюдается потепление прямо сейчас
select city, temperature_c, prev_temp_c, temp_change_c, trend
from {{ ref('mart_weather_trends') }}
where recency_rank = 1
  and trend = 'потепление'
order by temp_change_c desc;