-- ==> Figure 4-01.sql <==
USE ITOM_AP;


-- Inner joins
select *
from table_A;

select *
from table_B;

select *
from table_C;

-- Inner join between table_A and table_B 
-- Using implicit syntax
select *
from table_A as A, table_B as B
where A.key_col = B.key_col;

-- Using explicit syntax
select *
from table_A as A inner join table_B as B
on A.key_col = B.key_col;


-- Inner join between table_A and table_B 
-- Using implicit syntax
select *
from table_A as A, table_C as C
where A.key_col = C.key_col;


-- An inner join of the Vendors and Invoices tables
SELECT InvoiceNumber, VendorName
FROM Vendors JOIN Invoices
    ON Vendors.VendorID = Invoices.VendorID;

-- can also be re-written without explicit syntax using a where condition
SELECT InvoiceNumber, VendorName
FROM Vendors, Invoices
where Vendors.VendorID = Invoices.VendorID;


-- Correlation names that make the query more difficult to read
-- ==> Figure 4-02a.sql <==
SELECT InvoiceNumber, VendorName, InvoiceDueDate,
    InvoiceTotal - PaymentTotal - CreditTotal AS BalanceDue
FROM Vendors AS v JOIN Invoices AS i
    ON v.VendorID = i.VendorID
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
ORDER BY InvoiceDueDate DESC;

-- A correlation name that simplifies the query
-- ==> Figure 4-02b.sql <==
SELECT InvoiceNumber, InvoiceLineItemAmount, InvoiceLineItemDescription
FROM Invoices JOIN InvoiceLineItems AS LineItems
    ON Invoices.InvoiceID = LineItems.InvoiceID
WHERE AccountNo = 540
ORDER BY InvoiceDate;

-- A join with fully-qualified table names
-- ==> Figure 4-03a.sql <==
-- You may need to run the script stored in Figure 4-03c.sql
-- before this SELECT statement will execute successfully
/*
SELECT VendorName, CustLastName, CustFirstName,
    VendorState AS State, VendorCity AS City
FROM DBServer.AP.dbo.Vendors AS Vendors
    JOIN DBServer.ProductOrders.dbo.Customers AS Customers
    ON Vendors.VendorZipCode = Customers.CustZip
ORDER BY State, City;


-- ==> Figure 4-03b.sql <==

SELECT VendorName, CustLastName, CustFirstName,
    VendorState AS State, VendorCity AS City
FROM Vendors
    JOIN ProductOrders..Customers AS Customers
    ON Vendors.VendorZipCode = Customers.CustZip
ORDER BY State, City;


-- ==> Figure 4-03c.sql <==
-- This creates a linked server named DBServer 
-- using the SQL Native Client OLE DB provider (SQLNCLI).
-- on an instance of SQL Server Express
-- that's running on the local computer

USE master;

EXEC sp_addlinkedserver   
   @server='DBServer', 
   @srvproduct='',
   @provider='SQLNCLI', 
   @datasrc='localhost\SqlExpress';



-- ==> Figure 4-03d.sql <==
-- If necessary, you can use this stored procedure to drop
-- the linked server created by Figure 4-03c.sql

sp_dropserver 'DBServer', 'droplogins';

*/

-- An inner join with two conditions � join and search conditions
-- ==> Figure 4-04a.sql <==
SELECT InvoiceNumber, InvoiceDate,
    InvoiceTotal, InvoiceLineItemAmount
FROM Invoices JOIN InvoiceLineItems AS LineItems
    ON (Invoices.InvoiceID = LineItems.InvoiceID) AND
       (Invoices.InvoiceTotal > LineItems.InvoiceLineItemAmount)
ORDER BY InvoiceNumber;

-- The same join with the second condition coded in a WHERE clause
-- ==> Figure 4-04b.sql <==
SELECT InvoiceNumber, InvoiceDate,
    InvoiceTotal, InvoiceLineItemAmount
FROM Invoices JOIN InvoiceLineItems AS LineItems
    ON Invoices.InvoiceID = LineItems.InvoiceID
WHERE Invoices.InvoiceTotal > LineItems.InvoiceLineItemAmount
ORDER BY InvoiceNumber;


-- A self-join that returns vendors from cities in common with other vendors
-- ==> Figure 4-05.sql <==
SELECT DISTINCT Vendors1.VendorName, Vendors1.VendorCity,
    Vendors1.VendorState
