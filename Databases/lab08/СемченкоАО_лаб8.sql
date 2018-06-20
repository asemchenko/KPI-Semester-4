# Andrii Semchenko IP-63
# MariaDB

# 1. Створити базу даних підприємства «LazyStudent», що займається
# допомогою студентам ВУЗів з пошуком репетиторів, проходженням
# практики та розмовними курсами за кордоном.
CREATE DATABASE LazyStudent;
# 2. Самостійно спроектувати структуру бази в залежності від наступних
# завдань.
# 3. База даних повинна передбачати реєстрацію клієнтів через сайт компанії
# та збереження їх основної інформації. Збереженої інформації повинно бути
# достатньо для контактів та проведення поштових розсилок.
CREATE TABLE LazyStudent.Customers (
  ID               INT PRIMARY KEY      AUTO_INCREMENT,
  FirstName        VARCHAR(15) NOT NULL,
  LastName         VARCHAR(20) NOT NULL,
  Nickname         VARCHAR(20) NOT NULL,
  PasswordHash     VARCHAR(64) NOT NULL,
  PhoneNumber      VARCHAR(15) NOT NULL,
  Email            VARCHAR(20) NOT NULL,
  RegistrationDate DATE        NOT NULL DEFAULT CURDATE()
);
# 4. Через сайт компанії може також зареєструватися репетитор, що надає
# освітні послуги через посередника «LazyStudent». Репетитор має профільні
# дисципліни (довільна кількість) та рейтинг, що визначається клієнтами, що
# з ним уже працювали.
CREATE TABLE LazyStudent.Tutors (
  ID               INT PRIMARY KEY      AUTO_INCREMENT,
  FirstName        VARCHAR(15) NOT NULL,
  LastName         VARCHAR(20) NOT NULL,
  Nickname         VARCHAR(20) NOT NULL,
  PasswordHash     VARCHAR(64) NOT NULL,
  PhoneNumber      VARCHAR(15) NOT NULL,
  Email            VARCHAR(20) NOT NULL,
  RegistrationDate DATE        NOT NULL DEFAULT CURDATE()
);

CREATE TABLE LazyStudent.Subjects (
  ID          INT PRIMARY KEY AUTO_INCREMENT,
  Name        VARCHAR(60) NOT NULL,
  Description TEXT
);

CREATE TABLE LazyStudent.TutorSubjects (
  TutorID   INT NOT NULL REFERENCES LazyStudent.Tutors (ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  SubjectID INT NOT NULL REFERENCES LazyStudent.Subjects (ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  PRIMARY KEY (TutorID, SubjectID)
);

CREATE TABLE LazyStudent.Feedbacks (
  TutorID   INT NOT NULL REFERENCES LazyStudent.Tutors (ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  SubjectID INT NOT NULL REFERENCES LazyStudent.Subjects (ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  Rating    INT NOT NULL,
  Feedback  TEXT,
  PRIMARY KEY (TutorID, SubjectID)
);
# 5. Компанії, з якими співпрацює підприємство, також мають зберігатися в БД.
CREATE TABLE LazyStudent.Partners (
  ID          INTEGER PRIMARY KEY AUTO_INCREMENT,
  CompanyName VARCHAR(50) NOT NULL,
  Phone       VARCHAR(30) NOT NULL
);
# 6. Співробітники підприємства повинні мати можливість відстежувати
# замовлення клієнтів та їх поточний статус. Передбачити можливість
# побудови звітності (в тому числі і фінансової) в розрізі періоду, клієнту,
# репетитора/компанії.
DROP TABLE LazyStudent.Orders;
CREATE TABLE LazyStudent.Orders (
  ID              INTEGER PRIMARY KEY                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             AUTO_INCREMENT,
  TutorID         INTEGER REFERENCES LazyStudent.Tutors (ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CompanyID       INTEGER REFERENCES LazyStudent.Partners (ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CustomerId      INTEGER REFERENCES LazyStudent.Customers (ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  Discipline      INTEGER REFERENCES LazyStudent.Subjects (ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CurrentStatus   VARCHAR(30) DEFAULT 'New order',
  OrderDate       DATE    NOT NULL                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            DEFAULT CURDATE(),
  Price           INTEGER NOT NULL,
  DiscountProcent INTEGER NOT NULL,
  FinalPrice      INTEGER NOT NULL,
  CONSTRAINT CHECK (TutorID IS NOT NULL OR CompanyID IS NOT NULL)
);
USE LazyStudent;
CREATE VIEW CLIENT_STATISTIC AS
  SELECT
    Customers.*,
    SUM(FinalPrice) AS 'Sum price of all orders'
  FROM Customers
    INNER JOIN Orders ON Customers.ID = Orders.CustomerId
  GROUP BY Customers.ID;
CREATE VIEW TUTOR_STATISTIC AS
  SELECT
    Tutors.*,
    SUM(FinalPrice) AS 'Sum price of all orders'
  FROM Orders
    INNER JOIN Tutors ON Orders.TutorID = Tutors.ID
  GROUP BY Tutors.ID;
CREATE PROCEDURE recvOrdersByDate(IN minDate DATE, IN maxDate DATE)
  BEGIN
    SELECT *
    FROM Orders
    WHERE OrderDate > minDate AND OrderDate < maxDate;
  END;
# 7. Передбачити ролі адміністратора, рядового працівника та керівника.
# Відповідним чином розподілити права доступу.
CREATE USER IF NOT EXISTS admin@localhost
  IDENTIFIED BY 'admin';
GRANT ALL ON *.* TO admin@localhost;
CREATE USER IF NOT EXISTS worker@localhost
  IDENTIFIED BY 'worker';
GRANT SELECT, INSERT ON *.* TO worker@localhost;
CREATE USER IF NOT EXISTS boss@localhost
  IDENTIFIED BY 'boss';
GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO boss@localhost;
FLUSH PRIVILEGES;
# 8. Передбачити історію видалень інформації з БД. Відповідна інформація не
# повинна відображатися на боці сайту, але керівник та адміністратор
# мусять мати можливість переглянути хто, коли і яку інформацію видалив.
CREATE TABLE DeletedOrders
  LIKE LazyStudent.Orders;
ALTER TABLE DeletedOrders
  ADD DeletingTime DATETIME;
DROP TRIGGER logDeletedRow;
CREATE TRIGGER logDeletedRow
  BEFORE DELETE
  ON Orders
  FOR EACH ROW
  BEGIN
    INSERT INTO DeletedOrders VALUES
      (OLD.ID,
        OLD.TutorID,
        OLD.CompanyID,
        OLD.CustomerId,
        OLD.Discipline,
        OLD.CurrentStatus,
        OLD.OrderDate,
        OLD.Price,
        OLD.DiscountProcent,
        OLD.FinalPrice,
        NOW());
  END;
 # same for other tables ...

# 9. Передбачити систему знижок в залежності від дати реєстрації клієнта. 1
  # рік – 5%, 2 роки – 8%, 3 роки – 11%, 4 роки – 15%.
CREATE TRIGGER CalculateSales
BEFORE INSERT ON Orders
FOR EACH ROW
  BEGIN
    DECLARE years DOUBLE;
    SET years = (SELECT DATEDIFF(NOW(), RegistrationDate)/365 FROM Customers WHERE Customers.ID = NEW.CustomerId);
    SET NEW.DiscountProcent =
    CASE years
      WHEN 0 THEN 0
      WHEN 1 THEN 5
      WHEN 2 THEN 8
      WHEN 3 THEN 11
      ELSE 15
    END;
    SET NEW.FinalPrice = Price * (100 - NEW.DiscountProcent) / 100;
  END;
