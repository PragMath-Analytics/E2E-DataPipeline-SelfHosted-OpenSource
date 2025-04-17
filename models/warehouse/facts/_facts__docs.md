{% docs fct_games_played_description %}
A fact table capturing detailed metrics for each NBA game played.

This model combines enriched game context with team performance metrics at the game level. It is designed to support time-series analysis, win/loss tracking, and score-based aggregations.

Sourced from `stg_nba__games`, `dim_games`, and `dim_teams`, the model includes:

* Game, home team, away team, and date surrogate keys
* Total scores and per-quarter/overtime scores for both teams
* Average points per quarter for home and away teams
* Point differentials and win/loss indicators
* Game timestamp for exact event ordering

This fact model is intended for reporting on game outcomes, point trends, and team performance across seasons.
{% enddocs %}
