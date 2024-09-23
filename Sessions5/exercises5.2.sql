CREATE DATABASE exercises5_2;
USE exercises5_2;

CREATE TABLE account(
	id INT PRIMARY KEY AUTO_INCREMENT,
    userName VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    status BIT
);

CREATE TABLE bill(
	id INT PRIMARY KEY AUTO_INCREMENT,
    billType BIT,
    accId INT,
    FOREIGN KEY(accId) REFERENCES account(id),
    created DATETIME,
    authDate DATETIME
);

CREATE TABLE billDetail(
	id INT PRIMARY KEY AUTO_INCREMENT,
    billId INT,
    FOREIGN KEY(billId) REFERENCES bill(id),
    productId INT,
    FOREIGN KEY(productId) REFERENCES product(id),
    quantity INT,
    price DOUBLE
);

CREATE TABLE product(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created DATE,
    price DOUBLE,
    stock INT,
    status BIT
);

INSERT INTO account(userName, password, address, status)
VALUES ('Hùng','123456','Nghệ An',TRUE),('Cường','654321','Hà Nội',TRUE),('Bách','135790','Hà Nội',TRUE);

INSERT INTO bill(billType,accId,created,authDate)
VALUES (0,1,'2022-02-11','2022-03-12'),(0,1,'2023-05-10','2023-10-10'),(1,2,'2024-05-15','2022-05-20'),(1,3,'2022-02-01','2022-02-10');

INSERT INTO product(name, created, price, stock, status)
VALUES ('Quần Dài','2022-03-12', 1200, 5, TRUE),('Áo Dài','2023-03-15', 1500, 8, TRUE),('Mũ Cối','1999-03-08', 1600, 10, TRUE);

INSERT INTO billDetail(billId,productId,quantity,price)
VALUES (1,1,3,1200),(1,2,4,1500),(2,1,1,1200),(3,2,4,1500),(4,3,7,1600);

SELECT * FROM account
ORDER BY userName DESC;

SELECT * FROM bill
WHERE created BETWEEN '2023-02-11' AND '2023-05-15';

SELECT * FROM billDetail
ORDER BY billId;

SELECT * FROM product
ORDER BY name DESC;

SELECT * FROM product
WHERE stock > 10;

SELECT * FROM product
WHERE status = TRUE;

DELIMITER //
CREATE PROCEDURE GetAccountsWithFiveOrMoreOrders()
BEGIN 
  SELECT a.*
  FROM account a
  JOIN bill b ON a.id = b.accId
  GROUP BY a.id
  HAVING COUNT(b.id) >= 5;
END //

CREATE PROCEDURE GetUnsoldProducts()
BEGIN
    SELECT p.*
    FROM product p
    LEFT JOIN billDetail bd ON p.id = bd.productId
    WHERE bd.productId IS NULL;
END;

CREATE PROCEDURE GetTop2BestSellingProducts()
BEGIN
    SELECT p.id, p.name, SUM(bd.quantity) AS total_sold
    FROM product p
    JOIN billDetail bd ON p.id = bd.productId
    GROUP BY p.id
    ORDER BY total_sold DESC
    LIMIT 2;
END;
CREATE PROCEDURE AddAccount(IN userName VARCHAR(100), IN password VARCHAR(255), IN address VARCHAR(255), IN status BIT)
BEGIN
    INSERT INTO account(userName, password, address, status)
    VALUES (userName, password, address, status);
END;

CREATE PROCEDURE GetBillDetailsByBillId(IN bill_id INT)
BEGIN
    SELECT bd.*
    FROM billDetail bd
    WHERE bd.billId = bill_id;
END;

CREATE PROCEDURE AddBill(IN billType BIT, IN accId INT, IN created DATETIME, IN authDate DATETIME, OUT newBillId INT)
BEGIN
    INSERT INTO bill(billType, accId, created, authDate)
    VALUES (billType, accId, created, authDate);
    
    SET newBillId = LAST_INSERT_ID();
END;

CREATE PROCEDURE GetProductsSoldMoreThan5()
BEGIN
    SELECT p.id, p.name, SUM(bd.quantity) AS total_sold
    FROM product p
    JOIN billDetail bd ON p.id = bd.productId
    GROUP BY p.id
    HAVING total_sold > 5;
END;
