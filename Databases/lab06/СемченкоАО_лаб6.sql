# Andrii Semchenko IP-63
# MariaDB


# 1. Вивести на екран імена усіх таблиць в базі даних та кількість рядків в них.
USE northwind;
CREATE PROCEDURE tablesLenght()
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tableName VARCHAR(60);
    DECLARE queryString VARCHAR(255);
    DECLARE c CURSOR FOR SELECT `TABLE_NAME`
                         FROM information_schema.TABLES
                         WHERE `TABLE_SCHEMA` = 'northwind';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN c;
    read_loop: LOOP
      FETCH c
      INTO tableName;
      IF done
      THEN
        LEAVE read_loop;
      END IF;
      SET queryString = CONCAT("SELECT ", "'", `tableName`, "'", "AS name, COUNT(*) FROM ", "`", `tableName`, "`");
      EXECUTE IMMEDIATE `queryString`;
    END LOOP;
    CLOSE c;
  END;
CALL tablesLenght();
DROP PROCEDURE tablesLenght;
# 2. Видати дозвіл на читання бази даних Northwind усім користувачам вашої
# СУБД. Код повинен працювати в незалежності від імен існуючих
# користувачів.
CREATE PROCEDURE setSelectPriv()
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE userName VARCHAR(60);
    DECLARE hostName VARCHAR(60);
    DECLARE queryString VARCHAR(255);
    DECLARE c CURSOR FOR SELECT
                           User,
                           Host
                         FROM mysql.user;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN c;
    readLoop: LOOP
      FETCH c
      INTO userName, hostName;
      IF done
      THEN
        LEAVE readLoop;
      END IF;
      SET queryString = CONCAT("GRANT SELECT ON northwind.* TO ", "'", `userName`, "'", "@", "'", `hostName`, "'");
      EXECUTE IMMEDIATE `queryString`;
    END LOOP;
  END;
CALL setSelectPriv();
DROP PROCEDURE setSelectPriv;
# 3. За допомогою курсору заборонити користувачеві TestUser доступ до всіх
# таблиць поточної бази даних, імена котрих починаються на префікс ‘prod_’.
CREATE PROCEDURE revokePriv()
  BEGIN
    DECLARE queryString VARCHAR(255);
    DECLARE tableName VARCHAR(80);
    DECLARE done INT DEFAULT FALSE;
    DECLARE c CURSOR FOR SELECT `TABLE_NAME`
                         FROM information_schema.TABLES
                         WHERE `TABLE_SCHEMA` = 'northwind' AND TABLE_NAME LIKE 'prod_%';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN c;
    readLoop: LOOP
      FETCH c
      INTO tableName;
      IF done
      THEN
        LEAVE readLoop;
      END IF;
      SET queryString = CONCAT("REVOKE ALL PRIVILEGES  ON northwind.`", `tableName`, "` FROM TestUser@localhost");
      EXECUTE IMMEDIATE `queryString`;
    END LOOP;
  END;
CALL revokePriv();
DROP PROCEDURE revokePriv;

# 4. Створити тригер на таблиці Customers, що при вставці нового телефонного
# номеру буде видаляти усі символи крім цифер.
CREATE TRIGGER updatePhoneNumber
  AFTER INSERT
  ON Customers
  FOR EACH ROW
  BEGIN
    IF NEW.Phone IS NOT NULL
    THEN
      UPDATE Phone
      SET NEW.Phone = REGEX_REPLACE(NEW.Phone, "[!0-9]", "");
    END IF;
  END;

