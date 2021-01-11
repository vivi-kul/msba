-- -- ==> Figure 5-01.sql <==
USE ITOM_AP;

SELECT COUNT(*) AS NumberOfInvoices,
    SUM(InvoiceTotal - PaymentTotal - CreditTotal) AS TotalDue
FROM Invoices
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0;


-- ==> Figure 5-02a.sql <==


SELECT 'After 9/1/2015' AS SelectionDate, COUNT(*) AS NumberOfInvoices,
    AVG(InvoiceTotal) AS AverageInvoiceAmount,
    SUM(InvoiceTotal) AS TotalInvoiceAmount
FROM Invoices
WHERE InvoiceDate > '2015-09-01';


-- ==> Figure 5-02b.sql <==


SELECT 'After 9/1/2015' AS SelectionDate, COUNT(*) AS NumberOfInvoices,
    MAX(InvoiceTotal) AS HighestInvoiceTotal,
    MIN(InvoiceTotal) AS LowestInvoiceTotal
FROM Invoices
WHERE InvoiceDate > '2015-09-01';

-- ==> Figure 5-02c.sql <==


SELECT MIN(VendorName) AS FirstVendor,
    MAX(VendorName) AS LastVendor,
    COUNT(VendorName) AS NumberOfVendors
FROM Vendors;


-- ==> Figure 5-02d.sql <==


SELECT COUNT(DISTINCT VendorID) AS NumberOfVendors,
    COUNT(VendorID) AS NumberOfInvoices,
    AVG(InvoiceTotal) AS AverageInvoiceAmount,
    SUM(InvoiceTotal) AS TotalInvoiceAmount
FROM Invoices
WHERE InvoiceDate > '2015-09-01';


-- ==> Figure 5-03.sql <==


SELECT VendorID, AVG(InvoiceTotal) AS AverageInvoiceAmount
FROM Invoices
GROUP BY VendorID
HAVING AVG(InvoiceTotal) > 2000
ORDER BY AverageInvoiceAmount DESC;


-- ==> Figure 5-04a.sql <==


SELECT VendorID, COUNT(*) AS InvoiceQty
FROM Invoices
GROUP BY VendorID;

-- ==> Figure 5-04b.sql <==


SELECT VendorState, VendorCity, COUNT(*) AS InvoiceQty,
    AVG(InvoiceTotal) AS InvoiceAvg
FROM Invoices JOIN Vendors
    ON Invoices.VendorID = Vendors.VendorID
GROUP BY VendorState, VendorCity
ORDER BY VendorState, VendorCity;


-- ==> Figure 5-04c.sql <==


SELECT VendorState, VendorCity, COUNT(*) AS InvoiceQty,
    AVG(InvoiceTotal) AS InvoiceAvg
FROM Invoices JOIN Vendors
    ON Invoices.VendorID = Vendors.VendorID
GROUP BY VendorState, VendorCity
HAVING COUNT(*) >= 2
ORDER BY VendorState, VendorCity;


-- ==> Figure 5-05a.sql <==


SELECT VendorName, COUNT(*) AS InvoiceQty,
    AVG(InvoiceTotal) AS InvoiceAvg
FROM Vendors JOIN Invoices
    ON Vendors.VendorID = Invoices.VendorID
GROUP BY VendorName
HAVING AVG(InvoiceTotal) > 500
ORDER BY InvoiceQty DESC;


-- ==> Figure 5-05b.sql <==


SELECT VendorName, COUNT(*) AS InvoiceQty,
    AVG(InvoiceTotal) AS InvoiceAvg
FROM Vendors JOIN Invoices
    ON Vendors.VendorID = Invoices.VendorID
WHERE InvoiceTotal > 500
GROUP BY VendorName
ORDER BY InvoiceQty DESC;

-- ==> Figure 5-06a.sql <==


SELECT InvoiceDate, COUNT(*) AS InvoiceQty, SUM(InvoiceTotal) AS InvoiceSum
FROM Invoices
GROUP BY InvoiceDate
HAVING InvoiceDate BETWEEN '2016-01-01' AND '2016-01-31'
   AND COUNT(*) > 1
   AND SUM(InvoiceTotal) > 100
ORDER BY InvoiceDate DESC;

