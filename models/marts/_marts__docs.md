{% docs nba_games_detail_description %}
A breakdown of metrics & other context related to individual `games`.

This model is presented on a `game`-level granularity and built with reusability in mind. The expectations is that the data will be aggregated in various ways but access to the underlying data points will still be desired. Example aggregations include by date, team, conference, coach, etc.

The metrics in this model include (but not limited to):
* Total games played
* Home/away scores
* Point differentials
* Home vs Away wins

Other game & team related detail inslude (but not limited to):
* Team Names
* Head Coaches
* General Managers
* Day Info (Date, Weekday, Month)
* Game Status (Regulation, Overtime)
{% enddocs %}

{% docs latest_weather_day_description %}
A breakdown of daily weather metrics and contextual details for various cities.

This model is presented at a city-day granularity and is built with reusability in mind. The expectation is that the data will be aggregated in various ways, while still providing access to the most recent underlying weather readings.

The metrics in this model include (but are not limited to):
* Temperature and 'feels like' temperature
* Weather codes and descriptions
* Wind speed and direction
* Atmospheric pressure and precipitation
* Humidity, cloud cover, UV index, and visibility

Other contextual details include (but are not limited to):
* City, region, and country
* Geographic coordinates
* Local time and day/night indicator

The most recent weather record is selected per city per day using row ranking logic.
{% enddocs %}