# 5. Створити таблицю Contacts (ContactId, LastName, FirstName, PersonalPhone,
# WorkPhone, Email, PreferableNumber). Створити тригер, що при вставці
# даних в таблицю Contacts вставить в якості PreferableNumber WorkPhone
# якщо він присутній, або PersonalPhone, якщо робочий номер телефона не
# вказано.
CREATE TABLE Contacts (
  `ContactID`        INT AUTO_INCREMENT PRIMARY KEY,
  `LastName`         VARCHAR(20),
  `FirstName`        VARCHAR(12),
  `PersonalPhone`    VARCHAR(15),
  `WorkPhone`        VARCHAR(15),
  `Email`            VARCHAR(25),
  `PreferableNumber` VARCHAR(15)
);
CREATE TRIGGER setPreferPhoneNumber
  AFTER INSERT
  ON Contacts
  FOR EACH ROW
  BEGIN
    IF NEW.WorkPhone IS NOT NULL
    THEN
      UPDATE PreferableNumber
      SET NEW.PreferableNumber = NEW.WorkPhone;
    ELSE
      UPDATE PreferableNumber
      SET NEW.PreferableNumber = NEW.PersonalPhone;
    END IF;
  END;

# 6. Створити таблицю OrdersArchive що дублює таблицію Orders та має
# додаткові атрибути DeletionDateTime та DeletedBy. Створити тригер, що
# при видаленні рядків з таблиці Orders буде додавати їх в таблицю
# OrdersArchive та заповнювати відповідні колонки.
CREATE TABLE OrdersArchive
  LIKE Orders;
ALTER TABLE OrdersArchive
  ADD COLUMN DeletionDateTime DATETIME;
ALTER TABLE OrdersArchive
  ADD COLUMN DeletedBy VARCHAR(50);
DELETE FROM Orders;
CREATE TRIGGER logDeletedRow
  BEFORE DELETE
  ON Orders
  FOR EACH ROW
  BEGIN
    INSERT INTO OrdersArchive
      SELECT
        Orders.*,
        NOW()          AS DeletionDateTime,
        CURRENT_USER() AS DeletedBy
      FROM OLD;
  END;
# 7. Створити три таблиці: TriggerTable1, TriggerTable2 та TriggerTable3. Кожна з
# таблиць має наступну структуру: TriggerId(int) – первинний ключ з
# автоінкрементом, TriggerDate(Date). Створити три тригера. Перший тригер
# повинен при будь-якому записі в таблицю TriggerTable1 додати дату запису
# в таблицю TriggerTable2. Другий тригер повинен при будь-якому записі в
# таблицю TriggerTable2 додати дату запису в таблицю TriggerTable3. Третій
# тригер працює аналогічно за таблицями TriggerTable3 та TriggerTable1.
# Вставте один рядок в таблицю TriggerTable1. Напишіть, що відбулось в
# коментарі до коду. Чому це сталося?
CREATE TABLE TriggerTable1 (
  `TriggerId`   INT PRIMARY KEY AUTO_INCREMENT,
  `TriggerDate` DATE
);
CREATE TABLE TriggerTable2
  LIKE TriggerTable1;
CREATE TABLE TriggerTable3
  LIKE TriggerTable1;

CREATE TRIGGER trigger1
  AFTER INSERT
  ON TriggerTable1
  FOR EACH ROW
  BEGIN
    INSERT INTO TriggerTable2 (TriggerDate) VALUE(CURDATE());
  END;

CREATE TRIGGER trigger2
  AFTER INSERT
  ON TriggerTable2
  FOR EACH ROW
  BEGIN
    INSERT INTO TriggerTable3 (TriggerDate) VALUE(CURDATE());
  END;

CREATE TRIGGER trigger3
  AFTER INSERT
 ON TriggerTable3
  FOR EACH ROW
  BEGIN
    INSERT INTO TriggerTable1 (TriggerDate) VALUE(CURDATE());
    INSERT INTO TriggerTable2 (TriggerDate) VALUE(CURDATE());
  END;

INSERT INTO TriggerTable1 (TriggerDate) VALUE ("2018-04-01");

#  Can't update table 'TriggerTable1' in stored function/trigger
# because it is already used by statement which invoked this stored function/trigger

# trigger3 не смог добавить запись в TriggerTable1 потому что добавление строки вызванное
# командой  INSERT INTO TriggerTable1 (TriggerDate) VALUE ("2018-04-01");
# еще не было закончено.
