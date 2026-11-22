DROP TABLE IF EXISTS Bank;

CREATE TABLE Bank (
    AccountID INT PRIMARY KEY,
    Name VARCHAR(50),
    Balance DECIMAL(10,2)
) ENGINE=InnoDB;

INSERT INTO Bank VALUES
(101, 'Amit', 5000.00),
(102, 'Ravi', 3000.00);

-- 1. Transaction using COMMIT
START TRANSACTION;

UPDATE Bank
SET Balance = Balance - 1000
WHERE AccountID = 101;

UPDATE Bank
SET Balance = Balance + 1000
WHERE AccountID = 102;

COMMIT;

-- 2. Transaction using ROLLBACK
START TRANSACTION;

UPDATE Bank
SET Balance = Balance - 500
WHERE AccountID = 101;

ROLLBACK;

-- 3. Transaction using SAVEPOINT
START TRANSACTION;

UPDATE Bank
SET Balance = Balance - 500
WHERE AccountID = 101;

SAVEPOINT S1;

UPDATE Bank
SET Balance = Balance + 500
WHERE AccountID = 102;

ROLLBACK TO SAVEPOINT S1;
COMMIT;

-- 4. Display final balances
SELECT * FROM Bank;

-- 5. Demonstrate transaction isolation
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;
SELECT * FROM Bank;
COMMIT;