FROM Vendors AS Vendors1 JOIN Vendors AS Vendors2
    ON (Vendors1.VendorCity = Vendors2.VendorCity) AND
       (Vendors1.VendorState = Vendors2.VendorState) AND
       (Vendors1.VendorID <> Vendors2.VendorID)
ORDER BY Vendors1.VendorState, Vendors1.VendorCity;


-- A SELECT statement that joins four tables

-- ==> Figure 4-06c.sql <==
SELECT VendorName, InvoiceNumber, InvoiceDate,
       InvoiceLineItemAmount AS LineItemAmount, AccountDescription
FROM Vendors
    JOIN Invoices ON Vendors.VendorID = Invoices.VendorID
    JOIN InvoiceLineItems ON Invoices.InvoiceID = InvoiceLineItems.InvoiceID
    JOIN GLAccounts ON InvoiceLineItems.AccountNo = GLAccounts.AccountNo
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
ORDER BY VendorName, LineItemAmount DESC;

-- query in 4-06c can be split into many interim steps as shown in 4-06a, 4-06b below
-- ==> Figure 4-06a.sql <==
SELECT VendorName, InvoiceNumber, InvoiceDate 
FROM Vendors 
	JOIN Invoices ON Vendors.VendorID = Invoices.VendorID
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
ORDER BY VendorName;
-- ==> Figure 4-06b.sql <==
SELECT VendorName, InvoiceNumber, InvoiceDate, 
	InvoiceLineItemAmount AS LineItemAmount
FROM Vendors 
	JOIN Invoices ON Vendors.VendorID = Invoices.VendorID
    JOIN InvoiceLineItems On Invoices.InvoiceID = InvoiceLineItems.InvoiceID
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
ORDER BY VendorName, LineItemAmount;



-- ==> Figure 4-07a.sql <==
SELECT InvoiceNumber, VendorName
FROM Vendors, Invoices
WHERE Vendors.VendorID = Invoices.VendorID;


-- ==> Figure 4-07b.sql <==
SELECT VendorName, InvoiceNumber, InvoiceDate,
    InvoiceLineItemAmount AS LineItemAmount, AccountDescription
FROM Vendors, Invoices, InvoiceLineItems, GLAccounts
WHERE Vendors.VendorID = Invoices.VendorID
  AND Invoices.InvoiceID = InvoiceLineItems.InvoiceID
  AND InvoiceLineItems.AccountNo = GLAccounts.AccountNo
  AND InvoiceTotal - PaymentTotal - CreditTotal > 0
ORDER BY VendorName, LineItemAmount DESC;


-- A SELECT statement that uses a left outer join
-- ==> Figure 4-08.sql <==
SELECT VendorName, InvoiceNumber, InvoiceTotal
FROM Vendors LEFT JOIN Invoices
    ON Vendors.VendorID = Invoices.VendorID
ORDER BY VendorName;

-- The Departments table
-- ==> Figure 4-09a.sql <==
SELECT DeptName, DeptNo
FROM Departments;

-- The  Employees tables
-- ==> Figure 4-09b.sql <==
SELECT EmployeeID, LastName, FirstName, DeptNo
FROM Employees;


-- A left outer join
-- ==> Figure 4-09c.sql <==
SELECT DeptName, Departments.DeptNo, LastName
FROM Departments LEFT JOIN Employees
    ON Departments.DeptNo = Employees.DeptNo;


-- A right outer join
-- ==> Figure 4-09d.sql <==
SELECT DeptName, Employees.DeptNo, LastName
FROM Departments RIGHT JOIN Employees
    ON Departments.DeptNo = Employees.DeptNo;

-- A full outer join
-- ==> Figure 4-09e.sql <==
SELECT DeptName, Departments.DeptNo, Employees.DeptNo, LastName
FROM Departments FULL JOIN Employees
    ON Departments.DeptNo = Employees.DeptNo;

-- ==> Figure 4-10a.sql <==
SELECT DeptName, DeptNo
FROM Departments;
-- ==> Figure 4-10b.sql <==
SELECT EmployeeID, LastName, FirstName, DeptNo 
FROM Employees;
-- ==> Figure 4-10c.sql <==
SELECT * 
FROM Projects;


-- Join three tables using left outer joins
-- ==> Figure 4-10d.sql <==
SELECT DeptName, LastName, ProjectNo
FROM Departments
    LEFT JOIN Employees
        ON Departments.DeptNo = Employees.DeptNo
    LEFT JOIN Projects
        ON Employees.EmployeeID = Projects.EmployeeID
ORDER BY DeptName, LastName, ProjectNo;

