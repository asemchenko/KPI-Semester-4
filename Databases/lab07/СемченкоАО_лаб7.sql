# Andrii Semchenko IP-63
# MariaDB
use northwind;
# 1. Створити збережену процедуру, що при виклику буде повертати ваше
# прізвище, ім’я та по-батькові.
CREATE OR REPLACE PROCEDURE getFIO()
BEGIN
      SELECT
      'Andrii'    AS `FirstName`,
      'Semchenko' AS `LastName`,
      'Olegovich' AS `Patronimic`;
  END;
CALL getFIO();
# 2. В котексті бази Northwind створити збережену процедуру, що приймає
  # текстовий параметр мінімальної довжини. У разі виклику процедури з
  # параметром ‘F’ на екран виводяться усі співробітники-жінки, у разі
  # використання параметру ‘M’ – чоловікі. У протилежному випадку вивести
  # на екран повідомлення про те, що параметр не розпізнано.
CREATE PROCEDURE getEmployeesBySex(IN sex CHAR(1))
  BEGIN
    IF sex='F' THEN
      SELECT * FROM northwind.Employees WHERE `TitleOfCourtesy`='Ms.' OR `TitleOfCourtesy`='Mrs.' ;
    ELSEIF sex='M' THEN
      SELECT * FROM northwind.Employees WHERE `TitleOfCourtesy`='Mr.';
    ELSE
      SELECT 'Unrecognized parameter' AS `Error message`;
    END IF;
  END;
CALL getEmployeesBySex('M');
CALL getEmployeesBySex('F');
CALL getEmployeesBySex('E');
# 3. В котексті бази Northwind створити збережену процедуру, що виводить усі
  # замовлення за заданий період. В тому разі, якщо період не задано –
  # вивести замовлення за поточний день.
CREATE PROCEDURE getOrdersFromDateInterval(IN minDate DATE, IN maxDate DATE )
  BEGIN
    SELECT * FROM Orders WHERE OrderDate >= minDate AND OrderDate <= maxDate;
  END;
# MariaDB doesn't support default parameters
CALL getOrdersFromDateInterval("1996-01-01","1997-12-31");
# 4. В котексті бази Northwind створити збережену процедуру, що в залежності
  # від переданого параметру категорії виводить категорію та перелік усіх
  # продуктів за цією категорією. Дозволити можливість використати від
  # однієї до п’яти категорій.
CREATE PROCEDURE getProductsByCategory(IN name VARCHAR(50))
  BEGIN
    SELECT Products.* FROM Products INNER JOIN Categories ON Products.CategoryID=Categories.CategoryID WHERE CategoryName=name;
  END;
# 5. В котексті бази Northwind модифікувати збережену процедуру Ten Most
  # Expensive Products для виводу всієї інформації з таблиці продуктів, а також
  # імен постачальників та назви категорій.
CREATE OR REPLACE PROCEDURE ten_most_expensive_products()
  BEGIN
    SELECT
      Products.*,
      Categories.CategoryName,
      Suppliers.CompanyName
    FROM Products
    INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
    INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
    ORDER BY Products.UnitPrice DESC LIMIT 10;
  END;
CALL ten_most_expensive_products();
# 6. В котексті бази Northwind створити функцію, що приймає три параметри
  # (TitleOfCourtesy, FirstName, LastName) та виводить їх єдиним текстом.
  # Приклад: ‘Dr.’, ‘Yevhen’, ‘Nedashkivskyi’ –> ‘Dr. Yevhen Nedashkivskyi’
CREATE OR REPLACE FUNCTION concatText(TitleOfCourtesy VARCHAR(10), FirstName VARCHAR(15), LastName VARCHAR(20))
  RETURNS VARCHAR(70)
  DETERMINISTIC
  BEGIN
    RETURN CONCAT(TitleOfCourtesy,' ', FirstName,' ', LastName);
  END;
SELECT concatText('Dr.', 'Yevhen', 'Nedashkivskyi') AS 'Result';
# 7. В котексті бази Northwind створити функцію, що приймає три параметри
  # (UnitPrice, Quantity, Discount) та виводить кінцеву ціну.
CREATE FUNCTION finalPrice(UnitPrice INT, Quantity DOUBLE, Discount DOUBLE)
  RETURNS DOUBLE
  DETERMINISTIC
BEGIN
    RETURN UnitPrice * (1.0 - Discount) * Quantity;
  END;
SELECT finalPrice(10, 3, 0.1) AS 'Price';
# 8. Створити функцію, що приймає параметр текстового типу і приводить
  # його до Pascal Case. Приклад: Мій маленький поні –> МійМаленькийПоні
CREATE FUNCTION convertToCamelCase(tmp VARCHAR(100))
  RETURNS VARCHAR(100)
  DETERMINISTIC
  BEGIN
    DECLARE offset INT;
    SET tmp = CONCAT(UPPER(SUBSTRING(tmp, 1, 1)), SUBSTRING(tmp, 2));
    WHILE LOCATE(' ', tmp) != 0
      DO
        SET offset = LOCATE(' ', tmp);
        SET tmp = REPLACE(tmp, SUBSTRING(tmp, offset, 2), UPPER(SUBSTRING(tmp, offset + 1, 1)));
      END WHILE;
    RETURN tmp;
  END;
SELECT convertToCamelCase('olo lo lo') AS 'Result';
# 9. В контексті бази Northwind створити функцію, що в залежності від вказаної
  # країни, повертає усі дані про співробітника у вигляді таблиці.
CREATE OR REPLACE PROCEDURE getEmployessFromCountry(IN countryName VARCHAR(50))
  BEGIN
    SELECT * FROM Employees WHERE Country = countryName;
  END;
# 10.В котексті бази Northwind створити функцію, що в залежності від імені
  # транспортної компанії повертає список клієнтів, якою вони обслуговуються.
CREATE PROCEDURE getClients(IN companyName VARCHAR(50))
  BEGIN
    SELECT Customers.ContactName FROM Customers WHERE  Customers.CompanyName = companyName;
  END;

