-- ***************************
-- Data setup for INSERT and UPDATE queries from chapter 7 - Murach's text book
-- Make copies of invoices and vendors table as we will be updating values
IF OBJECT_ID('VendorCopy') IS NOT NULL
   DROP TABLE VendorCopy;

SELECT *
INTO VendorCopy
FROM Vendors;

IF OBJECT_ID('InvoiceCopy') IS NOT NULL
   DROP TABLE InvoiceCopy;

SELECT *
INTO InvoiceCopy
FROM Invoices;


SELECT *
INTO OldInvoices
FROM Invoices
WHERE InvoiceTotal - PaymentTotal - CreditTotal = 0;

--  Figure 7-01c.sql <==
SELECT VendorID, SUM(InvoiceTotal) AS SumOfInvoices
INTO VendorBalances
FROM Invoices
WHERE InvoiceTotal - PaymentTotal - CreditTotal <> 0
GROUP BY VendorID;

--  Figure 7-01d.sql <==
-- DROP TABLE InvoiceCopy;
-- ***************************







--  Figure 7-02a.sql <==


INSERT INTO InvoiceCopy
VALUES (97, '456789', '2016-04-01', 8344.50, 0, 0, 1, '2016-04-30', NULL); 

--  Figure 7-02b.sql <==


INSERT INTO InvoiceCopy 
    (VendorID, InvoiceNumber, InvoiceTotal, PaymentTotal, CreditTotal,
    TermsID, InvoiceDate, InvoiceDueDate)
VALUES
    (97, '456789', 8344.50, 0, 0, 1, '2016-04-01', '2016-04-30'); 


--  Figure 7-02c.sql <==


INSERT INTO InvoiceCopy 
VALUES 
    (95, '111-10098', '2016-04-01', 219.50, 0, 0, 1, '2016-04-30', NULL),
    (102, '109596', '2016-04-01', 22.97, 0, 0, 1, '2016-04-30', NULL),
    (72, '40319', '2016-04-01', 173.38, 0, 0, 1, '2016-04-30', NULL); 


--  Figure 7-03a.sql <==
USE Examples;
 
IF OBJECT_ID('ColorSample') IS NOT NULL
   DROP TABLE ColorSample;

CREATE TABLE ColorSample
(ID INT IDENTITY(1,1) NOT NULL,
ColorNumber INT NOT NULL DEFAULT 0,
ColorName VARCHAR(10) NULL);
--  Figure 7-03b.sql <==
USE Examples;

INSERT INTO ColorSample (ColorNumber)
VALUES (606);

INSERT INTO ColorSample (ColorName)
VALUES ('Yellow');

INSERT INTO ColorSample
VALUES (DEFAULT, 'Orange');

INSERT INTO ColorSample
VALUES (808, NULL);

INSERT INTO ColorSample
VALUES (DEFAULT, NULL);

INSERT INTO ColorSample
DEFAULT VALUES;

SELECT * FROM ColorSample;

--  Figure 7-04a.sql <==


INSERT INTO InvoiceArchive
SELECT *
FROM InvoiceCopy
WHERE InvoiceTotal - PaymentTotal - CreditTotal = 0;

--  Figure 7-04b.sql <==


INSERT INTO InvoiceArchive
    (InvoiceID, VendorID, InvoiceNumber, InvoiceTotal, CreditTotal,
    PaymentTotal, TermsID, InvoiceDate, InvoiceDueDate)
SELECT
    InvoiceID, VendorID, InvoiceNumber, InvoiceTotal, CreditTotal, 
    PaymentTotal, TermsID, InvoiceDate, InvoiceDueDate
FROM InvoiceCopy
WHERE InvoiceTotal - PaymentTotal - CreditTotal = 0;

--  Figure 7-05a.sql <==


UPDATE InvoiceCopy
SET PaymentDate = '2016-05-21', 
    PaymentTotal = 19351.18
WHERE InvoiceNumber = '97/522';
--  Figure 7-05b.sql <==


UPDATE InvoiceCopy
SET TermsID = 1
WHERE VendorID = 95;

--  Figure 7-05c.sql <==


UPDATE InvoiceCopy
SET CreditTotal = CreditTotal + 100
WHERE InvoiceNumber = '97/522';

--  Figure 7-06a.sql <==


UPDATE InvoiceCopy
SET CreditTotal = CreditTotal + 100,
    InvoiceDueDate = (SELECT MAX(InvoiceDueDate) FROM InvoiceCopy)
WHERE InvoiceNumber = '97/522';

--  Figure 7-06b.sql <==


UPDATE InvoiceCopy
SET TermsID = 1
WHERE VendorID =
   (SELECT VendorID
    FROM VendorCopy
    WHERE VendorName = 'Pacific Bell');

