-- Execute DDL statements
-- (Copy contents of Create.txt here)

DROP TABLE IF EXISTS PAYSTUB CASCADE;
DROP TABLE IF EXISTS INVOICE CASCADE;  -- rename from INVOICE for clarity
DROP TABLE IF EXISTS PRESCRIPTION CASCADE;
DROP TABLE IF EXISTS INSURANCEPOLICY CASCADE;
DROP TABLE IF EXISTS EQUIPMENT CASCADE;
DROP TABLE IF EXISTS STAFF CASCADE;
DROP TABLE IF EXISTS DEPARTMENT CASCADE;
DROP TABLE IF EXISTS MEDICATION CASCADE;
DROP TABLE IF EXISTS PHARMACY CASCADE;
DROP TABLE IF EXISTS PATIENT CASCADE;


-- Table Definitions


-- PATIENT
CREATE TABLE PATIENT (
    PatientID INT PRIMARY KEY,
    PatientFirstName VARCHAR(100) NOT NULL,
    PatientLastName VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Sex CHAR(1) NOT NULL CHECK (Sex IN ('M', 'F')),
    Address VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL
);


-- PHARMACY
CREATE TABLE PHARMACY (
    PharmacyID INT PRIMARY KEY,
    PharmacyLocation VARCHAR(255) NOT NULL,
    Contact VARCHAR(15) UNIQUE NOT NULL
);


-- MEDICATION
CREATE TABLE MEDICATION (
    MedicationID INT PRIMARY KEY,
    MedicationName VARCHAR(100) NOT NULL,
    MedicationType VARCHAR(50) NOT NULL,
    Manufacturer VARCHAR(100) NOT NULL,
    ExpiryDate DATE NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);


-- DEPARTMENT
CREATE TABLE DEPARTMENT (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    DepartmentPhoneNumber VARCHAR(15) NOT NULL,
    DepartmentFaxNumber VARCHAR(15)
);


-- STAFF
CREATE TABLE STAFF (
    StaffID INT PRIMARY KEY,
    EnrollmentStatus INT NOT NULL CHECK (EnrollmentStatus IN (0, 1)),
    StaffFirstName VARCHAR(100) NOT NULL,
    StaffLastName VARCHAR(100) NOT NULL,
    StaffSSN VARCHAR(11) NOT NULL UNIQUE,
    StaffBillingNumber VARCHAR(20)
);


-- EQUIPMENT
CREATE TABLE EQUIPMENT (
    EquipmentID INT PRIMARY KEY,
    EquipmentName VARCHAR(100) NOT NULL,
    EquipmentCategory VARCHAR(100) NOT NULL,
    EquipmentStock INT NOT NULL CHECK (EquipmentStock >= 0),
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES DEPARTMENT(DepartmentID) ON DELETE CASCADE
);


-- PRESCRIPTION
CREATE TABLE PRESCRIPTION (
    PrescriptionID INT PRIMARY KEY,
    PrescriptionDate DATE NOT NULL,
    PatientID INT NOT NULL,
    StaffID INT NOT NULL DEFAULT 1,  
    MedicationID INT NOT NULL,
    PharmacyID INT NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID),
    FOREIGN KEY (StaffID) REFERENCES STAFF(StaffID),
    FOREIGN KEY (MedicationID) REFERENCES MEDICATION(MedicationID),
    FOREIGN KEY (PharmacyID) REFERENCES PHARMACY(PharmacyID)
);


-- INSURANCE POLICY
CREATE TABLE INSURANCEPOLICY (
    InsurancePolicyID VARCHAR(50) PRIMARY KEY,
    InsuranceName VARCHAR(50) UNIQUE NOT NULL,
    InsurancePhoneNumber VARCHAR(15),
    BillingNumber VARCHAR(20) UNIQUE NOT NULL,
    FaxNumber VARCHAR(15),
    PatientID INT UNIQUE NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID) ON DELETE CASCADE
);


