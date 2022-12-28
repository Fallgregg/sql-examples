-- 3.	Використавши SELECT та не використовуючи FROM вивести на екран назву виконавця та пісні, яку ви слухали останньою. Імена колонок вказати як Artist та Title. 
SELECT 'Guns`n`Roses' AS Artist, 'November Rain' AS Title;

-- 4.	Вивести вміст таблиці Order Details, замінивши назви атрибутів OrderID та ProductID на OrderNumber та ProductNumber.
SELECT OrderID AS OrderNumber, ProductID AS ProductNumber, UnitPrice, Quantity, Discount FROM `Order Details`;

-- 5.	З таблиці співробітників вивести всіх співробітників, що мають заробітну платню більше 2000.00, проте меншу за 3000.00. Результат відобразити у вигляді двох колонок, де перша – це конкатенація звернення (TitleOfCourtesy), прізвища та імені. Друга колонка – це заробітна плата відсортована у порядку зростання.
SELECT TitleOfCourtesy || ' ' || LastName ||' ' || FirstName, Salary FROM Employees 
WHERE Salary > 2000.00 AND Salary < 3000.00 
ORDER BY Salary;

-- 6.	Вивести назву всіх продуктів, що продаються у банках (jar), відсортувати за алфавітом.
SELECT * FROM Products 
WHERE QuantityPerUnit LIKE "% jar%" 
ORDER BY ProductName;

-- 7.	Використовуючи базу Northwind вивести всі замовлення, що були здійснені замовниками Island Trading та Queen Cozinha.
SELECT * FROM Orders
WHERE ShipName = "Island Trading" OR ShipName = "Queen Cozinha";

-- 8.	Вивести всі назви та кількість на складі продуктів, що належать до категорій Dairy Products, Grains/Cereals та Meat/Poultry.
SELECT ProductName, UnitsInStock FROM Products
JOIN Categories ON Categories.CategoryID = Products.CategoryID 
WHERE CategoryName IN ("Dairy Products", "Grains/Cereals", "Meat/Poultry");

-- 9.	Вивести всі замовлення, де вартість одиниці товару 50.00 та вище. Відсортувати за номером, позбавитися дублікатів.
SELECT distinct Orders.OrderID FROM Orders
JOIN `Order Details` ON `Order Details`.OrderID = Orders.OrderID
WHERE UnitPrice >= 50.00
ORDER BY OrderID;

-- 10.	Відобразити всіх постачальників, де контактною особою є власник, або менеджер і є продукти, що зараз знаходяться на стадії поставки.
SELECT s.CompanyName FROM Suppliers s
JOIN Products p ON p.SupplierID = s.SupplierID
WHERE p.UnitsOnOrder > 0 AND (s.ContactTitle = "Owner" OR s.ContactTitle LIKE "% Manager");


-- 11.	Вивести всіх замовників з Мексики, де контактною особою є власник, а доставка товарів відбувалася через Federal Shipping.
SELECT Orders.OrderID, Orders.OrderDate, Orders.ShipName, Orders.ShipCountry, Suppliers.ContactTitle, Shippers.CompanyName FROM Orders
JOIN `Order Details` ON `Order Details`.OrderID = Orders.OrderID
JOIN Products ON Products.ProductID = `Order Details`.ProductID
JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID
JOIN Shippers ON Shippers.ShipperID = Orders.ShipVia
WHERE Orders.ShipCountry = "Mexico" AND Suppliers.ContactTitle = "Owner" AND Shippers.CompanyName = "Federal Shipping";