--  Figure 7-06c.sql <==


UPDATE InvoiceCopy
SET TermsID = 1
WHERE VendorID IN
   (SELECT VendorID
    FROM VendorCopy
    WHERE VendorState IN ('CA', 'AZ', 'NV'));

--  Figure 7-06d.sql <==


UPDATE InvoiceCopy
SET CreditTotal = CreditTotal + 100
FROM
   (SELECT TOP 10 InvoiceID
    FROM InvoiceCopy
    WHERE InvoiceTotal - PaymentTotal - CreditTotal >= 100
    ORDER BY InvoiceTotal - PaymentTotal - CreditTotal DESC) AS TopInvoices
WHERE InvoiceCopy.InvoiceID = TopInvoices.InvoiceID;

--  Figure 7-07a.sql <==


UPDATE InvoiceCopy
SET TermsID = 1
FROM InvoiceCopy JOIN VendorCopy
    ON InvoiceCopy.VendorID = VendorCopy.VendorID
WHERE VendorName = 'Pacific Bell';

--  Figure 7-07b.sql <==


UPDATE VendorCopy
SET VendorContactLName = LastName,
    VendorContactFName = FirstName
FROM VendorCopy JOIN ContactUpdates
    ON VendorCopy.VendorID = ContactUpdates.VendorID;

--  Figure 7-07c.sql <==


SELECT * FROM ContactUpdates;

--  Figure 7-08a.sql <==


-- This statement assumes that you used the 
-- script stored in "Figure 7-02a.sql" to insert row 115
DELETE InvoiceCopy
WHERE InvoiceID = 115;

--  Figure 7-08b.sql <==


DELETE InvoiceCopy
WHERE VendorID = 37;

--  Figure 7-08c.sql <==


DELETE InvoiceCopy
WHERE InvoiceTotal - PaymentTotal - CreditTotal = 0;

--  Figure 7-08d.sql <==


DELETE InvoiceCopy;
--  Figure 7-09a.sql <==


DELETE InvoiceCopy
WHERE VendorID = 
   (SELECT VendorID
    FROM VendorCopy 
    WHERE VendorName = 'Blue Cross');

--  Figure 7-09b.sql <==


DELETE InvoiceCopy
FROM InvoiceCopy JOIN VendorCopy
    ON InvoiceCopy.VendorID = VendorCopy.VendorID
WHERE VendorName = 'Blue Cross';

--  Figure 7-09c.sql <==


DELETE VendorCopy
WHERE VendorID NOT IN 
   (SELECT DISTINCT VendorID FROM InvoiceCopy);

--  Figure 7-09d.sql <==


DELETE VendorCopy
FROM VendorCopy JOIN 
       (SELECT VendorID, SUM(InvoiceTotal) AS TotalOfInvoices
        FROM InvoiceCopy
        GROUP BY VendorID) AS InvoiceSum
    ON VendorCopy.VendorID = InvoiceSum.VendorID
WHERE TotalOfInvoices <= 100;

--  Figure 7-10a.sql <==


MERGE INTO InvoiceArchive AS ia
USING InvoiceCopy AS ic
ON ic.InvoiceID = ia.InvoiceID
WHEN MATCHED AND 
    ic.PaymentDate IS NOT NULL AND
    ic.PaymentTotal > ia.PaymentTotal
  THEN
  UPDATE SET 
    ia.PaymentTotal = ic.PaymentTotal, 
    ia.CreditTotal = ic.CreditTotal, 
    ia.PaymentDate = ic.PaymentDate
WHEN NOT MATCHED THEN
  INSERT (InvoiceID, VendorID, InvoiceNumber, 
    InvoiceTotal, PaymentTotal, CreditTotal,
    TermsID, InvoiceDate, InvoiceDueDate)
  VALUES (ic.InvoiceID, ic.VendorID, ic.InvoiceNumber, 
    ic.InvoiceTotal, ic.PaymentTotal, ic.CreditTotal,
    ic.TermsID, ic.InvoiceDate, ic.InvoiceDueDate)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
;
--  Figure 7-10b.sql <==


-- STEP 1: run the script in figure 7-10a
-- it should merge all rows in the InvoiceCopy table
-- into the InvoiceArchive table

-- STEP 2: run this script

-- insert a row
INSERT INTO InvoiceCopy
VALUES (3, 'P29381', '2016-08-01', 50.20, 0, 0, 1, '2016-08-31', NULL);

-- update a row
UPDATE InvoiceCopy
SET PaymentDate = '2016-05-21', 
    PaymentTotal = 579.42
WHERE InvoiceID = 114;

-- STEP 3: run the script in figure 7-10a again
-- it should only insert and update the two rows shown in this script;

--  Figure 7-10c.sql <==


DELETE FROM InvoiceArchive;