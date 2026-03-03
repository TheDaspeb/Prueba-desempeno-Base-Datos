# Prueba-desempeno-Base-Datos
Prueba de desempeño Base de Datos

The server db_megastore_exam_daniel_perez is created. The username is db_megastore_exam and the password is daniel1234.

This is how you should connect to the database.

To create the main table, name it raw_data so that you can retrieve all the important data.

For importing the CSV data, it is very important to create each of the columns that appeared in the Excel file with the exact same name; otherwise, it will not be able to retrieve all the content. (I spent the first 4 hours trying to complete this process.)

After the CSV data was imported, the process of creating the tables for the respective users, orders, order details, transactions, suppliers, and item order numbers was carried out.

After creating the tables, the process of distributing the data to each of the corresponding tables was performed using "insert into" and "selst distinct".

For data manipulation in the tables (column correction), the "ALTER TABLE" command was used, in addition to deleting tables with "DROP TABLE". Joins were also used to combine the tables.

The folder structure to be used in the test was the following:

app.js config controllers image.png migrations models postgres.sql README.md routes services

./config:

./controllers:

./migrations:

./models:

./routes:

./services:

Due to problems with both the server and the table imports, the exam could not be completed.