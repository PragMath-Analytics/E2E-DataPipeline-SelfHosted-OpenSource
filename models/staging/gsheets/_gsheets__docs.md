{% docs stg_gsheets__franchise_actives_description %}
A breakdown of active franchise metadata sourced from the `franchise_actives` sheet in Google Storage.

This model is structured with a `game`-level grain and built for reusability in downstream aggregations. While it supports rollups by various dimensions (date, team, coach, etc.), access to individual-level details is retained to enable flexible slicing.

The data includes (but is not limited to):
* Total games played
* Home and away team scores
* Point differentials
* Home vs away win outcomes

It also contains core franchise metadata such as:
* Team Names
* Head Coaches
* General Managers
* Day Info (Date, Weekday, Month)
* Game Status (Regulation, Overtime)
{% enddocs %}

{% docs stg_gsheets__franchise_general_managers %}
A lookup of general managers tied to each franchise, sourced from the `franchise_general_managers` sheet in Google Storage.

This model serves as a static dimension containing high-level franchise leadership context. It can be joined with game-level or franchise-level models to enrich analysis and enable attribution across seasons and team histories.

Included fields may cover:
* General Manager names
* Team associations
* Time periods of tenure
* Notes or context for leadership transitions
{% enddocs %}

{% docs stg_gsheets__franchise_head_coaches %}
A curated view of franchise head coaches, sourced from the `franchise_coaches` sheet in Google Storage.

This model presents one record per coach per team, offering contextual leadership data for each franchise. It’s built to support both historical reference and tenure-based analytics.

Included fields provide (but are not limited to):
* Coach ID and name
* Team affiliation
* Division and conference alignment
* Start and 'as of' dates (cast as `DATE`)
* Years active (calculated as the difference between start year and as-of year)

This model helps answer questions about coaching stability, leadership trends, and cross-franchise comparisons.
{% enddocs %}