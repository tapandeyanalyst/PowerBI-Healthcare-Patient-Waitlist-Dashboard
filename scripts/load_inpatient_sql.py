# Note: use this command to run the query in VS Code: python -m scripts.load_inpatient_sql 
import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path
import pyodbc
from config import SERVER, DATABASE, DRIVER, MERGED_DATA_DIR

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

file_path = MERGED_DATA_DIR / "inpatient_data.csv"
df = pd.read_csv(file_path)

#print(df.head())
#print(f"\nNumber of Rows   : {len(df)}")
#print(f"Number of Columns: {len(df.columns)}")

# -------------------------------------------------------------------
# Convert Archive_Date to Date
# -------------------------------------------------------------------

df["Archive_Date"] = pd.to_datetime(
    df["Archive_Date"],
    format="%d-%m-%Y"
)
#print(df.info())


# -------------------------------------------------------------------
# Truncate Bronze Table
# -------------------------------------------------------------------
cursor = conn.cursor()
cursor.execute("TRUNCATE TABLE bronze.inpatientdata")
conn.commit()
print("✅ bronze.inpatientdata truncated successfully.")

# -------------------------------------------------------------------
# Load Data into SQL Server
# -------------------------------------------------------------------
try:
    df.to_sql(
        name="inpatientdata",
        schema="bronze",
        con=engine,
        if_exists="append",
        index=False
    )

    print(f"✅ Successfully loaded {len(df)} rows into bronze.inpatientdata.")

except Exception as e:
    print("❌ Error loading data into SQL Server.")
    print(e)

    conn.close()