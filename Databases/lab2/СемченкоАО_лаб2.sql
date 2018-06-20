# lab02 Andrii Semchenko
# Task 1
# =============================================================================
# 1. Необхідно знайти кількість рядків в таблиці, що містить більше ніж 2147483647 записів.
  # MS SQL
  SELECT BIG_COUNT(*) FROM db.table;
  # MariaDB
  SELECT COUNT(*) FROM northwind.Products;
# 2. Підрахувати довжину свого прізвища за допомогою SQL.
SELECT LENGTH('Semchenko');
# 3. У рядку з своїм прізвищем, іменем, та по-батькові замінити пробіли на знак ‘_’ (нижнє підкреслення).
SELECT REPLACE('Semchenko Andrii Olegovich', ' ', '_') AS 'RESULT';
# 4. Створити генератор імені електронної поштової скриньки, що шляхом
  # конкатенації об’єднував би дві перші літери з колонки імені, та чотири
  # перші літери з колонки прізвища користувача, що зберігаються в базі
  # даних, а також домену з вашим прізвищем.
SELECT FirstName,
       LastName,
       CONCAT(LEFT(FirstName, 2), LEFT(LastName, 4), '@semchenko.com')
AS 'e-mail'
FROM Persons;
# 5. За допомогою SQL визначити, в який день тиждня ви народилися.
SELECT DAYNAME('1999-08-09') AS 'My birthday day';
# Task 2 MariaDB
# =============================================================================
use northwind;
# 1. Вивести усі данні по продуктам, їх категоріям, та постачальникам, навіть якщо останні з певних причин відсутні.
SELECT * FROM Products
  INNER JOIN Categories ON Products.CategoryID=Categories.CategoryID
  LEFT JOIN Suppliers ON Products.SupplierID=Suppliers.SupplierID;
# 2. Показати усі замовлення, що були зроблені в квітні 1988 року та не були відправлені.
SELECT * FROM Orders
  WHERE MONTH(OrderDate)=4 AND YEAR(OrderDate)=1988 AND
  ShippedDate IS NULL;
# 3. Відібрати усіх працівників, що відповідають за північний регіон.
SELECT Employees.* FROM Employees
  INNER JOIN EmployeeTerritories ON Employees.EmployeeID=EmployeeTerritories.EmployeeID
  INNER JOIN Territories ON Territories.TerritoryID=EmployeeTerritories.TerritoryID
  INNER JOIN Region ON Region.RegionID=Territories.RegionID
  WHERE Region.RegionDescription='Northern';
# 4. Вирахувати загальну вартість з урахуванням знижки усіх замовлень, що були здійснені на непарну дату.
SELECT SUM(`Order Details Extended`.`ExtendedPrice` * (1 - `Order Details Extended`.`Discount`)) AS "SUMMARY"
  FROM `Order Details Extended`
  INNER JOIN Orders ON `Order Details Extended`.OrderID=Orders.OrderID
  WHERE DAY(Orders.OrderDate)%2=1;
# 5. Знайти адресу відправлення замовлення з найбільшою ціною (враховуючи усі позиції замовлення, їх вартість,
  #  кількість, та наявність знижки).
SELECT Orders.ShipAddress FROM Orders
  INNER JOIN `Order Details Extended` ON `Order Details Extended`.OrderID=Orders.OrderID
  ORDER BY `Order Details Extended`.ExtendedPrice*(1-`Order Details Extended`.Discount) DESC
  LIMIT 1;