SELECT InvoiceDate, COUNT(*) AS InvoiceQty, SUM(InvoiceTotal) AS InvoiceSum
FROM Invoices
WHERE InvoiceDate BETWEEN '2016-01-01' AND '2016-01-31'
GROUP BY InvoiceDate
HAVING COUNT(*) > 1
   AND SUM(InvoiceTotal) > 100
ORDER BY InvoiceDate DESC;

-- ==> Figure 5-07a.sql <==


SELECT VendorID, COUNT(*) AS InvoiceCount,
    SUM(InvoiceTotal) AS InvoiceTotal
FROM Invoices
GROUP BY VendorID WITH ROLLUP;

-- GROUP BY ROLLUP(VendorID) -- 2008 and later

-- ==> Figure 5-07b.sql <==


SELECT VendorState, VendorCity, COUNT(*) AS QtyVendors
FROM Vendors
WHERE VendorState IN ('IA', 'NJ')
GROUP BY VendorState, VendorCity WITH ROLLUP
ORDER BY VendorState DESC, VendorCity DESC;


-- ==> Figure 5-08a.sql <==


SELECT VendorID, COUNT(*) AS InvoiceCount,
    SUM(InvoiceTotal) AS InvoiceTotal
FROM Invoices
-- GROUP BY CUBE(VendorID) -- 2008 and later
GROUP BY VendorID WITH CUBE;
-- ==> Figure 5-08b.sql <==


SELECT VendorState, VendorCity, COUNT(*) AS QtyVendors
FROM Vendors
WHERE VendorState IN ('IA', 'NJ')
GROUP BY VendorState, VendorCity WITH CUBE
-- GROUP BY CUBE(VendorState, VendorCity) -- 2008 and later
ORDER BY VendorState DESC, VendorCity DESC;

-- ==> Figure 5-09a.sql <==


SELECT VendorState, VendorCity, COUNT(*) AS QtyVendors
FROM Vendors
WHERE VendorState IN ('IA', 'NJ')
GROUP BY GROUPING SETS(VendorState, VendorCity)
ORDER BY VendorState DESC, VendorCity DESC;


-- ==> Figure 5-09b.sql <==


SELECT VendorState, VendorCity, VendorZipCode, 
       COUNT(*) AS QtyVendors
FROM Vendors
WHERE VendorState IN ('IA', 'NJ')
GROUP BY GROUPING SETS((VendorState, VendorCity), VendorZipCode, ())
ORDER BY VendorState DESC, VendorCity DESC;

-- ==> Figure 5-09c.sql <==


SELECT VendorState, VendorCity, VendorZipCode, 
       COUNT(*) AS QtyVendors
FROM Vendors
WHERE VendorState IN ('IA', 'NJ')
GROUP BY GROUPING SETS(ROLLUP(VendorState, VendorCity), VendorZipCode)
ORDER BY VendorState DESC, VendorCity DESC:

-- ==> Figure5-10a.sql <==


SELECT InvoiceNumber, InvoiceDate, InvoiceTotal,
    SUM(InvoiceTotal) OVER (PARTITION BY InvoiceDate) AS DateTotal,
    COUNT(InvoiceTotal) OVER (PARTITION BY InvoiceDate) AS DateCount,
    AVG(InvoiceTotal) OVER (PARTITION BY InvoiceDate) AS DateAvg
FROM Invoices;

-- ==> Figure5-10b.sql <==


SELECT InvoiceNumber, InvoiceDate, InvoiceTotal,
    SUM(InvoiceTotal) OVER (ORDER BY InvoiceDate) AS CumTotal,
    COUNT(InvoiceTotal) OVER (ORDER BY InvoiceDate) AS Count,
    AVG(InvoiceTotal) OVER (ORDER BY InvoiceDate) AS MovingAvg
FROM Invoices;

-- ==> Figure5-10c.sql <==


SELECT InvoiceNumber, TermsID, InvoiceDate, InvoiceTotal,
    SUM(InvoiceTotal)
        OVER (PARTITION BY TermsID ORDER BY InvoiceDate) AS CumTotal,
    COUNT(InvoiceTotal)
        OVER (PARTITION BY TermsID ORDER BY InvoiceDate) AS Count,
    AVG(InvoiceTotal)
        OVER (PARTITION BY TermsID ORDER BY InvoiceDate) AS MovingAvg
FROM Invoices;
