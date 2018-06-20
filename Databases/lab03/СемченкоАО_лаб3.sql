# Semchenko Andrii IP-63
# MariaDB

# ================= Task 1 =================

# 1.Використовуючи SELECT двічі, виведіть на екран своє ім’я, прізвище та
# по-батькові одним результуючим набором.
SELECT "Semchenko" AS "Name"
UNION
SELECT "Andrii Olegovich";
# 2.Порівнявши власний порядковий номер в групі з набором із всіх номерів в
# групі, вивести на екран ;-) якщо він менший за усі з них, або :-D в
# протилежному випадку.
SELECT CASE
       WHEN 21 < ALL (SELECT StudentOrderID
                      FROM Students)
         THEN ";-)"
       ELSE ":-D"
       END;
# 3. Не використовуючи таблиці, вивести на екран прізвище та ім’я усіх дівчат
# своєї групи за вийнятком тих, хто має спільне ім’я з студентками іншої
# групи.
SELECT
  MyGroupStudents.FirstName,
  MyGroupStudents.LastName
FROM
  (
    SELECT
      "Ludmila"  AS "FirstName",
      "Koroleva" AS "LastName"
    UNION
    SELECT
      "Victoria" AS "FirstName",
      "Bondar"   AS "LastName"
    UNION
    SELECT
      "Vera"   AS "FirstName",
      "Popova" AS "LastName"
  ) AS MyGroupStudents
  LEFT JOIN
  (
    SELECT
      "Vera"    AS "FirstName",
      "Bridnya" AS "LastName"
    UNION
    SELECT
      "Vladislava" AS "FirstName",
      "Lipska"     AS "LastName"
  ) AS OtherGroupStudents
    ON MyGroupStudents.FirstName=OtherGroupStudents.FirstName;
#4. Вивести усі рядки з таблиці Numbers (Number INT). Замінити цифру від 0 до
  # 9 на її назву літерами. Якщо цифра більше, або менша за названі,
  # залишити її без змін.
SELECT
    CASE
        WHEN Number = 0 THEN 'zero'
        WHEN Number = 1 THEN 'one'
        WHEN Number = 2 THEN 'two'
        WHEN Number = 3 THEN 'three'
        WHEN Number = 4 THEN 'four'
        WHEN Number = 5 THEN 'five'
        WHEN Number = 6 THEN 'six'
        WHEN Number = 7 THEN 'seven'
        WHEN Number = 8 THEN 'eight'
        WHEN Number = 9 THEN 'nine'
        ELSE Number
    END AS "number"
FROM Numbers;
# 5. Навести приклад синтаксису декартового об’єднання для вашої СУБД.
SELECT
  Employess.FirstName,
  Clients.LastName
FROM Employess
  CROSS JOIN
  Clients;

# ================= Task 2 =================

# 1. Вивисти усі замовлення та їх службу доставки. В залежності від
  # ідентифікатора служби доставки, переіменувати її на таку, що відповідає
  # вашому імені, прізвищу, або по-батькові.
SELECT Orders.*,
  CASE
    WHEN ShipVia = 1 THEN "Andrii"
    WHEN ShipVia = 2 THEN "Semchenko"
    WHEN ShipVia = 3 THEN "Olegovich"
  END AS ShipperName
  FROM Orders;
# 2. Вивести в алфавітному порядку усі країни, що фігурують в адресах
  # клієнтів, працівників, та місцях доставки замовлень.
SELECT DISTINCT * FROM
  (
    SELECT Country
    FROM Employees
  UNION
    SELECT Country
    FROM Customers
  UNION
    SELECT ShipCountry
    FROM Orders
  ) AS Countries
  WHERE Country IS NOT NULL
ORDER BY Country;
# 3. Вивести прізвище та ім’я працівника, а також кількість замовлень, що він
  # обробив за перший квартал 1998 року.
SELECT
  FirstName,
  LastName,
  COUNT(Orders.EmployeeID) AS OrdersCount
FROM Employees
  JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY FirstName, LastName;
# 4. Використовуючи СTE знайти усі замовлення, в які входять продукти, яких
  # на складі більше 100 одиниць, проте по яким немає максимальних знижок.
WITH O AS
(
  SELECT Orders.PrOrdersuctID, Orders.UnitPrice, Orders.Quantity, O.* FROM `Order Details` AS Orders
  JOIN Orders AS Orders ON Orders.OrderID = O.OrderID
  WHERE Discount <> (SELECT MAX(Discount) FROM `Order Details`)
)
SELECT * FROM O
WHERE Quantity > 100;
# 5. Знайти назви усіх продуктів, що не продаються в південному регіоні.
SELECT
  ProductName,
  RegionDescription
FROM Region
  INNER JOIN Territories ON Region.RegionID = Territories.RegionID
  INNER JOIN EmployeeTerritories ON Territories.TerritoryID = EmployeeTerritories.TerritoryID
  INNER JOIN Employees ON EmployeeTerritories.EmployeeID = Employees.EmployeeID
  INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
  INNER JOIN `Order Details` ON Orders.OrderID = `Order Details`.OrderID
  INNER JOIN Products ON `Order Details`.ProductID = Products.ProductID
WHERE RegionDescription <> 'Southern'
GROUP BY ProductName, RegionDescription;