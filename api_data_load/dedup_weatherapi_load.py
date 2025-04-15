import os
import requests
import pandas as pd
import urllib.parse
from sqlalchemy import create_engine, text
from datetime import datetime
import hashlib
import json

# Step 1: API request
api_key = os.environ["API_KEY"]
url = f"http://api.weatherstack.com/current?access_key={api_key}&query=New%20York"

payload = {}
headers = {}

response = requests.request("GET", url, headers=headers, data=payload)

data = response.json()

# Skip load if API returns error
if not data.get("success", True):
    print("❌ API error:", data.get("error", {}).get("info", "Unknown"))
    exit(1)

# Step 2: Normalize
df = pd.json_normalize(data)

# Sanitize column names
df.columns = df.columns.str.replace(r"\.", "_", regex=True)

def row_hash(row):
    row_str = json.dumps(row.to_dict(), sort_keys=True)
    return hashlib.sha256(row_str.encode("utf-8")).hexdigest()

df["record_hash"] = df.apply(row_hash, axis=1)

# Postgres connection config
db_user = os.environ["SLING_USER"]
db_password = urllib.parse.quote_plus(os.environ["SLING_PASSWORD"])
db_host = os.environ["DATABASE_HOST"]
db_port = os.environ["DATABASE_PORT"]
db_name = "analytics"
db_schema = "weather"
table_name = "weather_data"

# Create DB engine
engine = create_engine(f"postgresql+psycopg2://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}")

# Create schema if needed
with engine.begin() as conn:
    conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {db_schema}"))

# Load new data
df.to_sql(table_name, engine, schema=db_schema, if_exists="append", index=False)
print(f"✅ Data Inserted to {db_schema}.{table_name}")

# Step 7: Deduplicate using SQL (Postgres CTE)
dedup_sql = f"""
DELETE FROM {db_schema}.{table_name}
WHERE ctid NOT IN (
    SELECT min(ctid)
    FROM {db_schema}.{table_name}
    GROUP BY record_hash
);
"""

# Execute the deduplication
with engine.begin() as conn:
    conn.execute(text(dedup_sql))
    print(f"🧹 Deduplication complete in {db_schema}.{table_name}")