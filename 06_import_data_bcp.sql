/*
This file demonstrates how to export and import data from tables using BCP utility

Refer to the microsoft document for more details on the different methods of data import/export
https://docs.microsoft.com/en-us/sql/relational-databases/import-export/overview-import-export?view=sql-server-ver15

https://docs.microsoft.com/en-us/sql/relational-databases/import-export/import-bulk-data-by-using-bulk-insert-or-openrowset-bulk-sql-server?view=sql-server-ver15

Refer to the following Wiki page for details on usage or BCP. This was written by our DBA Lane Duncan
https://wiki.smu.edu/display/ITOM/04+BCP+utility+for+import+and+export+data+from+tables

*/

-- set ITOM_TEST as the current/active database
use ITOM_TEST;

--create schema demo;

-- First step is to import zomato_london.xlsx into a new table
-- Open this file in Excel and "save as" a tab delimitted file zomato_london_tab.txt
-- This file has the following columns
-- Name	City	Address	Longitude	Latitude	Average_Cost	Price_range	Aggregate_rating	Votes
-- We will first create a table with all these columns as VARCHAR(255) data types. This is because identifying data types in a text/csv/excel file is extremely hard.
-- We will import everything as text and then convert data types using SQL

-- drop table 
CREATE TABLE demo.zomato_rest_char (
 name VARCHAR (255),
 city VARCHAR (255),
 address  VARCHAR (255),
 Longitude VARCHAR (255),
 Latitude VARCHAR (255),
 Average_Cost VARCHAR (255),
 Price_range VARCHAR (255),
 Aggregate_rating VARCHAR (255),
 Votes VARCHAR (255)
);

select * from demo.zomato_rest_char;

-- Create a new user for this databse called ITOM6265_USER
--create user ITOM6265_USER with password='str0ng!shPassw0rd';
-- To add a user to a database role, use an alter role statement:
-- alter role db_owner add member ITOM6265_USER;


-- run this bcp command in the windows command line
-- bcp demo.zomato_rest_char in "Z:\Dropbox (Personal)\Data\SMU_teaching\Database\2020_Fall_Karthik\Slides\04_data_mgt\data\zomato_london_tab_delimited.txt" -S classroomdb.smu.edu,55433 -c -d ITOM_TEST -U ITOM6265_USER -P str0ng!shPassw0rd

Z:\Dropbox (Personal)\Data\SMU_teaching\Database\2020_Fall_Karthik\Slides\04_data_mgt\data
select * from demo.zomato_rest_char;

-- delete the row that has column headers 
delete from demo.zomato_rest_char where name = 'Name';

-- Now let us create a new table with proper data types. Then we can copy data in proper formatting to this table

-- drop table demo.zomato_rest;
CREATE TABLE demo.zomato_rest (
 name VARCHAR (255),
 city VARCHAR (255),
 address  VARCHAR (255),
 Longitude float,
 Latitude float,
 Average_Cost int,
 Price_range int,
 Aggregate_rating float,
 Votes int
);

select * from demo.zomato_rest;

-- we will cast VARCHAR into int, float, date etc. and then insert those records into demo.zomato_rest
-- refer https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15#arguments

 
insert into demo.zomato_rest 
select name, city, address, 
		cast(Longitude as float) as Longitude, 
		cast(latitude as float) as latitude, 
		cast(Average_Cost as int) as Average_Cost,
		cast(Price_range as int) as Price_range, 
		cast(Aggregate_rating as float) as Aggregate_rating, 
		cast(Votes as int) as Votes
from demo.zomato_rest_char;

select * from demo.zomato_rest;

-- Now try exporting data from demo.zomato_rest
-- bcp demo.zomato_rest out "Z:\Dropbox (Personal)\Data\SMU_teaching\Database\2020_Fall_Karthik\Slides\04_data_mgt\data\demo_zomato_rest_export.txt" -S classroomdb.smu.edu,55433 -c -d ITOM_TEST -U ITOM6265_USER -P str0ng!shPassw0rd
