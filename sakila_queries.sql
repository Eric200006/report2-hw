USE sakila_mini;

-- 1-2: contents of each table
SELECT * FROM film;
SELECT * FROM store;
SELECT * FROM staff;
SELECT * FROM customer;
SELECT * FROM rental;
SELECT * FROM payment;

-- 2-1
SELECT film_id, title, length
FROM film
WHERE length > 120
LIMIT 10;

-- 2-2
SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) AS number_of_rents
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(*) > 5
LIMIT 10;

-- 2-2 sanity check (optional)
SELECT customer_id, COUNT(*) AS number_of_rents
FROM rental
GROUP BY customer_id
ORDER BY number_of_rents DESC
LIMIT 10;

-- 2-3
SELECT f.film_id, f.title, COUNT(*) AS times_rented
FROM film f
JOIN rental r ON f.film_id = r.film_id
GROUP BY f.film_id, f.title
ORDER BY times_rented DESC
LIMIT 3;
-- Optional tie-breaker: ORDER BY times_rented DESC, f.film_id

-- 2-4
SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate > 3.99
LIMIT 10;

-- 2-5
SELECT customer_id, first_name, last_name, city
FROM customer
WHERE first_name LIKE 'A%'
LIMIT 10;

-- 2-6
SELECT film_id, title, release_year, length
FROM film
ORDER BY length DESC
LIMIT 10;

-- 2-7
SELECT MAX(length) AS max_length, MIN(length) AS min_length
FROM film;

-- 2-8
SELECT category, COUNT(*) AS film_count
FROM film
GROUP BY category
LIMIT 10;

-- 2-9
SELECT film_id, title, category
FROM film
LIMIT 10;

-- 2-10 (extra)
SELECT r.rental_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
       r.rental_date
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
LIMIT 10;

-- 2-11 (extra), Option 1: LEFT JOIN
SELECT f.film_id, f.title
FROM film f
LEFT JOIN rental r ON f.film_id = r.film_id
WHERE r.rental_id IS NULL
LIMIT 10;

-- 2-11 (extra), Option 2: NOT IN
SELECT film_id, title
FROM film
WHERE film_id NOT IN (SELECT film_id FROM rental)
LIMIT 10;

-- 3-1
CREATE OR REPLACE VIEW store_revenue AS
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

SELECT * FROM store_revenue;


-- 3-2
DROP FUNCTION IF EXISTS calculate_late_fee;

DELIMITER $$

