"""

This script fetches real-time weather data from the Weatherstack API for a specified city,
normalizes and processes the data, and loads it into a PostgreSQL database using environment
variables for configuration. The script also deduplicates the inserted records using a hash-based
approach and PostgreSQL CTE.

Workflow:
1. Fetch weather data using the Weatherstack API.
2. Normalize the JSON response and sanitize column names.
3. Create a SHA-256 hash of each row to detect duplicates.
4. Insert the data into a PostgreSQL table.
5. Perform deduplication using SQL.

Environment Variables Required:
- API_KEY
- SLING_USER
- SLING_PASSWORD
- DATABASE_HOST
- DATABASE_PORT

Author: Max
Date: 2025-04-16
"""

import os
import requests
import pandas as pd
import urllib.parse
from sqlalchemy import create_engine, text
import hashlib
import json

# ---------- Step 1: Fetch Weather Data ----------
def fetch_weather_data(city: str) -> dict:
    """
    Fetch current weather data for a given city using the Weatherstack API.

    Args:
        city (str): Name of the city to fetch weather data for.

    Returns:
        dict: Parsed JSON response from the API.

    Raises:
        Exception: If the API request fails or returns an error.
    """
    api_key = os.environ["API_KEY"]
    url = f"http://api.weatherstack.com/current?access_key={api_key}&query={urllib.parse.quote_plus(city)}"

    response = requests.get(url)
    data = response.json()

    if not data.get("success", True):
        raise Exception(f"API error: {data.get('error', {}).get('info', 'Unknown')}")

    return data

# ---------- Step 2: Normalize + Hash ----------
def normalize_weather_data(data: dict) -> pd.DataFrame:
    """
    Normalize and flatten the weather data JSON, sanitize column names, and generate a hash for each row.

    Args:
        data (dict): Raw JSON response from the API.

    Returns:
        pd.DataFrame: Cleaned and processed DataFrame with a 'record_hash' column.
    """
    df = pd.json_normalize(data)
    df.columns = df.columns.str.replace(r"\.", "_", regex=True)

    def row_hash(row):
        row_str = json.dumps(row.to_dict(), sort_keys=True)
        return hashlib.sha256(row_str.encode("utf-8")).hexdigest()

    df["record_hash"] = df.apply(row_hash, axis=1)
    return df

# ---------- Step 3: Create Database Engine ----------
def get_db_engine():
    """
    Create and return a SQLAlchemy engine using environment variables.

    Returns:
        sqlalchemy.Engine: Database connection engine.
    """
    db_user = os.environ["SLING_USER"]
    db_password = urllib.parse.quote_plus(os.environ["SLING_PASSWORD"])
    db_host = os.environ["DATABASE_HOST"]
    db_port = os.environ["DATABASE_PORT"]
    db_name = "analytics"

    return create_engine(
        f"postgresql+psycopg2://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
    )

# ---------- Step 4: Ensure Schema ----------
def ensure_schema_exists(engine, schema: str):
    """
    Ensure the PostgreSQL schema exists.

    Args:
        engine (sqlalchemy.Engine): SQLAlchemy engine.
        schema (str): Schema name.
    """
    with engine.begin() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {schema}"))

# ---------- Step 5: Insert Data ----------
def insert_weather_data(engine, df: pd.DataFrame, schema: str, table: str):
    """
    Insert the processed weather DataFrame into the target table.

    Args:
        engine (sqlalchemy.Engine): SQLAlchemy engine.
        df (pd.DataFrame): Weather data with record_hash.
        schema (str): Target schema.
        table (str): Target table.
    """
    df.to_sql(table, engine, schema=schema, if_exists="append", index=False)
    print(f"✅ Data Inserted to {schema}.{table}")

# ---------- Step 6: Deduplicate Data ----------
def deduplicate_weather_data(engine, schema: str, table: str):
    """
    Remove duplicate records from the weather data table based on the record_hash.

    Args:
        engine (sqlalchemy.Engine): SQLAlchemy engine.
        schema (str): Schema name.
        table (str): Table name.
    """
    dedup_sql = f"""
    DELETE FROM {schema}.{table}
    WHERE ctid NOT IN (
        SELECT min(ctid)
        FROM {schema}.{table}
        GROUP BY record_hash
    );
    """
    with engine.begin() as conn:
        conn.execute(text(dedup_sql))
        print(f"🧹 Deduplication complete in {schema}.{table}")

# ---------- Main ----------
def main():
    """
    Main function to run the complete ETL workflow:
    - Fetch data
    - Normalize and hash
    - Load to DB
    - Deduplicate records
    """
    try:
        city = "New York"
        schema = "weather"
        table = "weather_data"

        print("📡 Fetching weather data...")
        raw_data = fetch_weather_data(city)

        print("🧪 Normalizing data...")
        df = normalize_weather_data(raw_data)

        print("🔌 Connecting to database...")
        engine = get_db_engine()

        print("🏗️ Ensuring schema exists...")
        ensure_schema_exists(engine, schema)

        print("📥 Inserting data...")
        insert_weather_data(engine, df, schema, table)

        print("🧽 Deduplicating data...")
        deduplicate_weather_data(engine, schema, table)

    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    main()
