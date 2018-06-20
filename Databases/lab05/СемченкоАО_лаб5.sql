# Andrii Semchenko IP-63
# MariaDB
# 1. Створити базу даних з ім’ям, що відповідає вашому прізвищу англійською мовою.
CREATE DATABASE semchenko;
USE semchenko;
# 2. Створити в новій базі таблицю Student з атрибутами StudentId, SecondName,
# FirstName, Sex. Обрати для них оптимальний тип даних в вашій СУБД.
CREATE TABLE Student (
  StudentId  INT,
  SecondName VARCHAR(20),
  FirstName  VARCHAR(15),
  Sex        CHAR(1)
);
# 3. Модифікувати таблицю Student. Атрибут StudentId має стати первинним ключем.
ALTER TABLE Student
  ADD PRIMARY KEY (StudentId);
# 4. Модифікувати таблицю Student. Атрибут StudentId повинен заповнюватися
# автоматично починаючи з 1 і кроком в 1.
ALTER TABLE Student
  MODIFY StudentId INT AUTO_INCREMENT;
# 5. Модифікувати таблицю Student. Додати необов’язковий атрибут BirthDate
# з відповідним типом даних.
ALTER TABLE Student
  ADD BirthDate DATE DEFAULT NULL;
# 6. Модифікувати таблицю Student. Додати атрибут CurrentAge, що
# генерується автоматично на базі існуючих в таблиці даних.
ALTER TABLE Student
  ADD CurrentAge INT AS (YEAR(CURDATE()) - YEAR(BirthDate));
# 7. Реалізувати перевірку вставлення даних. Значення атрибуту Sex може
# бути тільки ‘m’ та ‘f’.
ALTER TABLE Student
  ADD CHECK (Sex = 'm' OR Sex = 'f');
# 8. В таблицю Student додати себе та двох «сусідів» у списку групи.
INSERT INTO Student (FirstName, SecondName, Sex)
VALUES
  ('Vera', 'Popova', 'f'),
  ('Michael', 'Sytnik', 'm');
# 9. Створити представлення vMaleStudent та vFemaleStudent, що надають
# відповідну інформацію.
CREATE VIEW vMaleStudent AS
  SELECT *
  FROM Student
  WHERE Sex = 'm';
CREATE VIEW vFemaleStudent AS
  SELECT *
  FROM Student
  WHERE Sex = 'f';
# 10.Змінити тип даних первинного ключа на TinyInt (або SmallInt) не
# втрачаючи дані.
ALTER TABLE Student
  MODIFY StudentId TINYINT AUTO_INCREMENT;