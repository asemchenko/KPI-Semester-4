use northwind;
# 1. Вивести за допомогою команди SELECT своє прізвище, ім’я та по-батькові на екран.
SELECT 'Andrii' AS "First Name",
       'Semchenko' AS "Surname",
       'Olegovich' AS "Patronymic";
#2. Вибрати всі дані з таблиці Products.
SELECT * FROM Products;
#3. Обрати всі назви продуктів з тієї ж таблиці, продаж яких припинено.
SELECT ProductName
FROM Products
WHERE Discontinued=TRUE;
#4. Вивести всі міста клієнтів уникаючи дублікатів.
SELECT DISTINCT City
FROM Customers
WHERE City IS NOT NULL;
#5. Вибрати всі назви компаній-постачальників в порядку зворотньому алфавітному.
SELECT CompanyName
FROM Shippers
ORDER BY CompanyName DESC;
#6. Отримати всі деталі замовлень, замінивши назви стовбчиків на їх порядковий номер.
SELECT OrderID AS "1",
       ProductID AS "2",
       UnitPrice AS "3",
       Quantity AS "4",
       Discount AS "5"
FROM `Order Details`;
#7. Вивести всі контактні імена клієнтів, що починаються з першої літери вашого прізвища, імені, по-батькові.
SELECT ContactName
FROM Customers
WHERE ContactName LIKE 'A%'
OR ContactName LIKE 'S%'
OR ContactName LIKE 'O%';
#8. Показати усі замовлення, в адресах доставки яких є пробіл.
SELECT *
FROM Orders
WHERE ShipAddress LIKE '% %';
#9. Вивести назви тих продуктів, що починаються на знак % або _, а закінчуються на останню літеру вашого імені.
SELECT ProductName
FROM Products
WHERE ProductName LIKE '\%%i'
OR ProductName LIKE '\_%i';