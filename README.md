# Power BI - Healthcare - Patient Waitlist Dashboard
## Business Objective:

Management needs a reporting and analytics dashboard to track the current status of the patient waiting list. Stakeholders also need to understand the historical monthly trends in the waiting list across inpatient and outpatient departments, along with detailed analysis at the speciality and age-profile levels.

## Dataset:
* Healthcare data - Patient waitlist
    * Inpatient data: A patient who stays in a hospital while under treatment
    * Outpatient: A patient who receives medical treatment without being admitted to a hospital  

- [Inpatient Data](data/Inpatient/)
- [Outpatient Data](data/Outpatient/)
- [Mapping Specialty](data/Mapping_Specialty.csv)

## Workflow Steps:
* Requirement Gathering
* Requirement Analysis
* Blueprint of Execution Workflow
* Project Structure
* Designing Architecture
* Ingestion Pipeline 
* EDA Analysis
* Transformation Pipeline 
* Data Modeling
* Data Visualization Blueprint
* Dashboard Layout & Design
* Interactivity & Navigation
* Testing
* Sharing
* Maintenance & Refresh

## Step 1: Requirement Gathering

* Problem Statement:
    1. Track the current status of the patient waiting list.
    2. Analyze historical monthly trends of the waiting list for:  
        - Inpatient Department
        - Outpatient Department
* Data Sources:
    1. Inpatient data folder
    2. Outpatient data folder
    3. Specialty mapping file
* Access:
    1. Access to the data sources has been shared with the Data Engineering team.
    2. Access to the scripts and dashboard should be provided only to the required stakeholders.
    3. Access will be managed through the company group email address.

* Audiences:
    1. Project Stakeholders
    2. Client

* Metrics & KPIs:
    1. Discussion and finalization of important KPIs.
    2. Dashboard blueprint and layout.
* Project Completion date/timeline:
    * 1 week

## Step 2: Requirement Analysis
* Inpatient folder/
    * 4 csv files
        * IN_WL 2018
        * IN_WL 2019
        * IN_WL 2020
        * IN_WL 2021
* Outpatient folder/
    * 4 csv files
        * Op_WL 2018
        * Op_WL 2019
        * Op_WL 2020
        * Op_WL 2021
    * Mapping_Specialty file
        * A csv file
        * During ingestion pipeline, we will rename this file to mapping _speciality  

- **Inpatient data:** A patient who stays in a hospital while under treatment
- **Outpatient:** A patient who receives medical treatment without being admitted to a hospital

* Notebook Analysis:
    * [Analysis Inpatient Data](notebook/analysis_inpatient_data.ipynb)
    * [Analysis Outpatient Data](notebook/analysis_outpatient_data.ipynb)

* **Findings:**
    * Inpatient files have 8 columns
    * Outpatient files have 7 columns
    * Mapping file have 2 columns
    * Outpatient and inpatient columns are similar except the Case_Type column in the outpatient file is missing.

## Step 3: Blueprint of Execution Workflow
* Read files from the `inpatient folder` using python and merge the data in `merged_data/` folder
    * inpatient_data.csv
* Read files from the `outpatient folder` using python and merge the data in `merged_data/` folder
    * outpatient_data.csv
* Create database and schema
    * Database
        * HealthCareDB
    * Schema
        * bronze
        * Silver
        * Gold
* Create Bronze Tables
    * bronze.inpatientdata
    * bronze.outpatientdata
    * bronze.speciality_mapping 
* Load data from inpatient_data.csv to `bronze.inpatientdata` using python
* Load data from outpatient_data.csv to `bronze.outpatientdata` using python
* Load data from Mapping_Specialty.csv to `bronze.speciality_mapping`  using python
* Create Bronze Stored Procedure
* EDA Analysis
* Create Silver Tables
    * silver.patientwaitlistdata
* Transformation and load data from bronze.inpatientdata, bronze.outpatientdata to silver.patientwaitlistdata
* Create Silver Stored Procedure
* Create Views
    * gold.patientwaitlistdata

## Step 4: Project Structure
* Health-Care/
    * data/
        * inpatient/
        * outpatient/
        * merged_data/
* docs/
* scripts/
* notebook/
* sql/
* venv/
* .gitignore
* config/
* README.md

## Step 5: Development Tools & Infrastructure
* Python
* Jupyter Notebook
* Visual Studio Code
* SQL Server Management Studio
* SQL
* Git
* GitHub
* Draw.io
* Power BI

## Step 6: Designing Architecture
Design architecture is important because it provides a clear blueprint of the entire solution. It helps us understand the end-to-end process flow, identify the steps that need to be executed, determine how different components interact with each other, and select the appropriate tools and platforms for implementation.

* [High Level Architecture](docs/High-Level-Architecture.png)
* [Data Layers Architecture](docs/Data%20Architecture-Layers.png)
* Data Flow Diagram
* Integration Model (Silver Layer)
* Data Mart (Star Schema)

## Step 7: Ingestion Pipeline

* Step 1 : VS Code
    * Create the folder/ structure
    * Check python and pip version
    * pip install pandas pyodbc sqlalchemy
    * updated pip freeze > requirements.txt

* Step 2: Merge Data
    * Create script : [merge_inpatient_data.py](scripts/merge_inpatient_data.py)
    * Create script : [merge_outpatient_data.py](scripts/merge_outpatient_data.py)

* Step 3: Create Database & Schema
    * [Bronze layer](sql/init_database_schema.sql)

* Step 4: Create Bronze Tables  
We will use SQL server to create Bronze Table. Here is the SQL scripts - [Bronze Tables SQL Scripts](sql/ddl_bronze_layer.sql)  
    * bronze.inpatientdata
    * bronze.outpatientdata
    * bronze.speciality_mapping 
        * Transformation: `specialty_mapping` --> `speciality_mapping` 

* Step 5: Load Raw data into Bronze Layer 
We will use Python to load data into SQL Bronze Layer.  
    * [Load In-Patient Data](scripts/load_inpatient_sql.py)
    * [Load Out-Patient Data](scripts/load_outpatient_sql.py)
    * [Load Speciality Mapping Data](scripts/load_speciality_mapping.py)

* Step 6: Verify the Data
    * `bronze.inpatientdata`
    * `bronze.outpatientdata`
    * `bronze.speciality_mapping`

## Step 8: Exploratory Data Analysis
* [EDA Findings](docs/EDA_Findings.md)

## Step 9: Transformation Pipeline

### Silver Layer
The Silver Layer cleans, standardizes, transforms, and integrates data from the Bronze Layer.

- [Silver Layer DDL](sql/ddl_silver_layer.sql)
- [Silver Layer Transformation](sql/load_silver.sql)

Stored Procedure:

- `silver.load_silver`

### Gold Layer

The Gold Layer provides the final business-ready dataset for Power BI.

- [Gold Layer View](sql/load_gold.sql)

Gold View:

- `gold.patientwaitlistdata`

## Step 10: Automation Pipeline

The data pipeline is automated using Python and SQL Server Stored Procedures.

### Python Automation

- [Main Pipeline](scripts/main.py)

The Python pipeline connects to SQL Server and executes the master stored procedure.

### Master Stored Procedure

- [Master Load Procedure](sql/sp_load.sql)

Stored Procedure:

```sql
dbo.sp_load

```
## PowerBI Dashboard Screenshot

* Summary Page
![Summary Page](../screenshot/dashbaord_page1.png)

* Detail Page
![Summary Page](../screenshot/dashbaord_page2.png)