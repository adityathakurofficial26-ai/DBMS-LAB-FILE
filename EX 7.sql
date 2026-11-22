






DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Sales;

-- Original denormalized table (UNF example)
CREATE TABLE Sales (
    OrderID INT,
    CustomerID INT,
    CustomerName VARCHAR(50),
    ProductID INT,
    ProductName VARCHAR(50),
    Quantity INT,
    Price DECIMAL(10,2)
);

INSERT INTO Sales
(OrderID, CustomerID, CustomerName, ProductID, ProductName, Quantity, Price)
VALUES
(1, 101, 'Amit', 201, 'Laptop', 2, 50000.00),
(1, 101, 'Amit', 202, 'Mouse', 3, 500.00),
(2, 102, 'Ravi', 201, 'Laptop', 1, 50000.00);

-- 1NF: values are atomic; each row represents one product in an order.
SELECT * FROM Sales;

-- Functional dependencies:
-- OrderID -> CustomerID
-- CustomerID -> CustomerName
-- ProductID -> ProductName, Price
-- (OrderID, ProductID) -> Quantity
-- Candidate key of the 1NF Sales relation: (OrderID, ProductID)

-- 2NF / 3NF / BCNF decomposition:
-- Customers(CustomerID -> CustomerName)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50) NOT NULL
);

-- Orders(OrderID -> CustomerID)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Products(ProductID -> ProductName, Price)
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);

-- OrderDetails((OrderID, ProductID) -> Quantity)
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Load normalized tables from the original Sales table
INSERT INTO Customers (CustomerID, CustomerName)
SELECT DISTINCT CustomerID, CustomerName FROM Sales;

INSERT INTO Orders (OrderID, CustomerID)
SELECT DISTINCT OrderID, CustomerID FROM Sales;

INSERT INTO Products (ProductID, ProductName, Price)
SELECT DISTINCT ProductID, ProductName, Price FROM Sales;

INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
SELECT OrderID, ProductID, Quantity FROM Sales;

-- Verify reconstructed sales rows (lossless join check)
SELECT O.OrderID, C.CustomerName, P.ProductName, D.Quantity, P.Price
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN OrderDetails D ON O.OrderID = D.OrderID
JOIN Products P ON D.ProductID = P.ProductID
ORDER BY O.OrderID, D.ProductID;

-- Verify table definitions
SHOW CREATE TABLE Customers;
SHOW CREATE TABLE Orders;
SHOW CREATE TABLE Products;
SHOW CREATE TABLE OrderDetails;

-- Dependency-preservation checks
SELECT O.OrderID, O.CustomerID, C.CustomerName
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID;

SELECT D.ProductID, P.ProductName, P.Price
FROM OrderDetails D
JOIN Products P ON D.ProductID = P.ProductID;
 