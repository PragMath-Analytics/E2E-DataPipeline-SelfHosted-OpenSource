{% docs stg_nba__games_description %}
A game-level dataset capturing detailed information about NBA matches.

This model brings together team, score, and location metadata for each game and is structured to support both granular and aggregated analysis of game outcomes, schedules, and performance metrics.

Key game details include:
* Game identifiers and timestamps (ID, date, time, game_at)
* Team matchups (home/away team IDs and names)
* League and season context (league name, ID, season)
* Scoring breakdowns by team and by quarter, including overtime
* Game results (win indicators, point differential)
* Location metadata (country ID/code/name, timezone)
* Record metadata (created_at, is_latest)

This staging model supports downstream modeling like win-loss trends, home/away performance, and scheduling analytics.
{% enddocs %}

{% docs stg_nba__teams_description %}
A cleaned view of NBA team metadata, sourced from the `teams_response` table data.

This model contains one row per team and includes core identifying attributes for use in joins and reference lookups across other staging and mart models.

Included fields:
* Team ID and name
* Team logo URL
* Country of affiliation
* `is_latest` flag indicating most recent data snapshot

The model provides a reliable lookup table for enriching game- and player-level data with team context.
{% enddocs %}
