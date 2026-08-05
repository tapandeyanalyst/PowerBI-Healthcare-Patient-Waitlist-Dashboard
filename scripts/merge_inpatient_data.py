import pandas as pd
from pathlib import Path

# Input folder
input_folder = Path(r"E:\Power BI\Health Care Dashboard\Health-Care\data\Inpatient")

# Output folder
output_folder = Path(r"E:\Power BI\Health Care Dashboard\Health-Care\data\merged_data")

# Get all CSV files
csv_files = sorted(input_folder.glob("*.csv"))

# Store each DataFrame
dataframes = []

for file in csv_files:
    print(f"Reading: {file.name}")

    df = pd.read_csv(file)

    # Remove any Unnamed columns
    df = df.loc[:, ~df.columns.str.startswith("Unnamed")]

    dataframes.append(df)

# Merge all files
inpatient_data = pd.concat(dataframes, ignore_index=True)

# Save merged file
output_file = Path(output_folder) / "inpatient_data.csv"
inpatient_data.to_csv(output_file, index=False)

print("\nMerge completed successfully.")
print(f"Rows   : {len(inpatient_data)}")
print(f"Columns: {len(inpatient_data.columns)}")
print(f"Saved  : {output_file}")