-- INVOICE
CREATE TABLE INVOICE (
    InvoiceID INT PRIMARY KEY,
    InvoiceAmount DECIMAL(10,2) NOT NULL CHECK (InvoiceAmount > 0),
    InvoiceDate DATE NOT NULL DEFAULT CURRENT_DATE, -- Defaults to current date if NULL
    PatientID INT NOT NULL DEFAULT 1,
    FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID) ON DELETE CASCADE
);


-- PAYSTUB
CREATE TABLE PAYSTUB (
    PaystubID INT PRIMARY KEY,
    StaffID INT NOT NULL,
    PaystubDate DATE NOT NULL,
    PaystubAmount DECIMAL(10,2) NOT NULL CHECK (PaystubAmount >= 0) DEFAULT 1000.0,
    FOREIGN KEY (StaffID) REFERENCES STAFF(StaffID) ON DELETE CASCADE
);


-- Insert sample data
-- (Copy contents of Inserts.txt here)


-- Data Insert Statements


-- PATIENT
INSERT INTO PATIENT (PatientID, PatientFirstName, PatientLastName, DateOfBirth, Sex, Address, PhoneNumber)
VALUES 
(1, 'Marsel', 'Fetlyaev', '2002-03-14', 'M', '123 Main St', '555-2877329'),
(2, 'Ramis', 'Sultanov', '2002-07-10', 'M', '456 Elm St', '555-4452210'),
(3, 'Shivam', 'Chauhan', '2002-07-05', 'M', '789 Oak Ave', '555-0012345'),
(4, 'Srishti', 'Nagraj', '2002-04-05', 'F', '101 Maple Dr', '555-1234564'),
(5, 'Vasili', 'Kitaigorod', '1963-02-17', 'M', '202 Pine Rd', '555-6543251'),
(6, 'Margot', 'Robbie', '1990-07-02', 'F', '303 Cedar Ln', '555-0101041'),
(7, 'Taylor', 'Swift', '1987-12-13', 'F', '404 Birch Blvd', '555-1111983'),
(8, 'Barack', 'Obama', '1961-08-04', 'M', '505 Walnut Way', '555-6782342'),
(9, 'Jennifer', 'Lopez', '2000-08-19', 'F', '606 Ash Ct', '555-1102231'),
(10, 'Michael', 'Jordan', '2003-09-29', 'M', '707 Cherry Cir', '555-1002339');


-- PHARMACY
INSERT INTO PHARMACY (PharmacyID, PharmacyLocation, Contact)
VALUES 
(1, 'Tampa Pharmacy', '555-2001123'),
(2, 'Miami Pharmacy', '555-2002321'),
(3, 'Central Pharmacy', '555-2003778'),
(4, 'Westside Pharmacy', '555-2004112'),
(5, 'Eastside Pharmacy', '555-2005008'),
(6, 'North Pharmacy', '555-2006778'),
(7, 'South Pharmacy', '555-2007243'),
(8, 'Valley Pharmacy', '555-2008241'),
(9, 'Mountain Pharmacy', '555-2009889'),
(10, 'Beach Pharmacy', '555-2010202');


-- DEPARTMENT
INSERT INTO DEPARTMENT (DepartmentID, DepartmentName, DepartmentPhoneNumber, DepartmentFaxNumber)
VALUES 
(1, 'Emergency', '555-3001', '555-3002'),
(2, 'Cardiology', '555-3003', '555-3004'),
(3, 'Radiology', '555-3005', '555-3006'),
(4, 'Pediatrics', '555-3007', '555-3008'),
(5, 'Oncology', '555-3009', '555-3010'),
(6, 'Neurology', '555-3011', '555-3012'),
(7, 'Orthopedics', '555-3013', '555-3014'),
(8, 'Dermatology', '555-3015', '555-3016'),
(9, 'Laboratory', '555-3017', '555-3018'),
(10, 'Maternity', '555-3019', '555-3020');