CREATE FUNCTION calculate_late_fee(days_late INT, daily_fee DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN GREATEST(days_late, 0) * daily_fee;
END$$

DELIMITER ;

SELECT calculate_late_fee(5, 1.50) AS total_late_fee;

USE amazon_db;

-- 5-1
INSERT INTO Customer (CustomerID, Name, Age, CustomerAdress, Place)
VALUES
('C001', 'John Smith', 25, '123 Main St', 'Miami'),
('C002', 'Maria Garcia', 30, '456 Oak Ave', 'Orlando'),
('C003', 'David Lee', 22, '789 Pine Rd', 'Tampa'),
('C004', 'Sarah Johnson', 35, '321 Elm St', 'Boca Raton'),
('C005', 'Michael Brown', 28, '654 Palm Dr', 'Jacksonville');

INSERT INTO Category (CategoryID, CategoryName)
VALUES
('CAT01', 'Electronics'),
('CAT02', 'Clothing'),
('CAT03', 'Books'),
('CAT04', 'Home'),
('CAT05', 'Sports');

INSERT INTO Product (ProductID, ProductName, Brand, Price, Stock, Reviews, `Condition`, CategoryID)
VALUES
('P001', 'Wireless Mouse', 'Logitech', 25.99, 50, 4.50, 'New', 'CAT01'),
('P002', 'Running Shoes', 'Nike', 89.99, 30, 4.70, 'New', 'CAT05'),
('P003', 'Python Programming', 'OReilly', 45.00, 20, 4.80, 'New', 'CAT03'),
('P004', 'Cotton T-Shirt', 'Adidas', 19.99, 100, 4.20, 'New', 'CAT02'),
('P005', 'Desk Lamp', 'Philips', 34.99, 40, 4.30, 'New', 'CAT04');

INSERT INTO `Order` (OrderID, OrderDate, TotalPrice, CustomerID)
VALUES
('O001', '2026-10-01', 25.99, 'C001'),
('O002', '2026-10-02', 89.99, 'C002'),
('O003', '2026-10-03', 45.00, 'C003'),
('O004', '2026-10-04', 19.99, 'C004'),
('O005', '2026-10-05', 34.99, 'C005');

INSERT INTO OrderDetails (OrderID, OrderDetailsID, ProductID, Quantity, Price)
VALUES
('O001', 'OD001', 'P001', 1, 25.99),
('O002', 'OD002', 'P002', 1, 89.99),
('O003', 'OD003', 'P003', 1, 45.00),
('O004', 'OD004', 'P004', 1, 19.99),
('O005', 'OD005', 'P005', 1, 34.99);

-- 5-1 verify
SELECT * FROM Customer;
SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM `Order`;
SELECT * FROM OrderDetails;

-- 5-2-1
SELECT c.Name, o.OrderID, o.OrderDate, o.TotalPrice
FROM Customer c, `Order` o
WHERE c.CustomerID = o.CustomerID;

-- 5-2-2
SELECT od.OrderID, p.ProductName, od.Quantity, od.Price
FROM OrderDetails od, Product p
WHERE od.ProductID = p.ProductID;

-- 5-2-3
WITH ExpensiveProducts AS (
    SELECT ProductName, Brand, Price
    FROM Product
    WHERE Price > 30
)
SELECT * FROM ExpensiveProducts;

-- 5-2-4
WITH LargeOrders AS (
    SELECT CustomerID, OrderID, TotalPrice
    FROM `Order`
    WHERE TotalPrice > 40
)
SELECT c.Name, l.OrderID, l.TotalPrice
FROM LargeOrders l
JOIN Customer c ON l.CustomerID = c.CustomerID;

-- 5-2-5
SELECT c.CategoryName, SUM(p.Price * p.Stock) AS TotalInventoryValue
FROM Category c
JOIN Product p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

-- 5-2-6
SELECT c.Name, COUNT(o.OrderID) AS TotalOrders
FROM Customer c
JOIN `Order` o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name;

-- 5-2-7
SELECT ProductName, Price
FROM Product
WHERE Price > (SELECT AVG(Price) FROM Product);

-- 5-2-8
SELECT CustomerID, Name
FROM Customer
WHERE CustomerID IN (SELECT CustomerID FROM `Order`);

-- 5-3-1
SET SQL_SAFE_UPDATES = 0;

UPDATE Product
SET Price = ROUND(Price * 1.10, 2)
WHERE Price > 30;

SET SQL_SAFE_UPDATES = 1;

SELECT ProductID, ProductName, Price
FROM Product;

-- 5-3-2
SET SQL_SAFE_UPDATES = 0;

UPDATE Product
SET Stock = Stock + 15
WHERE Stock < 40;

SET SQL_SAFE_UPDATES = 1;

SELECT ProductID, ProductName, Stock
FROM Product;

-- 5-4-1
SELECT p.ProductName, p.Brand, c.CategoryName, p.Price
FROM Product p
JOIN Category c ON p.CategoryID = c.CategoryID
ORDER BY p.ProductName;

-- 5-4-2
SELECT c.Name, o.OrderID, o.OrderDate, o.TotalPrice
FROM Customer c
JOIN `Order` o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate DESC;

-- 5-4-3
SELECT ProductID, ProductName, Stock
FROM Product
WHERE Stock < 50
ORDER BY Stock ASC;

-- 5-4-4
SELECT SUM(TotalPrice) AS TotalSalesRevenue
FROM `Order`;