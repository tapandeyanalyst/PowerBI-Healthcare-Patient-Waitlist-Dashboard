from sqlalchemy import create_engine, text
from config import SERVER, DATABASE, DRIVER

from scripts.merge_inpatient_data import merge_inpatient
from scripts.merge_outpatient_data import merge_outpatient
from scripts.load_inpatient_sql import load_inpatient
from scripts.load_outpatient_sql import load_outpatient
from scripts.load_speciality_mapping import load_speciality_mapping

def get_engine():
    connection_string = (
        f"mssql+pyodbc://@{SERVER}/{DATABASE}"
        f"?driver={DRIVER.replace(' ', '+')}"
        "&trusted_connection=yes"
        "&TrustServerCertificate=yes"
    )

    return create_engine(connection_string)


def run_pipeline():
    try:
        print("Starting Healthcare Data Pipeline...")

        # Step 1: Merge Inpatient Data
        print("\n[1/6] Merging Inpatient data...")
        merge_inpatient()

        # Step 2: Merge Outpatient Data
        print("\n[2/6] Merging Outpatient data...")
        merge_outpatient()

        # Step 3: Load Inpatient Bronze
        print("\n[3/6] Loading Inpatient Bronze...")
        load_inpatient()

        # Step 4: Load Outpatient Bronze
        print("\n[4/6] Loading Outpatient Bronze...")
        load_outpatient()

        # Step 5: Load Specialty Mapping Bronze
        print("\n[5/6] Loading Specialty Mapping Bronze...")
        load_speciality_mapping()

        # Step 6: Execute Stored Procedure
        print("\n[6/6] Executing dbo.sp_load...")

        engine = get_engine()

        with engine.begin() as connection:
            print("Executing dbo.sp_load...")
            connection.execute(text("EXEC dbo.sp_load"))

        print("Pipeline completed successfully.")

    except Exception as e:
        print(f"Pipeline failed: {e}")
        raise


if __name__ == "__main__":
    run_pipeline()