-- STAFF
INSERT INTO STAFF (StaffID, EnrollmentStatus, StaffFirstName, StaffLastName, StaffSSN, StaffBillingNumber)
VALUES 
(1, 1, 'Alice', 'Wonderland', '111-22-3333', 'B1001'),
(2, 1, 'Satabdee', 'Purkayastha', '222-33-4444', 'B1002'),
(3, 0, 'Aubrey', 'Graham', '333-44-5555', 'B1003'),
(4, 1, 'Anne', 'Frank', '444-55-6666', 'B1004'),
(5, 1, 'Playboy', 'Carti', '555-66-7777', 'B1005'),
(6, 0, 'Frank', 'Ocean', '666-77-8888', 'B1006'),
(7, 1, 'Grace', 'Johnson', '777-88-9999', 'B1007'),
(8, 0, 'Henry', 'Ford', '888-99-0000', 'B1008'),
(9, 1, 'Walter', 'White', '999-00-1111', 'B1009'),
(10, 1, 'Jake', 'Paul', '000-11-2222', 'B1010');


-- MEDICATION
INSERT INTO MEDICATION (MedicationID, MedicationName, MedicationType, Manufacturer, ExpiryDate, Price)
VALUES 
(1, 'Aspirin', 'Tablet', 'Bayer', '2025-01-01', 5.99),
(2, 'Penicillin', 'Antibiotic', 'Pfizer', '2026-03-15', 10.50),
(3, 'Tylenol', 'Tablet', 'Johnson & Johnson', '2025-12-31', 7.99),
(4, 'Metformin', 'Tablet', 'Merck', '2026-05-20', 12.00),
(5, 'Lipitor', 'Tablet', 'Pfizer', '2025-10-10', 15.75),
(6, 'Insulin', 'Injection', 'Novo Nordisk', '2025-08-01', 25.00),
(7, 'Ventolin', 'Inhaler', 'GlaxoSmithKline', '2025-09-15', 18.50),
(8, 'Adderall', 'Tablet', 'Shire', '2026-02-28', 9.99),
(9, 'Zoloft', 'Tablet', 'Pfizer', '2026-06-30', 11.25),
(10, 'Omeprazole', 'Capsule', 'AstraZeneca', '2025-11-11', 8.50);


-- EQUIPMENT
INSERT INTO EQUIPMENT (EquipmentID, EquipmentName, EquipmentCategory, EquipmentStock, DepartmentID)
VALUES 
(1, 'X-Ray Machine', 'Imaging', 5, 1),
(2, 'ECG Monitor', 'Cardio', 3, 2),
(3, 'MRI Scanner', 'Imaging', 2, 3),
(4, 'Infant Incubator', 'Pediatric', 4, 4),
(5, 'Chemotherapy Chair', 'Oncology', 10, 5),
(6, 'EEG Machine', 'Neurology', 2, 6),
(7, 'Bone Saw', 'Orthopedics', 8, 7),
(8, 'UV Light Therapy Unit', 'Dermatology', 2, 8),
(9, 'Centrifuge', 'Lab Equipment', 4, 9),
(10, 'Birthing Bed', 'Maternity', 6, 10);


-- INSURANCE POLICY
INSERT INTO INSURANCEPOLICY (InsurancePolicyID, InsuranceName, InsurancePhoneNumber, BillingNumber, FaxNumber, PatientID)
VALUES
('P-1001', 'Aetna', '555-4001', 'BN-1001', '555-4002', 1),
('P-1002', 'Blue Cross', '555-4003', 'BN-1002', '555-4004', 2),
('P-1003', 'Cigna', '555-4005', 'BN-1003', '555-4006', 3),
('P-1004', 'UnitedHealth', '555-4007', 'BN-1004', '555-4008', 4),
('P-1005', 'Kaiser', '555-4009', 'BN-1005', '555-4010', 5),
('P-1006', 'Humana', '555-4011', 'BN-1006', '555-4012', 6),
('P-1007', 'Anthem', '555-4013', 'BN-1007', '555-4014', 7),
('P-1008', 'Molina', '555-4015', 'BN-1008', '555-4016', 8),
('P-1009', 'Oscar', '555-4017', 'BN-1009', '555-4018', 9),
('P-1010', 'Providence', '555-4019', 'BN-1010', '555-4020', 10);


