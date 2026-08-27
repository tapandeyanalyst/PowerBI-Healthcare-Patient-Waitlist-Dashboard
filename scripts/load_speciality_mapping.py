# Note: use this command to run the query in VS Code: python -m scripts.load_inpatient_sql
import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path
import pyodbc
from config import DATA_DIR, SERVER, DATABASE, DRIVER

def load_speciality_mapping():
    # -------------------------------------------------------------------
    # Database Connection
    # -------------------------------------------------------------------

    connection_string = (
        f"DRIVER={DRIVER};"
        f"SERVER={SERVER};"
        f"DATABASE={DATABASE};"
        "Trusted_Connection=yes;"
        "TrustServerCertificate=yes;"
    )

    try:
        # Test Connection
        conn = pyodbc.connect(connection_string)
        print("✅ Connection to SQL Server successful!")

        # SQLAlchemy Engine
        engine = create_engine(
            f"mssql+pyodbc:///?odbc_connect={connection_string}"
        )

    except Exception as e:
        print("❌ Connection failed!")
        print(e)

    file_path = DATA_DIR / "Mapping_Specialty.csv"
    df = pd.read_csv(file_path)

    #print(df.head())
    #print(f"\nNumber of Rows   : {len(df)}")
    #print(f"Number of Columns: {len(df.columns)}")

    # I am just renaming the columns to match the SQL Server table column names. This is optional, but it helps to avoid confusion.
    # In CSV file it is Specialty Group and in Database it is specialty_group. So, I am renaming it to match the database column name.
    df.columns = [
        "specialty",
        "specialty_group"
    ]
    """
    OR you can do this as well:
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )
    """

    # -------------------------------------------------------------------
    # Truncate Bronze Table
    # -------------------------------------------------------------------
    cursor = conn.cursor()
    cursor.execute("TRUNCATE TABLE bronze.speciality_mapping")
    conn.commit()
    print("✅ bronze.speciality_mapping truncated successfully.")

    # -------------------------------------------------------------------
    # Load Data into SQL Server
    # -------------------------------------------------------------------
    try:
        df.to_sql(
            name="speciality_mapping",
            schema="bronze",
            con=engine,
            if_exists="append",
            index=False
        )

        print(f"✅ Successfully loaded {len(df)} rows into bronze.speciality_mapping.")

    except Exception as e:
        print("❌ Error loading data into SQL Server.")
        print(e)
        raise

    conn.close()

if __name__ == "__main__":
    load_speciality_mapping()