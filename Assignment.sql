-- Creating Database
create database ECommerceDB;
use EcommerceDB;

-- Creating tables of categories, customers, orders, products
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    CategoryID INT,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
CustomerName Varchar(100) NOT NULL,
Email Varchar(100) unique,
JoinDate date
);

CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
CustomerID INT,
OrderDate Date NOT NULL,
TotalAmount Decimal(10,2),
FOREIGN KEY(CustomerID) References Customers(CustomerID)
);

-- Inserting records in each tables
Insert into categories (CategoryID, CategoryName) 
value (1, "Electronics"),
 (2, "Books"),
 (3, "Home Goods"), 
( 4, "Apparel");

Select * from categories;

Insert into products (ProductID, ProductName, CategoryID, Price , StockQuantity)
values (101, "Laptop Pro", 1, 1200.00, 50),
(102, "SQL handbook", 2, 45.50, 200), 
(103, "Smart Speaker", 1, 99.99, 150),
(104, "Coffee Maker", 3, 75.00, 80),
(105, "Novel : TheGreat SQL", 2, 25.00, 120),
(106, "Wireless Earbuds", 1, 150.00, 100),
(107, "Blender X", 3, 120.00, 60),
(108, "T-Shirt Casual ", 4, 20.00, 300);

select * from products;

INSERT INTO Customers (CustomerID, CustomerName, Email, JoinDate)
VALUES
(1, 'Alice Wonderland', 'alice@example.com', '2023-01-10'),
(2, 'Bob the Builder', 'bob@example.com', '2022-11-25'),
(3, 'Charlie Chaplin', 'charlie@example.com', '2023-03-01'),
(4, 'Diana Prince', 'diana@example.com', '2021-04-26');

select * from customers;

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
(1001, 1, '2023-04-26', 1245.50),
(1002, 2, '2023-10-12', 99.99),
(1003, 1, '2023-07-12', 145.00),
(1004, 3, '2023-01-14', 150.00),
(1005, 2, '2023-09-24', 120.00),
(1006, 1, '2023-06-19', 20.00);

select * from orders;

/* Generate a report showing CustomerName, Email, and the TotalNumberofOrders
 for each customer. Include customers who have not placed any orders, in which 
ase their TotalNumberofOrders should be 0. Order the results by CustomerName.*/

SELECT 
    Customers.CustomerName,
    Customers.Email,
    COUNT(Orders.OrderID) AS TotalNumberOfOrders
FROM Customers
LEFT JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.CustomerName, Customers.Email
ORDER BY Customers.CustomerName;

/*Retrieve Product Information with Category: Write a SQL query to
display the ProductName, Price, StockQuantity, and CategoryName for all
products. Order the results by CategoryName and then ProductName alphabetically*/
SELECT 
    Products.ProductName,
    Products.Price,
    Products.StockQuantity,
    Categories.CategoryName
FROM Products
JOIN Categories
ON Products.CategoryID = Categories.CategoryID
ORDER BY Categories.CategoryName, Products.ProductName;

/* Write a SQL query that uses a Common Table Expression (CTE) and a
Window Function (specifically ROW_NUMBER() or RANK()) to display the
CategoryName, ProductName, and Price for the top 2 most expensive products in
each CategoryName.*/

WITH RankedProducts AS (
    SELECT 
        Categories.CategoryName,
        Products.ProductName,
        Products.Price,
        ROW_NUMBER() OVER (
            PARTITION BY Categories.CategoryName 
            ORDER BY Products.Price DESC
        ) AS RankNumber
    FROM Products
    JOIN Categories
    ON Products.CategoryID = Categories.CategoryID
)

SELECT 
    CategoryName,
    ProductName,
    Price
FROM RankedProducts
WHERE RankNumber <= 2;


-- for answer 10 

use  Sakila;

-- Top 5 Customers Based on Total Amount Spent
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    c.email,
    SUM(p.amount) AS TotalAmountSpent
FROM customer c
JOIN payment p 
ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY TotalAmountSpent DESC
LIMIT 5;

-- Top 3 Movie Categories with Highest Rental Counts
SELECT 
    cat.name AS CategoryName,
    COUNT(r.rental_id) AS RentalCount
FROM rental r
JOIN inventory i 
ON r.inventory_id = i.inventory_id
JOIN film_category fc 
ON i.film_id = fc.film_id
JOIN category cat 
ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY RentalCount DESC
LIMIT 3;

-- Films Available at Each Store and Films Never Rented
SELECT 
    s.store_id,
    COUNT(i.inventory_id) AS TotalFilms,
    SUM(CASE WHEN r.rental_id IS NULL THEN 1 ELSE 0 END) AS NeverRentedFilms
FROM store s
JOIN inventory i 
ON s.store_id = i.store_id
LEFT JOIN rental r 
ON i.inventory_id = r.inventory_id
GROUP BY s.store_id;

-- Customers Who Rented More Than 10 Times in the Last 6 Months

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    c.email,
    COUNT(r.rental_id) AS TotalRentals
FROM customer c
JOIN rental r 
ON c.customer_id = r.customer_id
WHERE r.rental_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING COUNT(r.rental_id) > 10;