-- PRESCRIPTION
INSERT INTO PRESCRIPTION (PrescriptionID, PrescriptionDate, PatientID, StaffID, MedicationID, PharmacyID)
VALUES
(1, '2025-01-02', 1, 1, 1, 1),
(2, '2025-01-03', 2, 2, 2, 1),
(3, '2025-01-04', 3, 3, 3, 3),
(4, '2025-01-05', 4, 4, 4, 4),
(5, '2025-01-06', 5, 5, 5, 5),
(6, '2025-01-07', 6, 6, 6, 6),
(7, '2025-01-08', 7, 7, 7, 7),
(8, '2025-01-09', 8, 8, 8, 8),
(9, '2025-01-10', 9, 9, 9, 9),
(10, '2025-01-11', 10, 10, 3, 10);



-- INVOICE (using the trigger to set the date if NULL)
INSERT INTO INVOICE (InvoiceID, InvoiceAmount, InvoiceDate, PatientID)
VALUES
(1, 100.00, DEFAULT, 1),
(2, 200.00, DEFAULT, 2),
(3, 300.00, '2025-02-01', 3),
(4, 400.00, DEFAULT, 4),
(5, 500.00, '2025-02-05', 5),
(6, 600.00, DEFAULT, 6),
(7, 750.00, '2025-03-01', 7),
(8, 800.00, DEFAULT, 8),
(9, 900.00, '2025-03-10', 9),
(10, 1000.00, DEFAULT, 10);


-- PAYSTUB
INSERT INTO PAYSTUB (PaystubID, StaffID, PaystubDate, PaystubAmount)
VALUES
(1, 1, '2025-04-01', 1500.00),
(2, 2, '2025-04-02', 1600.00),
(3, 3, '2025-04-03', 1200.00),
(4, 4, '2025-04-04', 1850.00),
(5, 5, '2025-04-05', 2000.00),
(6, 6, '2025-04-06', 1750.00),
(7, 7, '2025-04-07', 2200.00),
(8, 8, '2025-04-08', 1300.00),
(9, 9, '2025-04-09', 1425.00),
(10, 10, '2025-04-10', 1950.00);


-- Additional PRESCRIPTION entries 
INSERT INTO PRESCRIPTION (PrescriptionID, PrescriptionDate, PatientID, StaffID, MedicationID, PharmacyID)
VALUES 
(11, '2025-01-12', 10, 10, 1, 10),
(12, '2025-01-15', 10, 10, 2, 10),
(13, '2025-01-11', 1, 1, 1, 1),
(14, '2025-01-12', 5, 3, 7, 10),
(15, '2025-01-13', 8, 2, 2, 1),
(16, '2025-01-14', 10, 1, 6, 9),
(17, '2025-01-12', 2, 2, 3, 3),
(18, '2025-01-13', 2, 3, 4, 4),
(19, '2025-01-14', 2, 4, 5, 5),
(20, '2025-01-15', 2, 10, 4, 2);

-- Additional INVOICE entries for average-based queries
INSERT INTO INVOICE (InvoiceID, InvoiceAmount, InvoiceDate, PatientID)
VALUES 
(11, 150, '2025-02-26', 2),
(12, 1200, '2025-02-27', 2),
(13, 150, '2025-02-28', 1),
(14, 1600, '2025-03-01', 1),
(15, 1200, '2025-03-02', 5);

-- Additional PAYSTUB entries for aggregation
INSERT INTO PAYSTUB (PaystubID, StaffID, PaystubDate, PaystubAmount)
VALUES 
(11, 9, '2025-04-26', 2500),
(12, 4, '2025-04-27', 1000),
(13, 8, '2025-04-28', 2000),
(14, 2, '2025-04-29', 2000),
(15, 2, '2025-04-30', 2000);

-- Additional MEDICATION entries for price diversity
INSERT INTO MEDICATION (MedicationID, MedicationName, MedicationType, Manufacturer, ExpiryDate, Price)
VALUES 
(11, 'Ibuprofen', 'Tablet', 'GenPharma', '2026-12-31', 30.75),
(12, 'Naproxen', 'Tablet', 'GenPharma', '2026-12-31', 20.99),
(13, 'OxyContin', 'Tablet', 'GenPharma', '2026-12-31', 30.75);

