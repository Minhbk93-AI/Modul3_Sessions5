CREATE DATABASE exercises5_1;
USE exercises5_1;

CREATE TABLE products(
  pId INT AUTO_INCREMENT PRIMARY KEY,
  pName VARCHAR(255) NOT NULL,
  pPrice DOUBLE NOT NULL
);
INSERT INTO products(pName, pPrice)
VALUES ('Máy giặt',300),('Tủ lạnh',500),('Điều Hòa',700),('Quat',100),('Bep Điện', 200),('May Hut Mui',500);
SELECT* FROM products;

CREATE TABLE customers(
	cId INT AUTO_INCREMENT PRIMARY KEY,
	cName VARCHAR(255) NOT NULL,
    cAge INT NOT NULL
);
-- INSERT INTO customers(cName, cAge)
-- VALUES ('Minh Quân', 10),('Ngọc Anh',20),('Hồng Hà',50);
-- SELECT* FROM customers
-- INNER JOIN orders ON customers.cId = orders.cId
-- ;
-- SELECT* FROM customers
-- LEFT JOIN orders ON customers.cId = orders.cId
-- WHERE customers.cId IS NULL;
-- ;


CREATE TABLE orders(
	oId INT AUTO_INCREMENT PRIMARY KEY,
    cId INT NOT NULL,
    FOREIGN KEY (cId) REFERENCES customers(cId),
    oDate DATETIME,
    oTotalPrice DOUBLE
);

INSERT INTO orders(cId, oDate, oTotalPrice) 
VALUES (1, '2006-03-21', 150000),(2, '2006-03-26', 200000),(1, '2006-05-21',170000);
SELECT* FROM orders;

CREATE TABLE orderDetail(
  oId INT NOT NULL,
  pId INT NOT NULL,
  FOREIGN KEY (oId) REFERENCES orders(oId),
  FOREIGN KEY (pId) REFERENCES products(pId),
  odQuantity INT
);

INSERT INTO orderDetail(oId, pId, odQuantity)
VALUES (1,1,3),(1,3,7),(1,4,2),( 2,1,1),(3,1,8),(2,5,4),(2,3,3);
SELECT * FROM orderDetail;

--  Hiển thị tất cả customer có đơn hàng trên 150000:
SELECT c.cId, c.cName, c.cAge, o.oTotalPrice
FROM customers c
JOIN orders o ON c.cId = o.cId
WHERE o.oTotalPrice > 150000;

-- Hiển thị sản phẩm chưa được bán cho bất cứ ai:
SELECT* FROM products p
LEFT JOIN orderDetail od 
ON od.pId= p.pId
WHERE od.pId IS NULL;

-- Hiển thị tất cả đơn hàng mua trên 2 sản phẩm:
SELECT o.oId, o.cId, COUNT(od.pId) AS product_count FROM orders o
JOIN orderDetail od ON o.oId=od.oId
GROUP BY o.oId
HAVING product_count >2;

-- Hiển thị đơn hàng có tổng giá tiền lớn nhất:
SELECT o.oId, o.cId, o.oTotalPrice
FROM orders o
ORDER BY o.oTotalPrice DESC
LIMIT 1;

-- Hiển thị người dùng nào mua nhiều sản phẩm “Bep Dien” nhất:
SELECT c.cId, c.cName, SUM(od.odQuantity) AS total_quantity
FROM customers c
JOIN orders o ON c.cId = o.cId
JOIN orderDetail od ON o.oId = od.oId
JOIN products p ON od.pId = p.pId
WHERE p.pName = 'Bep Điện'
GROUP BY c.cId, c.cName
ORDER BY total_quantity DESC
LIMIT 1;

CREATE VIEW view_all_customers AS
SELECT*FROM customers;

CREATE VIEW view_orders_above_150000 AS
SELECT * FROM orders
WHERE oTotalPrice > 150000;

CREATE INDEX idx_cName ON customers(cName);

CREATE INDEX idx_pName ON products(pName);

DELIMITER $$
CREATE PROCEDURE get_order_with_min_total_price()
BEGIN
    SELECT oId, cId, oTotalPrice
    FROM orders
    ORDER BY oTotalPrice ASC
    LIMIT 1;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE get_customer_with_min_may_giat_purchases()
BEGIN
    SELECT c.cId, c.cName, SUM(od.odQuantity) AS total_quantity
    FROM customers c
    JOIN orders o ON c.cId = o.cId
    JOIN orderDetail od ON o.oId = od.oId
    JOIN products p ON od.pId = p.pId
    WHERE p.pName = 'Máy giặt'
    GROUP BY c.cId, c.cName
    ORDER BY total_quantity ASC
    LIMIT 1;
END$$
DELIMITER ;

CALL get_order_with_min_total_price();

CALL get_customer_with_min_may_giat_purchases();



