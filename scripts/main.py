from sqlalchemy import create_engine, text
from config import SERVER, DATABASE, DRIVER


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