-- Join three tables using full outer joins
-- ==> Figure 4-10e.sql <==
SELECT DeptName, LastName, ProjectNo
FROM Departments
    FULL JOIN Employees
        ON Departments.DeptNo = Employees.DeptNo
    FULL JOIN Projects
        ON Employees.EmployeeID = Projects.EmployeeID
ORDER BY DeptName;

-- Combine an outer and an inner join
-- ==> Figure 4-11d.sql <==
SELECT DeptName, LastName, EmployeeID
FROM Departments 
    JOIN Employees
        ON Departments.DeptNo = Employees.DeptNo;

-- Combine an outer and an inner join
-- ==> Figure 4-11e.sql <==
SELECT DeptName, LastName, ProjectNo
FROM Departments 
    JOIN Employees
        ON Departments.DeptNo = Employees.DeptNo
    LEFT JOIN Projects
        ON Employees.EmployeeID = Projects.EmployeeID
ORDER BY DeptName;

-- A cross join that uses the explicit syntax
-- ==> Figure 4-12a.sql <==
SELECT Departments.DeptNo, DeptName, EmployeeID, LastName
FROM Departments CROSS JOIN Employees
ORDER BY Departments.DeptNo;

-- How to code a cross join using the implicit syntax
-- ==> Figure 4-12b.sql <==
SELECT Departments.DeptNo, DeptName, EmployeeID, LastName
FROM Departments, Employees
ORDER BY Departments.DeptNo;

-- ==> Figure 4-13.sql <==
-- The following statements are only needed if
-- the ActiveInvoices and PaidInvoices tables
-- haven't already been created
/*


SELECT *
INTO ActiveInvoices
FROM Invoices
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0;

SELECT *
INTO PaidInvoices
FROM Invoices
WHERE InvoiceTotal - PaymentTotal - CreditTotal <= 0;
*/

-- A union that combines data from two tables
    SELECT 'Active' AS Source, InvoiceNumber, InvoiceDate, InvoiceTotal
    FROM ActiveInvoices
    WHERE InvoiceDate >= '02/01/2016' 
UNION
    SELECT 'Paid' AS Source, InvoiceNumber, InvoiceDate, InvoiceTotal
    FROM PaidInvoices
    WHERE InvoiceDate >= '02/01/2016' 
ORDER BY InvoiceTotal DESC;


-- A union that combines data from the same table
-- ==> Figure 4-14a.sql <==
    SELECT 'Active' AS Source, InvoiceNumber, InvoiceDate, InvoiceTotal
    FROM Invoices
    WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
UNION
    SELECT 'Paid' AS Source, InvoiceNumber, InvoiceDate, InvoiceTotal
    FROM Invoices
    WHERE InvoiceTotal - PaymentTotal - CreditTotal <= 0
ORDER BY InvoiceTotal DESC;


-- ==> Figure 4-14b.sql <==
    SELECT InvoiceNumber, VendorName, '33% Payment' AS PaymentType,
        InvoiceTotal AS Total, (InvoiceTotal * 0.333) AS Payment
    FROM Invoices JOIN Vendors
        ON Invoices.VendorID = Vendors.VendorID
    WHERE InvoiceTotal > 10000
UNION
    SELECT InvoiceNumber, VendorName, '50% Payment' AS PaymentType,
        InvoiceTotal AS Total, (InvoiceTotal * 0.5) AS Payment
    FROM Invoices JOIN Vendors
        ON Invoices.VendorID = Vendors.VendorID
    WHERE InvoiceTotal BETWEEN 500 AND 10000
UNION
    SELECT InvoiceNumber, VendorName, 'Full amount' AS PaymentType,
        InvoiceTotal AS Total, InvoiceTotal AS Payment
    FROM Invoices JOIN Vendors
        ON Invoices.VendorID = Vendors.VendorID
    WHERE InvoiceTotal < 500
ORDER BY PaymentType, VendorName, InvoiceNumber;


-- ==> Figure 4-15a.sql <==
SELECT FirstName, LastName
FROM Employees;

-- Exclude rows from the first query if they also occur in the second query
-- ==> Figure 4-15c.sql <==
	SELECT CustomerFirst, CustomerLast 
	FROM Customers
EXCEPT
	SELECT FirstName, LastName 
	FROM Employees
ORDER BY CustomerLast;

-- Only include rows that occur in both queries
-- ==> Figure 4-15d.sql <==
	SELECT CustomerFirst, CustomerLast 
	FROM Customers
INTERSECT
	SELECT FirstName, LastName 
	FROM Employees;
