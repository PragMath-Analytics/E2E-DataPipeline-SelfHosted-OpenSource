{% docs stg_gsheets__franchise_actives_description %}
A cleaned and structured transformation of franchise metadata from the `raw_google_sheets.franchise_actives` table.

This model provides historical and current data for sports franchises and is optimized for downstream analysis across performance and status metrics.

Included attributes cover (but are not limited to):
* Franchise ID, name, and reference URL
* Years of activity (start and end)
* Games played, wins, losses, and win percentage
* Titles and achievements (playoff appearances, division, conference, and league titles)
* Boolean flag for current franchise activity status

All fields are cleaned and cast into appropriate data types to support reporting and model joins.
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