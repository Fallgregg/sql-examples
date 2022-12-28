-- Завдання:
-- Використовуючи MySQL в AWS, щ обуло створено під час попередньої лабораторної роботи, або створивши новий екземпляр замість видаленого:
-- 1.	Знайти всіх співробітників, що ніколи не надавали знижок. Навіть якщо такі на даний момент відсутні.
SELECT e.EmployeeID, e.FirstName, e.LastName
FROM
    `Order Details ` od
    JOIN Orders o
ON o.OrderID = od.OrderID
    JOIN Employees e ON e.EmployeeID = o.EmployeeID
WHERE od.Discount = 0
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

-- 2.	Показати всі персональні дані з бази Northwind: повне ім’я, країну, місто, адресу, телефон. Звернути увагу, що ця інформація присутня в різних таблицях. 
SELECT ContactName, Address, City, Country, Phone
FROM Customers
UNION ALL
SELECT CONCAT(LastName, ' ', FirstName) AS `Full Name`, Address, City, Country, NULL AS Phone
FROM Employees
UNION ALL
SELECT CompanyName, Address, City, Country, Phone
FROM Suppliers;

-- 3.	Відобразити список всіх країн та міст, куди компанія робила відправлення. Позбавитися порожніх значень на дублікатів.
SELECT ShipCity, ShipCountry
FROM Orders
WHERE ShipCity IS NOT NULL
  AND ShipCountry IS NOT NULL
GROUP BY ShipCity, ShipCountry;

-- 4.	Використовуючи базу Northwind вивести в алфавітному порядку назви продуктів та їх сумарну кількість в замовленнях.
SELECT p.ProductName, SUM(od.Quantity)
FROM 
`Order Details ` od
    JOIN Products p
ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY p.ProductName;

-- 5.	Вивести імена всіх постачальників та сумарну вартість їх товарів, що зараз знаходяться на складі Northwind за умови, що ця сума більше $1000.
WITH TotalCost AS (SELECT SupplierID, (UnitPrice * UnitsInStock) AS Cost FROM Products p WHERE UnitsInStock != 0)
SELECT tc.SupplierID, SUM(Cost) AS SumCost
FROM TotalCost tc
         JOIN Suppliers s ON s.SupplierID = tc.SupplierID
group by p.SupplierID
HAVING SumCost > 1000;

-- 6.	Знайти кількість замовлень, де фігурують товари з категорії «Сири». Результат має містити дві колонки: опис категорії та кількість замовлень.
SELECT c.Description, COUNT(*) AS `Number of orders`
FROM Orders o
         JOIN `
Order Details ` od
ON od.OrderID = o.OrderID
    JOIN Products p ON p.ProductID = od.ProductID
    JOIN Categories c ON c.CategoryID = p.CategoryID
WHERE c.Description = "Cheeses";

-- 7.	Відобразити всі імена компаній-замовників та загальну суму всіх їх замовлень, враховуючи кількість товару та знижки. Показати навіть ті компанії, у яких замовлення відсутні. Позбавитися від відсутніх значень замінивши їх на нуль. Округлити числові результати до двох знаків після коми, відсортувати за алфавітом.
WITH TotalCost AS (SELECT OrderID, ((UnitPrice * ((100 - Discount) / 100)) * Quantity) AS Cost
                   FROM `Order Details ` od)
SELECT c.CustomerID, c.CompanyName, IFNULL(ROUND(SUM(Cost), 2), 0) AS Cost
FROM Customers c
         RIGHT JOIN Orders o ON o.CustomerID = c.CustomerID
         JOIN TotalCost tc ON tc.OrderID = o.OrderID
GROUP BY c.CustomerID
ORDER BY c.CustomerID;

-- 8.	Вивести три колонки: співробітника (прізвище та ім’я, включаючи офіційне звернення), компанію, з якою співробітник найбільше працював згідно величини товарообігу (максимальна сума по усім замовленням в розрізі компанії), та ім’я представника компанії, додавши до останнього через кому посаду. Цікавить інформація тільки за 1998 рік.
WITH TotalCost AS (SELECT OrderID, (UnitPrice * Quantity) AS Cost FROM ` Order Details ` od),
     CostByCompany AS (
         SELECT EmployeeID, c.CompanyName, c.ContactName, SUM(tc.Cost) AS Cost
         FROM Customers c
                  JOIN Orders o ON o.CustomerID = c.CustomerID
                  JOIN TotalCost tc ON tc.OrderID = o.OrderID
         WHERE year(o.OrderDate) = 1998
         GROUP BY EmployeeID, c.CustomerID
     ),
     MaxCostByEmployee AS (
         SELECT e.EmployeeID, MAX(cbc.Cost) AS MaxCost
         FROM Employees e
                  JOIN CostByCompany cbc ON cbc.EmployeeID = e.EmployeeID
         GROUP BY e.EmployeeID
     )
