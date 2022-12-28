-- Завдання:
-- Використовуючи Azure SQL Database* та Azure Data Studio (або SQL Server Management Studio) в контексті бази Northwind:
-- 1.	Проаналізувати що виконує наступний запит і переписати його зрозумілим чином:
SELECT *
FROM Orders
WHERE ShippedDate IS NOT NULL;

-- 2.	Модифікувати запит зменшивши кількість операцій на кожному рядку до однієї:
UPDATE Products SET Discontinued = ~Discontinued;

-- 3.	Перепишіть запит таким чином, щоб зменшити кількість прочитаних рядків до одного:
SELECT *
FROM Employees
WHERE EmployeeID = 7;

-- 4.	Оптимізувати запит, знаючи, що менша кількість рядків в JOIN покращить результат:
WITH
OrdersByCompany
AS
(
SELECT CustomerID, MAX(OrderDate) AS LastOrderDate
FROM Orders
GROUP BY CustomerID
)
SELECT CompanyName, LastOrderDate
FROM Customers c
    JOIN OrdersByCompany obc ON c.CustomerID = obc.CustomerID;

-- 5.	Зменшити кількість виразів SELECT до одного:
INSERT INTO [Order Details]
(OrderID,ProductID, UnitPrice, Quantity, Discount)
SELECT 11077, ProductID, UnitPrice, UnitsInStock, 0
FROM Products
WHERE ProductName = 'Carnarvon Tigers';

-- 6.	Позбавитися повторного читання рядків під час виконання наступного запиту:
UPDATE Products SET UnitPrice = ROUND(UnitPrice * 1.05, 2)
WHERE UnitPrice > 5;

-- 7.	Після видалення декількох рядків з таблиці запит перестав працювати, необхідно його виправити:
SELECT *
FROM [Order Details]
WHERE ProductID = (SELECT MAX(ProductID)
FROM Products);

-- 8.	Пришвидшити виконання:
SELECT *
FROM [Order Details] OD
JOIN Products P ON OD.ProductID = P.ProductID AND OD.UnitPrice != P.UnitPrice;

-- 9.	Знайти спосіб використати індекс:
CREATE UNIQUE NONCLUSTERED INDEX ProductName ON Products(ProductName);

-- 10.	Оптимізувати швидкодію зберігши результат виконання команди INSERT:
CREATE OR ALTER TRIGGER TR_OrderInsert ON [Order Details]
INSTEAD OF INSERT
AS
SET NOCOUNT ON
INSERT INTO [Order Details]
(OrderID, ProductID, UnitPrice, Quantity, Discount)
SELECT OrderID, ProductID, UnitPrice, Quantity, Discount FROM INSERTED;

