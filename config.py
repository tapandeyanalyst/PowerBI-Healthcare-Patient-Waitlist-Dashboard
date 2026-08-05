from pathlib import Path

# ----------------------------
# Project Paths
# ----------------------------

# Project Root
BASE_DIR = Path(r"E:\Power BI\Health Care Dashboard\Health-Care")

# Data Folder
DATA_DIR = BASE_DIR / "data"

# Raw Data Folder
INPATIENT_DIR = DATA_DIR / "inpatient"
OUTPATIENT_DIR = DATA_DIR / "outpatient"

# Merged Data Folder
MERGED_DATA_DIR = DATA_DIR / "merged_data"

# SQL Server
SERVER = "DESKTOP-K39L78B"
DATABASE = "HealthCareDB"
DRIVER = "ODBC Driver 18 for SQL Server"