-- Завдання:
-- Використовуючи MySQL в AWS, що було створено під час другої лабораторної роботи, або створивши новий екземпляр замість видаленого*:
-- 1.	Відобразити назву продукту та його вартість. Якщо товар відсутній на складі – відобразити замість вартості N/A.
SELECT ProductName,
       CASE
           WHEN UnitsInStock = 0
               THEN 'N/A'
           ELSE CAST(UnitPrice AS CHAR(6))
           END ProductPrice
FROM `Products`;

-- 2.	У дві колонки вивести співробітників, так їх керівників. Якщо керівник відсутній – повідомити про Self-managed. 
SELECT CONCAT(worker.FirstName, " ", worker.LastName)   AS Worker,
       CONCAT(manager.FirstName, " ", manager.LastName) AS Manager
FROM Employees worker,
     Employees manager
WHERE manager.EmployeeID = worker.ReportsTo
UNION
SELECT CONCAT(FirstName, " ", LastName), IFNULL(ReportsTo, 'Self-managed')
FROM Employees
WHERE ISNULL (ReportsTo);

-- 3.	Вивести номери замовлення та їх регіон відправки. Якщо такий відсутній – країну відправки. Якщо дати відправки немає – відобразити замість регіону фразу Not shipped.
SELECT OrderID,
       CASE
           WHEN ISNULL(ShippedDate) THEN CAST(IFNULL(ShipRegion, 'Not shipped') AS CHAR(15)) 
 ELSE CAST(IFNULL(ShipRegion, Shipcountry) AS CHAR(10))
END ShipRegion FROM Orders;

-- 4.	Повернути з бази даних наступні дані: повне ім’я співробітника (однією колонкою), назву території, за яку він відповідає, до останньої через пробіл додати в дужках індикатор відповідного регіону (Nord, Sud, Est, Ovest). Приклад: Phoenix (Ovest).
SELECT CONCAT(FirstName, " ", LastName) AS Employees,
       CONCAT(RTRIM(t.territorydescription), " ", "(",
              CASE
                  WHEN r.regiondescription = 'Northern' THEN 'Nord'
                  WHEN 'Eastern' THEN 'Est'
                  WHEN 'Westerns' THEN 'Ovest'
                  ELSE 'Sud' END, ")")  AS Territory_Region
FROM Employees e
         JOIN EmployeeTerritories et on et.EmployeeID = e.EmployeeID
         JOIN Territories t ON t.TerritoryID = et.TerritoryID
         JOIN Region r ON t.RegionID = r.RegionID;


-- 5.	Вивести по три найдешевших товару для кожної категорії.
SELECT *
FROM (
         SELECT Products.ProductName,
                Products.UnitPrice,
                Categories.CategoryName,
                RANK() OVER (PARTITION BY Categories.CategoryName ORDER BY UnitPrice ) `Rank`
         FROM Products
                  JOIN Categories ON Products.CategoryID = Categories.CategoryID
         ORDER BY Categories.CategoryName, `Rank`) AS T1
Where `Rank` <= 3;


-- 6.	Вивести наступну інформацію: Країна, Ранг. Відсортувати за рангом. Ранжування провести по загальній вартості товарів відправлених в цю країну.               
SELECT o.ShipCountry,
       SUM(od.UnitPrice * od.Quantity) AS `General price`,
       RANK() OVER (ORDER BY SUM(od.UnitPrice * od.Quantity)) `Rank`
FROM Orders o
         JOIN `Order Details` od
ON od.OrderId=o.orderId
GROUP BY o.ShipCountry;  
               
           
-- 7.	Вивести окремими стовпчиками прізвище та ім’я співробітників Northwind та контактних осіб замовників, що мають посади спільні для обох таблиць. В якості третьої колонки вивести саму посаду.
SELECT Employees.FirstName, Employees.LastName, Employees.title
FROM Employees
WHERE Title IN (SELECT ContactTitle FROM Customers)
UNION
SELECT SUBSTRING_INDEX(Customers.ContactName, " ", 1),
       SUBSTRING_INDEX(Customers.ContactName, " ", -1),
       Customers.ContactTitle
FROM Customers
WHERE ContactTitle IN (SELECT Title FROM Employees);


-- 8.	Вивести прізвище та ім’я співробітника, рік, номер замовлення в базі, та яким за рік стало це замовлення для конкретного співробітника (починаючи нумерацію з одиниці).
SELECT e.LastName,
       e.FirstName,
       o.OrderID,
       o.OrderDate,
       RANK() OVER (PARTITION BY e.LastName, YEAR(o.OrderDate) ORDER BY DATE(o.OrderDate)) AS `Order number` 
       FROM Employees e
JOIN Orders o
ON o.EmployeeId = e.EmployeeId;







9.	Для кожного замовника знайти три замовлення з максимальною різницею між датою замовлення та датою відправлення. 
SELECT *
FROM (SELECT c.ContactName,
             OrderID,
             DATEDIFF(ShippedDate, OrderDate) AS `Max Date Difference`,
             ROW_NUMBER() OVER (PARTITION BY c.ContactName ORDER BY DATEDIFF(ShippedDate, OrderDate) DESC) `Rank`
      FROM Customers c
               JOIN Orders o ON o.CustomerID = c.CustomerID) T1
WHERE `Rank` <= 3;


10.	Для кожного співробітника вивести другий десяток найбільш дорогих замовлень (тобто замовлення, що за загальною вартістю для конкретного співробітника будуть під номерами з 11 по 20).
SELECT *
FROM (SELECT CONCAT(e.FirstName, " ", e.LastName) AS FullName,
             od.UnitPrice,
             ROW_NUMBER() OVER (PARTITION BY e.FirstName ORDER BY od.UnitPrice DESC) PriceRank
      FROM Employees e
               JOIN Orders o ON o.EmployeeID = e.EmployeeID
               JOIN `Order Details` od
      ON od.OrderID = o.OrderID) T1
WHERE PriceRank BETWEEN 11 and 20;


