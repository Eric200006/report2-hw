DROP DATABASE IF EXISTS amazon_db;
CREATE DATABASE amazon_db;
USE amazon_db;

CREATE TABLE Customer (
    CustomerID      VARCHAR(20) PRIMARY KEY,
    Name            VARCHAR(100) NOT NULL,
    Age             INT,
    CustomerAdress  VARCHAR(200),
    Place           VARCHAR(100)
);

CREATE TABLE Category (
    CategoryID   VARCHAR(20) PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

CREATE TABLE Product (
    ProductID    VARCHAR(20) PRIMARY KEY,
    ProductName  VARCHAR(100) NOT NULL,
    Brand        VARCHAR(100),
    Price        DECIMAL(10,2) NOT NULL,
    Stock        INT DEFAULT 0,
    Reviews      DECIMAL(3,2),
    `Condition`  VARCHAR(50),
    CategoryID   VARCHAR(20) NOT NULL,
    CONSTRAINT chk_product_price CHECK (Price >= 0.01),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

CREATE TABLE `Order` (
    OrderID     VARCHAR(20) PRIMARY KEY,
    OrderDate   DATE NOT NULL,
    TotalPrice  DECIMAL(10,2),
    CustomerID  VARCHAR(20) NOT NULL,
    CONSTRAINT chk_order_price CHECK (TotalPrice IS NULL OR TotalPrice >= 0.01),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Weak entity: identified by Order
CREATE TABLE OrderDetails (
    OrderID        VARCHAR(20) NOT NULL,
    OrderDetailsID VARCHAR(20) NOT NULL,
    ProductID      VARCHAR(20) NOT NULL,
    Quantity       INT NOT NULL,
    Price          DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID, OrderDetailsID),
    CONSTRAINT chk_details_price CHECK (Price >= 0.01),
    CONSTRAINT chk_details_qty   CHECK (Quantity >= 1),
    FOREIGN KEY (OrderID)   REFERENCES `Order`(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Pay is 1:1, so OrderID is UNIQUE
CREATE TABLE Payment (
    PaymentID     VARCHAR(20) PRIMARY KEY,
    CustomerID    VARCHAR(20) NOT NULL,
    OrderID       VARCHAR(20) NOT NULL UNIQUE,
    Amount        DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(50),
    PaymentDate   DATE,
    CONSTRAINT chk_payment_amount CHECK (Amount >= 0.01),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (OrderID)    REFERENCES `Order`(OrderID)
);

-- Payment subtypes (total, disjoint specialization)
CREATE TABLE CreditCardPayment (
    PaymentID  VARCHAR(20) PRIMARY KEY,
    CardNumber VARCHAR(20) NOT NULL,
    ExpiryDate DATE NOT NULL,
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID) ON DELETE CASCADE
);

CREATE TABLE GiftCardPayment (
    PaymentID        VARCHAR(20) PRIMARY KEY,
    GiftCardCode     VARCHAR(30) NOT NULL,
    RemainingBalance DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID) ON DELETE CASCADE
);

CREATE TABLE PaypalPayment (
    PaymentID     VARCHAR(20) PRIMARY KEY,
    TransactionID VARCHAR(30) NOT NULL,
    LinkedEmail   VARCHAR(100) NOT NULL,
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID) ON DELETE CASCADE
);

SHOW TABLES;