SELECT CONCAT(e.TitleOfCourtesy, " ", e.LastName, " ", e.firstName) AS Employee,
       cbc.CompanyName,
       cbc.ContactName,
       cbc.Cost
FROM Employees e
         JOIN MaxCostByEmployee mcbe ON mcbe.EmployeeID = e.EmployeeID
         JOIN CostByCompany cbc ON cbc.EmployeeID = e.EmployeeID AND cbc.Cost = mcbe.MaxCost;


-- 9.	Вивести три колонки та три рядки. Колонки: Description, Key, Value. Рядки: 
ShippedDate, дата з максимальною кількістю відправлених замовлень, кількість відправлених замовлень на цю дату; 
Customer, замовник з максимальною кількістю відправлених замовлень, загальна кількість відправлених замовлень цьому замовнику; 
Shipper, перевізник з максимальною кількістю оброблених замовлень, загальна кількість відправлених через цього перевізника.
WITH NumberOfOrders AS (SELECT OrderDate, COUNT(OrderID) AS NumberOfOrders FROM Orders GROUP BY OrderDate),
     MaxNumberOfOrders AS (SELECT MAX(NumberOfOrders) AS MaxNum FROM NumberOfOrders),
     NumberOfOrders_2 AS (SELECT CustomerID, COUNT(OrderID) AS NumberOfOrders_2 FROM Orders GROUP BY CustomerID),
     MaxNumberOfOrders_2 AS (SELECT MAX(NumberOfOrders_2) AS MaxNum_2 FROM NumberOfOrders_2),
     NumberOfOrders_3 AS (SELECT ShipVia, COUNT(OrderID) AS NumberOfOrders_3 FROM Orders GROUP BY ShipVia),
     MaxNumberOfOrders_3 AS (SELECT MAX(NumberOfOrders_3) AS MaxNum_3 FROM NumberOfOrders_3)
SELECT "Shipped Date" AS `Description`, OrderDate AS `Key`, NumberOfOrders AS `Value`
FROM NumberOfOrders
WHERE NumberOfOrders = (SELECT MaxNum FROM MaxNumberOfOrders)
UNION ALL
SELECT "Customer", c.CompanyName, NumberOfOrders_2
FROM NumberOfOrders_2 nod_2
         JOIN Customers c ON c.CustomerID = nod_2.CustomerID
WHERE NumberOfOrders_2 = (SELECT MaxNum_2 FROM MaxNumberOfOrders_2)
UNION ALL
SELECT "Shippers", sh.CompanyName, NumberOfOrders_3
FROM NumberOfOrders_3 nod_3
         JOIN Shippers sh ON sh.ShipperID = nod_3.ShipVia
WHERE NumberOfOrders_3 = (SELECT MaxNum_3 FROM MaxNumberOfOrders_3);


-- 10.	Вивести найбільш популярній товари в розрізі країни. Показати: назву країни, назву продукту, загальну вартість поставок за весь час. Не використовувати функцій ранкування та партиціонування.                                                                                                                                                                                                                                                                                                               
WITH TotalCost AS (SELECT o.ShipCountry,
                          od.ProductID,
                          ((od.UnitPrice * ((100 - od.Discount) / 100)) * od.Quantity) AS Cost
                   FROM `Order Details ` od
                       JOIN Orders o
                   ON o.OrderID = od.OrderID),
     SumTotalCost AS (SELECT TotalCost.ShipCountry, Products.ProductID, Products.ProductName, SUM(Cost) AS SumCost
                      FROM TotalCost
                               JOIN Products ON Products.ProductID = TotalCost.ProductID
                      GROUP BY TotalCost.ShipCountry, Products.ProductID),
     MaxTotalCost AS (SELECT ShipCountry, MAX(SumCost) AS MaxSumCost
                      FROM SumTotalCost
                      GROUP BY ShipCountry)
SELECT MaxTotalCost.ShipCountry, ProductName, SumCost
FROM SumTotalCost
         JOIN MaxTotalCost ON MaxTotalCost.ShipCountry = SumTotalCost.ShipCountry
    AND MaxTotalCost.MaxSumCost = SumTotalCost.SumCost;