-- Add a patient WITHOUT insurance or prescriptions
INSERT INTO PATIENT (PatientID, PatientFirstName, PatientLastName, DateOfBirth, Sex, Address, PhoneNumber)
VALUES 
(11, 'Christian', 'Bale', '1995-11-11', 'M', '123 Cypress Hill', '555-7777777'),
(12, 'Heath', 'Ledger', '1998-08-08', 'F', '789 Meadow Ln', '555-8888888');

-- Execute update statements
-- (Copy contents of Updates.txt here)


-- Row updates


-- PATIENT
UPDATE patient
SET phonenumber = '555-9999999'
WHERE patientid = 1;

UPDATE patient
SET address = '456 Fletcher Ave, Tampa, FL'
WHERE patientlastname = 'Smith';

UPDATE patient
SET address = 'Updated Address - Female Patients'
WHERE sex = 'F';

UPDATE patient
SET patientfirstname = 'Emily', patientlastname = 'Johnson'
WHERE patientid = 3;


-- PHARMACY
UPDATE pharmacy
SET contact = '888-1234'
WHERE pharmacyid = 2;

UPDATE pharmacy
SET pharmacylocation = 'Downtown Medical Plaza'
WHERE pharmacyid = 3;

UPDATE pharmacy
SET pharmacylocation = pharmacylocation || ' - Updated'
WHERE pharmacylocation NOT LIKE '% - Updated';

UPDATE pharmacy
SET contact = '999-9999999'
WHERE pharmacyid = 4;


-- MEDICATION
UPDATE medication
SET price = 12.99
WHERE medicationname = 'Paracetamol';

UPDATE medication
SET manufacturer = 'HealthCorp Inc.'
WHERE medicationtype = 'Antibiotic';

UPDATE medication
SET price = price * 0.9
WHERE EXTRACT(YEAR FROM expirydate) = EXTRACT(YEAR FROM CURRENT_DATE);

UPDATE medication
SET expirydate = '2029-04-20'
WHERE medicationname = 'Omeprazole';


-- DEPARTMENT
UPDATE department
SET departmentphonenumber = '777-0000'
WHERE departmentname = 'Cardiology';

UPDATE department
SET departmentname = 'Internal Medicine'
WHERE departmentid = 2;

UPDATE department
SET departmentphonenumber = '555-1234567';

UPDATE department
SET departmentname = 'Dept. ' || departmentname;


-- STAFF
UPDATE staff
SET StaffSSN = '987-65-4321'
WHERE StaffFirstName = 'Frank' AND StaffLastName = 'Ocean';

UPDATE staff
SET EnrollmentStatus = 1
WHERE StaffID = 3;

UPDATE staff
SET StaffBillingNumber = 'S-' || StaffBillingNumber;

UPDATE staff
SET StaffLastName = 'Jameson'
WHERE StaffID = 7;


-- EQUIPMENT
UPDATE equipment
SET equipmentname = 'Advanced X-Ray Scanner'
WHERE equipmentid = 3;

UPDATE equipment
SET equipmentcategory = 'Diagnostic Equipment'
WHERE equipmentcategory = 'Diagnostic';

UPDATE equipment
SET equipmentstock = equipmentstock + 1;

UPDATE equipment
SET equipmentname = 'Equipment - ' || equipmentname
WHERE EquipmentCategory = 'Imaging';


-- PRESCRIPTION
UPDATE prescription
SET prescriptiondate = CURRENT_DATE
WHERE prescriptionid = 5;

UPDATE prescription
SET pharmacyid = 2
WHERE prescriptionid = 6;

UPDATE prescription
SET patientid = 4
WHERE prescriptionid = 7;

UPDATE prescription
SET medicationid = 10
WHERE prescriptionid = 8;


-- INSURANCE POLICY
UPDATE insurancepolicy
SET insurancename = 'GlobalHealth Insurance'
WHERE insurancepolicyid = 'P-1001';

UPDATE insurancepolicy
SET billingnumber = 'INS-' || billingnumber;

UPDATE insurancepolicy
SET faxnumber = REPLACE(faxnumber, '-', '')
WHERE faxnumber IS NOT NULL;

UPDATE insurancepolicy
SET insurancephonenumber = '800-888-9999'
WHERE insurancepolicyid = 'P-1002';


