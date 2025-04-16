"""

Fetches real-time weather data for a list of cities from the Weatherstack API and loads it
into a PostgreSQL database. The list of cities is read from a YAML config file, and all credentials
are loaded from environment variables. The script normalizes the data and inserts it into a
target schema and table.

Steps:
1. Load cities from a YAML file
2. Load credentials from environment variables
3. Fetch, normalize, and insert weather data for each city

"""

import os
import yaml
import requests
import pandas as pd
import urllib.parse
from sqlalchemy import create_engine, text

# ---------- Config Loaders ----------
def load_yaml_config(path: str) -> list:
    """
    Load the list of cities from a YAML configuration file.

    Args:
        path (str): Path to the YAML config file.

    Returns:
        list: List of city names.
    """
    with open(path, "r") as file:
        config = yaml.safe_load(file)
    return config["cities"]


def get_db_engine():
    """
    Create and return a SQLAlchemy engine for PostgreSQL.

    Uses environment variables:
        SLING_USER, SLING_PASSWORD, DATABASE_HOST, DATABASE_PORT

    Returns:
        sqlalchemy.Engine: SQLAlchemy engine for database connection.
    """
    db_user = os.environ["SLING_USER"]
    db_password = urllib.parse.quote_plus(os.environ["SLING_PASSWORD"])
    db_host = os.environ["DATABASE_HOST"]
    db_port = os.environ["DATABASE_PORT"]
    db_name = "analytics"
    return create_engine(f"postgresql+psycopg2://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}")

# ---------- Weather Data Logic ----------
def fetch_weather_data(city: str, api_key: str) -> dict:
    """
    Fetch current weather data for a given city using the Weatherstack API.

    Args:
        city (str): City name.
        api_key (str): API key for Weatherstack.

    Returns:
        dict: Parsed JSON response from the API.

    Raises:
        Exception: If the API response indicates an error.
    """
    url = f"http://api.weatherstack.com/current?access_key={api_key}&query={urllib.parse.quote_plus(city)}"
    response = requests.get(url)
    data = response.json()

    if not data.get("success", True):
        raise Exception(f"API error for {city}: {data.get('error', {}).get('info', 'Unknown')}")
    return data

def normalize_weather_data(data: dict) -> pd.DataFrame:
    """
    Normalize and flatten the JSON response from the Weatherstack API.

    Args:
        data (dict): Raw JSON response.

    Returns:
        pd.DataFrame: Flattened and cleaned weather data.
    """
    df = pd.json_normalize(data)
    df.columns = df.columns.str.replace(r"\.", "_", regex=True)
    return df

def ensure_schema_exists(engine, schema: str):
    """
    Ensure the target schema exists in the PostgreSQL database.

    Args:
        engine (sqlalchemy.Engine): SQLAlchemy engine.
        schema (str): Name of the schema to create if not exists.
    """
    with engine.begin() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {schema}"))

def insert_data(engine, df: pd.DataFrame, schema: str, table: str):
    """
    Insert normalized weather data into the specified database table.

    Args:
        engine (sqlalchemy.Engine): SQLAlchemy engine.
        df (pd.DataFrame): Normalized weather data.
        schema (str): Target schema name.
        table (str): Target table name.
    """
    df.to_sql(table, engine, schema=schema, if_exists="append", index=False)
    print(f"✅ Inserted into {schema}.{table}")

# ---------- Main Workflow ----------
def main(api_key: str, cities: list, schema: str, table: str):
    """
    Full ETL workflow to load weather data for multiple cities.

    Args:
        api_key (str): Weatherstack API key.
        cities (list): List of cities to fetch data for.
        schema (str): Target schema in PostgreSQL.
        table (str): Target table name.
    """
    try:
        engine = get_db_engine()
        ensure_schema_exists(engine, schema)

        for city in cities:
            print(f"\n📡 Fetching weather data for {city}...")
            raw_data = fetch_weather_data(city, api_key)

            print("🧪 Normalizing data...")
            df = normalize_weather_data(raw_data)

            print("📥 Inserting data...")
            insert_data(engine, df, schema, table)

    except Exception as e:
        print(f"❌ Error occurred: {e}")

# ---------- Entry Point ----------
if __name__ == "__main__":
    config_path = "${GITHUB_WORKSPACE}/api_data_load/api_config.yaml"
    cities = load_yaml_config(config_path)
    api_key = os.environ["API_KEY"]

    DB_SCHEMA = "weather"
    TABLE_NAME = "weather_data"

    main(api_key, cities, DB_SCHEMA, TABLE_NAME)
