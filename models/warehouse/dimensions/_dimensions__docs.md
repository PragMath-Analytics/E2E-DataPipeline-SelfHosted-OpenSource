{% docs dim_calendar_dates_description %}
A date dimension table spanning from January 1, 2018 to December 31, 2050.

This model provides rich calendar context for time-based analysis across reporting layers. Each row represents a single date and includes attributes for common groupings and filters.

Included fields:
* Core date parts (day, week, month, quarter, year)
* Day of week and month names (short and full)
* Month-year combinations (e.g., `Jan 2025`, `January 2025`)
* Surrogate key `calendar_date_sk`, generated using an MD5 hash of the date

This dimension is intended for joining with fact tables to support time-aware aggregations, filtering, and reporting.
{% enddocs %}


{% docs dim_games_description %}
A dimension table representing enriched metadata about NBA games.

This model provides a cleaned and structured view of each game and its associated context, including teams, league, location, and outcomes. It is sourced from the `stg_nba__games` staging model.

Included attributes:
* Game identifiers and timestamps
* Home and away team IDs and names
* League, season, and game status details
* Country and timezone metadata
* Win/loss flags (`is_home_team_win`, `is_away_team_win`)
* Creation timestamp for data lineage

This dimension is useful for joining into fact tables or for filtering and slicing game-level analysis.
{% enddocs %}


{% docs dim_teams_description %}
A dimension table containing enriched information about NBA teams.

This model consolidates team attributes from multiple sources to provide a unified reference for reporting and analysis. It is built at the team level and includes franchise metadata joined on team name and active status.

Included attributes cover (but are not limited to):
* Team ID, name, and logo URL
* Country and year started
* Head coach and general manager
* Division and conference

The data is sourced from:
* `stg_nba__teams`
* `stg_gsheets__franchise_actives`
* `stg_gsheets__franchise_general_managers`
* `stg_gsheets__franchise_head_coaches`

The model uses left joins to combine these sources based on team name and current franchise status.
{% enddocs %}