-- INVOICE
UPDATE invoice
SET invoiceamount = invoiceamount + 50.00
WHERE invoiceid = 1;

UPDATE invoice
SET invoicedate = '2025-01-01'
WHERE invoiceid = 2;

UPDATE invoice
SET invoiceamount = invoiceamount * 0.9
WHERE invoiceamount > 1000;

UPDATE invoice
SET invoicedate = '2025-02-15', invoiceamount = 750.00
WHERE invoiceid = 4;


-- PAYSTUB
UPDATE paystub
SET paystubamount = 3000.00
WHERE paystubid = 1;

UPDATE paystub
SET paystubdate = CURRENT_DATE
WHERE paystubid = 2;

UPDATE paystub
SET paystubamount = paystubamount + 500
WHERE staffid = 103;

UPDATE paystub
SET paystubamount = paystubamount * 1.05
WHERE paystubamount > 2500; 

/*
-- Run constraint violation checks
-- (Copy contents of ConstraintsCheck.txt here)


-- Constraint Checks

-- Sex = only 'M' or 'F'
-- Constraint Checks

-- Sex = only 'M' or 'F'
UPDATE PATIENT
SET Sex = 'X' 
WHERE PatientID = 1;


-- Equipment Stock >= 0
INSERT INTO EQUIPMENT (EquipmentID, EquipmentName, EquipmentCategory, EquipmentStock, DepartmentID)
VALUES (100, 'Scanner', 'Diagnostic', -5, 1);


-- Duplicate of PharmacyID 1’s contact
UPDATE PHARMACY
SET Contact = '555-2001123'
WHERE PharmacyID = 2;


-- NOT NULL for PatientFirstName
UPDATE PATIENT
SET PatientFirstName = NULL
WHERE PatientID = 5;


-- PharmacyID = 999 does not exist
INSERT INTO MEDICATION (MedicationID, MedicationName, MedicationType, Manufacturer, ExpiryDate, Price, PharmacyID)
VALUES (100, 'Aspirin', 'Painkiller', 'PharmaCorp', '2025-12-31', 10.99, 999);


-- Enrollment status = 0 or 1
INSERT INTO STAFF (StaffID, EnrollmentStatus, StaffFirstName, StaffLastName, StaffSSN)
VALUES (100, 2, 'Gregory', 'House', '777-88-0000');


-- PatientID = 1 already has insurance
INSERT INTO INSURANCEPOLICY (InsurancePolicyID, InsuranceName, BillingNumber, PatientID)
VALUES ('P-9999', 'HealthPlus', 'BILL-101', 1);


-- PaystubAmount >= 0
INSERT INTO PAYSTUB (PaystubID, StaffID, PaystubDate, PaystubAmount)
VALUES (100, 1, CURRENT_DATE, -500.00);


-- MedicationID = 999 does not exist
UPDATE PRESCRIPTION
SET MedicationID = 999
WHERE PrescriptionID = 1;


-- Negative InvoiceAmount value
INSERT INTO INVOICE (InvoiceID, InvoiceAmount, InvoiceDate, PatientID)
VALUES (11, -42.00, NULL, 5); */

-- QUERIES WITH AGGREGATION (GROUP BY / HAVING)

-- 1. List all patients and their prescription counts.
SELECT 
    Patient.PatientFirstName || ' ' || Patient.PatientLastName AS FullName,
    COUNT(Prescription.PrescriptionID) AS TotalPrescriptions
FROM Patient
LEFT JOIN Prescription ON Patient.PatientID = Prescription.PatientID
GROUP BY Patient.PatientFirstName, Patient.PatientLastName;


-- 2. List pharmacies that have issued prescriptions for more than 2 distinct medications.
SELECT Pharmacy.PharmacyLocation, COUNT(DISTINCT Prescription.MedicationID) AS DistinctMeds
FROM Pharmacy
JOIN Prescription ON Pharmacy.PharmacyID = Prescription.PharmacyID
GROUP BY Pharmacy.PharmacyLocation
HAVING COUNT(DISTINCT Prescription.MedicationID) > 2;

