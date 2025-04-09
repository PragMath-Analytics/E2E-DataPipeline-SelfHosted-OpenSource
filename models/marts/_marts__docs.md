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