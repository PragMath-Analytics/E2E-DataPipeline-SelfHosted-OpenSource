## Our dbt Project
This repository consists of a [dbt](https://www.getdbt.com/) project that transforms raw data sources into clear, formatted models for Analytics.

To learn more about the overall architecture design & strategy can be found in our centralized handbook:
- [Data Architecture Handbook](https://docs.google.com/document/d/1WmOnx_5QaGmo-kNWitd9jSEwvEnwqxiS0ZA1jmMV-v0/edit?usp=sharing)

### Sources:
Raw, unformatted data loaded directly from source systems using various data tools.
- `nba_data` - The primary source of NBA statistics data captured from an API & loaded via Sling/Airbyte.
    - Schema: `analytics.raw_nba_data`
- `google_sheets` - Internally maintained reference sheets related to the project & loaded via Sling/Airbyte.
    - Schema: `analytics.raw_google_sheets`


### Environments:
Transformed data models built via dbt with 3 distinct environments to enable a sustainable development workflow.
- **Development**
   - Schema: `analytics.dev_[your-name]`
   - One per developer to avoid conflicts or overriding changes during development.
- **CI**
   - Schema: `analytics.ci`
   - An isolated schema created specifically for testing Pull Request changes to ensure quality.
- **Production**
   - Schemas: 
        - `analytics.staging`
        - `analytics.warehouse`
        - `analytics.marts`
   - Separation by layer for easier navigation and permission management.

### How to Get Started?
1. Create your local development environment
   - Use a local IDE (ex. VS Code), dbt Cloud or GitHub Codespaces
2. Clone the current repo (or create a new one)
   - Checkout the `main` branch and run `git pull` to sync changes
3. Create a New Branch for your new changes
   - First, run `git branch your_branch_name` to create a new branch
   - Then run `git checkout your_branch_name` to switch to it
4. Start developing!
   - Commit & Sync all changes to your branch during development
   - *IMPORTANT* - All changes should follow the team [Style Guide](_project_docs/style_guide.md)
5. Create Pull Request
   - When development is complete, Push your branch to GitHub & create a request
   - Request peer reviews & confirm  automated CI jobs succeed
6. Merge changes to the `main` branch
   - Confirm automated post-merge jobs succeed
7. Get latest changes in your local environment
   - Checkout the `main` branch in your local terminal
   - Run "git pull" to sync the latest version of the code
8. Continue to develop & repeat the process

### Notes
- Provide any other important call-outs of platform-specific information here.

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

