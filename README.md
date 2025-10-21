### 🏥 Al Shifa Clinic – A SQL Database Project

A simple but modern SQL project demonstrating the design and implementation of a clinic management database: from conceptual schema through physical implementation, using modern best practices and real-world data modeling.

### ✨ Features
- Manage Doctors, Departments, and Patients.
- Schedule and track Appointments.
- Record Treatments, Diagnoses, and Medicines.
- Auto-calculate Billing via stored procedures (It can be calculated using triggers).
- Includes 15 analytical SQL queries (Simple → Medium → Advanced).
- Fully normalized schema (3NF).
- Uses UUIDs (BINARY(16)) for all primary keys.
- Tracks create_time and update_time for all tables.
- Ensures referential integrity with cascading foreign key constraints.

### 📁 Project Folder Structure

| Folder / File                | Description                                                                                        |
| ---------------------------- | ---------------------------------------------------------------------------------------------------|
| 📁 `ER Diagram/`             | ER diagram files for visual understanding.                                                         |
| 📁 `Functions & Procedures/` | Contains functions and stored procedures.                                                          |
| 📁 `Queries/`                | Contains categorized queries (Simple, Medium, and Advanced).                                       |
| 📁 `Sample Data/`            | Contains sample data insertion scripts and how to call procedures for random data generation?      |
| 📁 `Schema/`                 | Contains SQL scripts for creating schema, tables, and constraints.                                 | 
| 📄 `README.md`               | Project documentation.                                                                             |


### ⚙️ Setup Instructions 

#### 🛠️ Prerequisites  
- MySQL 8.x (or compatible) 
- MySQL Workbench (or a similar tool)
- Git (to clone the repository) 

1. Clone the repository:  
   ```bash
   git clone https://github.com/Yeasin307/Al_Shifa_Clinic.git

2. Open your MySQL Workbench and connect to your local MySQL instance.

3. Execute the SQL scripts in order:
   ```bash
   1. Schema → create_database_&_tables.sql
   2. Functions & Procedures → functions.sql → procedures.sql
   3. Sample Data → insert_data.sql → random_generators.sql

4. Explore queries provided in the Queries folder:
   ```bash
   1. simple_queries.sql – Basic retrieval (list of doctors in a department, medicines)
   2. medium_queries.sql – Joins, grouping, and filtering
   3. advanced_queries.sql – Subqueries, CTE, and window functions
5. (Optional) Alternatively, you can create the database and tables using forward engineering. The ER Diagram folder includes the necessary files — al_shifa_clinic.mwb and al_shifa_clinic.mwb.bak — to complete this process.
