# Andrii Semchenko IP-63
# MariaDB
USE northwind;
# 1. Додати себе як співробітника компанії на позицію Intern.
INSERT INTO Employees (`FirstName`, `LastName`, `City`, `Country`, `BirthDate`, `Notes`, `Title`) VALUE
  ('Andrii', 'Semchenko', 'Kiev', 'Ukraine', '1999.08.09', 'Boss)', 'Intern');
# 2. Змінити свою посаду на Director
UPDATE Employees
SET `Title` = "Director"
WHERE EmployeeID = 10;
# 3. Скопіювати таблицю Orders в таблицю OrdersArchive
CREATE TABLE OrdersArchive AS
  SELECT *
  FROM Orders;
# 4. Очистити таблицю OrdersArchive.
TRUNCATE OrdersArchive;
# 5. Не видаляючи таблицю OrdersArchive, наповнити її інформацією повторно.
INSERT INTO OrdersArchive SELECT *
                          FROM Orders;
# 6. З таблиці OrdersArchive видалити усі замовлення, що були зроблені
# замовниками із Берліну.
DELETE FROM OrdersArchive
WHERE ShipCity = "Berlin";
# 7. Внести в базу два продукти з власним іменем та іменем групи.
INSERT INTO Products (`ProductName`, `UnitPrice`) VALUES ("Andrii", 100500), ("IP-63", 100500);
# 8. Помітити продукти, що не фігурують в замовленнях, як такі, що більше не
# виробляються.
UPDATE Products
SET Discontinued = b'1'
WHERE ProductID NOT IN (SELECT ProductID
                        FROM `Order Details`);
# 9. Видалити таблицю OrdersArchive.
DROP TABLE OrdersArchive;
# 10. Видатили базу Northwind.
DROP DATABASE northwind;
