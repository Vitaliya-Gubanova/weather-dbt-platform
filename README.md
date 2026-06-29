# Weather dbt Platform 

Слой трансформаций данных для погодной платформы на базе dbt (data build tool).

## Связь с проектами

Данные поступают из [weather-etl-pipeline](https://github.com/Vitaliya-Gubanova/weather-etl-pipeline).
Результаты визуализируются в [weather-analytics-dashboard](https://github.com/Vitaliya-Gubanova/weather-analytics-dashboard).

## Архитектура
weather.observations (PostgreSQL)

↓

stg_observations (staging, view)

↓

mart_city_weather (marts, table)

mart_weather_trends (marts, table)

↓

weather_analysis (analyses)

## Стек

| Инструмент | Версия | Назначение |
|-----------|--------|-----------|
| dbt-core | 1.12 | Трансформации и тесты |
| dbt-postgres | 1.10 | Адаптер PostgreSQL |
| PostgreSQL | 15 | Хранилище данных |

## Слои данных

**Staging** - очистка и стандартизация:
- Категоризация температуры (мороз / холодно / прохладно / тепло / жарко)
- Категоризация ветра (штиль / слабый / умеренный / сильный)
- Расчёт разницы между реальной и ощущаемой температурой

**Marts** — бизнес-модели:
- `mart_city_weather` - сводная статистика по городам с рангами
- `mart_weather_trends` - тренды с оконными функциями и скользящим средним

## Тесты

13 тестов качества данных:
- `unique` и `not_null` для ключевых полей
- `accepted_values` для категорий температуры
- Source tests для исходной таблицы

```bash
dbt test
# PASS=13 WARN=0 ERROR=0
```

## Запуск

```bash
git clone https://github.com/Vitaliya-Gubanova/weather-dbt-platform.git
cd weather-dbt-platform
python3 -m venv ~/.dbt-env
source ~/.dbt-env/bin/activate
pip install dbt-postgres
dbt debug   # проверка подключения
dbt run     # запуск моделей
dbt test    # запуск тестов
dbt docs generate && dbt docs serve --port 8090
```

## Lineage Graph

<img width="1837" height="735" alt="dbt-dag (2)" src="https://github.com/user-attachments/assets/c7537656-e415-4d46-876b-7e7112532a94" />


## Автор

**Виталия Губанова** 
