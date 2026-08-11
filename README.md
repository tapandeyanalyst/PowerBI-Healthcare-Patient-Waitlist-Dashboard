# Power BI - Healthcare - Patient Waitlist Dashboard
## Business Objective:

Management needs a reporting and analytics dashboard to track the current status of the patient waiting list. Stakeholders also need to understand the historical monthly trends in the waiting list across inpatient and outpatient departments, along with detailed analysis at the specialty and age-profile levels.

## Dataset:
* Healthcare data - Patient waitlist
    * Inpatient data: A patient who stays in a hospital while under treatment
    * Outpatient: A patient who receive medical treatment without being admitted to a hospital  

- [Inpatient Data](data/Inpatient/)
- [Outpatient Data](data/Outpatient/)
- [Mapping Specialty](data/Mapping_Specialty.csv)

## Workflow Steps:
* Requirement Gathering
* Requirement Analysis
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
- **Outpatient:** A patient who receive medical treatment without being admitted to a hospital

* Notebook Analysis:
    * [Analysis Inpatient Data](notebook/analysis_inpatient_data.ipynb)
    * [Analysis Outpatient Data](notebook/analysis_outpatient_data.ipynb)

* **Findings:**
    * Inpatient files has 8 columns
    * Outpatient files has 7 columns
    * Mapping file has 2 columns
    * Outpatient and inpatient columns are similar
    * Only the `Case_Type` column in the outpatient file is missing.

## Step 3: Designing Architecture
Design architecture is important because it provides a clear blueprint of the entire solution. It helps us understand the end-to-end process flow, identify the steps that need to be executed, determine how different components interact with each other, and select the appropriate tools and platforms for implementation.

* [High Level Architecture](docs/High-Level-Architecture.png)
* [Data Layers Architecture](docs/Data%20Architecture-Layers.png)
* Data Flow Diagram
* Integration Model (Silver Layer)
* Data Mart (Star Schema)



## ⚙️ Technologies Used

### Programming Language

* Python

### Libraries

* pandas
* pyodbc
* SQLAlchemy

### Development Tools

* Visual Studio Code
* Git
* GitHub
* SSMS
* MS SQL Server
* Draw.io
