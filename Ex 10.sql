DROP TABLE IF EXISTS Sales;

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Amount DECIMAL(10,2),
    SaleDate DATE,
    City VARCHAR(50)
) ENGINE=InnoDB;

-- Generate 10,000 records
DELIMITER //

DROP PROCEDURE IF EXISTS GenerateData//

CREATE PROCEDURE GenerateData()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 10000 DO
        INSERT INTO Sales VALUES (
            i,
            i % 1000,
            i % 100,
            (i % 5000) + 100,
            DATE_ADD('2025-01-01', INTERVAL (i % 365) DAY),
            CASE
                WHEN i % 3 = 0 THEN 'Delhi'
                WHEN i % 3 = 1 THEN 'Mumbai'
                ELSE 'Kanpur'
            END
        );

        SET i = i + 1;
    END WHILE;
END//

DELIMITER ;

CALL GenerateData();

-- Verify number of records
SELECT COUNT(*) AS Total_Records FROM Sales;

-- QUERY 1: Search by CustomerID (before optimization)
EXPLAIN
SELECT * FROM Sales WHERE CustomerID = 105;

SELECT * FROM Sales WHERE CustomerID = 105;

-- Optimize Query 1
CREATE INDEX idx_customer ON Sales(CustomerID);

EXPLAIN
SELECT * FROM Sales WHERE CustomerID = 105;

-- QUERY 2: Search by City (before optimization)
EXPLAIN
SELECT * FROM Sales WHERE City = 'Delhi';

-- Optimize Query 2
CREATE INDEX idx_city ON Sales(City);

EXPLAIN
SELECT * FROM Sales WHERE City = 'Delhi';

-- QUERY 3: Search by SaleDate (before optimization)
EXPLAIN
SELECT * FROM Sales WHERE SaleDate = '2025-03-01';

-- Optimize Query 3
CREATE INDEX idx_date ON Sales(SaleDate);

EXPLAIN
SELECT * FROM Sales WHERE SaleDate = '2025-03-01';

-- QUERY 4: Search by ProductID (before optimization)
EXPLAIN
SELECT * FROM Sales WHERE ProductID = 25;

-- Optimize Query 4
CREATE INDEX idx_product ON Sales(ProductID);

EXPLAIN
SELECT * FROM Sales WHERE ProductID = 25;

-- QUERY 5: Search by CustomerID and SaleDate (before optimization)
EXPLAIN
SELECT * FROM Sales
WHERE CustomerID = 105 AND SaleDate = '2025-03-01';

-- Optimize Query 5 using a composite index
CREATE INDEX idx_customer_date ON Sales(CustomerID, SaleDate);

EXPLAIN
SELECT * FROM Sales
WHERE CustomerID = 105 AND SaleDate = '2025-03-01';

-- Use EXPLAIN ANALYZE in MySQL 8.0.18+ (executes the SELECT)
EXPLAIN ANALYZE
SELECT * FROM Sales WHERE CustomerID = 105;

EXPLAIN ANALYZE
SELECT * FROM Sales
WHERE CustomerID = 105 AND SaleDate = '2025-03-01';