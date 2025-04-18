{% docs stg_weatherapi__weather_description %}
A staging model that represents weather snapshot data across various global cities.

This model standardizes location, atmospheric, and observational weather details collected via the Weatherstack API. It serves as a foundational layer for downstream modeling of weather trends and environmental conditions.

Included attributes cover (but are not limited to):
* Location context (city, region, country, latitude, longitude, timezone)
* Observation timestamp (`local_time`)
* Temperature, feels-like temperature, and weather descriptions
* Atmospheric data (pressure, humidity, UV index, cloud cover, visibility)
* Wind metrics (speed, degree, direction)
* Day/night indicator (`is_day`)

The data originates from the `weather_data` table in the `weather` schema of the `analytics` database.
{% enddocs %}