-- 3. Aggregates the total price of medications prescribed by each staff member.
SELECT 
    Staff.StaffFirstName || ' ' || Staff.StaffLastName AS FullName,
    SUM(Medication.Price) AS TotalMedicationCost
FROM 
    Staff
JOIN 
    Prescription ON Staff.StaffID = Prescription.StaffID
JOIN 
    Medication ON Prescription.MedicationID = Medication.MedicationID
GROUP BY 
    FullName
HAVING 
    SUM(Medication.Price) > 20;

-- 4. List departments and the total equipment stock per department.
SELECT Department.DepartmentName, SUM(Equipment.EquipmentStock) AS TotalStock
FROM Department
JOIN Equipment ON Department.DepartmentID = Equipment.DepartmentID
GROUP BY Department.DepartmentName;

-- 5. Retrieve staff and the total paystub amount they have received.
SELECT Staff.StaffFirstName || ' ' || Staff.StaffLastName AS FullName,
       SUM(Paystub.PaystubAmount) AS TotalPay
FROM Staff
JOIN Paystub ON Staff.StaffID = Paystub.StaffID
GROUP BY FullName;

-- QUERIES USING SUBQUERIES

-- 6. Find patients who have invoices above the average invoice amount.
SELECT Patient.PatientFirstName || ' ' || Patient.PatientLastName AS FullName, Invoice.InvoiceAmount
FROM Patient
JOIN Invoice ON Patient.PatientID = Invoice.PatientID
WHERE Invoice.InvoiceAmount > (
    SELECT AVG(InvoiceAmount) FROM Invoice
);

-- 7. Show all patients who don’t have any insurance policy.
SELECT Patient.PatientFirstName || ' ' || Patient.PatientLastName AS FullName
FROM Patient
LEFT JOIN InsurancePolicy ON Patient.PatientID = InsurancePolicy.PatientID
WHERE InsurancePolicy.PatientID IS NULL;

-- CORRELATED SUBQUERIES (also counted as subqueries)

-- 8. Find medications that cost more than the average price of their type.
SELECT Medication.MedicationName, Medication.MedicationType, Medication.Price
FROM Medication
WHERE Medication.Price > (
    SELECT AVG(Medication2.Price)
    FROM Medication AS Medication2
    WHERE Medication2.MedicationType = Medication.MedicationType
);

-- 9. Find patients who only received prescriptions from one pharmacy.
SELECT Patient.PatientFirstName || ' ' || Patient.PatientLastName AS FullName
FROM Patient
WHERE 1 = (
    SELECT COUNT(DISTINCT Prescription.PharmacyID)
    FROM Prescription
    WHERE Prescription.PatientID = Patient.PatientID
);

-- JOINS ON 3 OR MORE TABLES

-- 10. Find the most frequently prescribed medication and which staff prescribed it the most.
SELECT Medication.MedicationName, Staff.StaffFirstName || ' ' || Staff.StaffLastName AS Prescriber,
       COUNT(*) AS TimesPrescribed
FROM Medication
JOIN Prescription ON Medication.MedicationID = Prescription.MedicationID
JOIN Staff ON Prescription.StaffID = Staff.StaffID
GROUP BY Medication.MedicationName, Prescriber
ORDER BY TimesPrescribed DESC
LIMIT 1;

-- 11. List patients, medications prescribed to them, and the pharmacy used.
SELECT Patient.PatientFirstName || ' ' || Patient.PatientLastName AS FullName,
       Medication.MedicationName,
       Pharmacy.PharmacyLocation
FROM Patient
JOIN Prescription ON Patient.PatientID = Prescription.PatientID
JOIN Medication ON Prescription.MedicationID = Medication.MedicationID
JOIN Pharmacy ON Prescription.PharmacyID = Pharmacy.PharmacyID;

-- 12. Find expired medications that were prescribed and the pharmacy where they were dispensed.
SELECT DISTINCT Medication.MedicationName, Medication.ExpiryDate, Pharmacy.PharmacyLocation
FROM Medication
JOIN Prescription ON Medication.MedicationID = Prescription.MedicationID
JOIN Pharmacy ON Prescription.PharmacyID = Pharmacy.PharmacyID
WHERE Medication.ExpiryDate < CURRENT_DATE;
