-- =====================================
-- Create Table
-- =====================================
DROP TABLE IF EXISTS FeePayments;

CREATE TABLE FeePayments (
    payment_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) CHECK (amount > 0),
    payment_date DATE NOT NULL
);

-- =====================================
-- Part A: Insert Multiple Fee Payments in a Transaction
-- =====================================
BEGIN TRANSACTION;

INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES 
(1, 'Ashish', 5000.00, '2024-06-01'),
(2, 'Smaran', 4500.00, '2024-06-02'),
(3, 'Vaibhav', 5500.00, '2024-06-03');

COMMIT;

-- Check inserted rows
SELECT * FROM FeePayments;

-- =====================================
-- Part B: Demonstrate ROLLBACK for Failed Payment Insertion
-- =====================================
BEGIN TRANSACTION;

-- First insert (valid)
INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (4, 'Kiran', 4800.00, '2024-06-04');

-- Second insert (invalid - duplicate payment_id = 1 and negative amount)
INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (1, 'Ashish', -3000.00, '2024-06-05');

-- Since this will fail, rollback entire transaction
ROLLBACK;

-- Verify rollback: No new rows added
SELECT * FROM FeePayments;

-- =====================================
-- Part C: Simulate Partial Failure and Ensure Consistent State
-- =====================================
BEGIN TRANSACTION;

-- Valid insert
INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (5, 'Rohit', 4900.00, '2024-06-06');

-- Invalid insert (NULL student_name)
INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (6, NULL, 5000.00, '2024-06-07');

-- Rollback entire transaction due to error
ROLLBACK;

-- Verify rollback: No new records should be present
SELECT * FROM FeePayments;

-- =====================================
-- Part D: Verify ACID Compliance
-- =====================================
-- Valid inserts
BEGIN TRANSACTION;
INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (7, 'Sneha', 4700.00, '2024-06-08'),
       (8, 'Arjun', 4900.00, '2024-06-09');
COMMIT;

-- Final table after all committed transactions
SELECT * FROM FeePayments;
