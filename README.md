# Information System for Distillery and Sales Management

This repository contains an academic database project developed for the course **Databases 2** at the Faculty of Organization and Informatics, University of Zagreb.

The project represents an information system for managing a distillery and sales processes, with a focus on database design, SQL queries, triggers, and a simple Python-based user interface for demonstration purposes.

---

## Project Description

The aim of this project is to design and implement a relational database that supports key business processes of a distillery, including:
- product management
- warehouse stock tracking
- customer orders
- deliveries
- invoice creation

The database model is based on an ERA diagram and implemented in PostgreSQL.  
Business rules are enforced using SQL triggers, while a simple Python Tkinter interface is used to demonstrate interaction with the database.

---

## Repository Structure

```
sql/
  schema.sql
  sequences.sql
  routines.sql

python/
  form1.py
  form2.py

docs/
  documentation.pdf
```

---

## Database Setup

The database is implemented in **PostgreSQL** and developed using **DataGrip**.

### SQL scripts execution order:

1. `sequences.sql`
2. `schema.sql`
3. `routines.sql`

---

## Triggers and Business Logic

The database includes several triggers that automate key business processes:

- **Automatic delivery date assignment**  
  When the delivery status is updated to *delivered*, the delivery date is automatically set if it was previously empty.

- **Automatic warehouse stock update**  
  When a new order item is inserted, the product quantity in the warehouse is reduced accordingly.

- **Automatic invoice creation**  
  When an order status changes to *completed* or *delivered*, an invoice is automatically created if it does not already exist.

These triggers ensure data consistency and demonstrate the use of database-level business logic.

---

## User Interface

A simple graphical user interface is implemented using **Python and Tkinter**.  
The interface is intended for demonstration purposes and includes:
- a form for displaying and analyzing products
- a form for creating orders, adding order items, and changing order status

User actions in the interface directly activate SQL queries and database triggers.

---

## Technologies Used

- PostgreSQL
- SQL (PL/pgSQL)
- Python
- Tkinter
- DataGrip
- Draw.io

---

## How to Run the Project

### Database Setup
1. Create a PostgreSQL database.
2. Execute the SQL scripts in the following order:
   1. `sequences.sql`
   2. `schema.sql`
   3. `routines.sql`

### Python Application
1. Make sure Python is installed on your system.
2. Update the database connection parameters in the Python files if necessary (host, database name, username, password).
3. Run the Python scripts:
   ```bash
   python form1.py
   python form2.py


## Author

Marino Barnjak
