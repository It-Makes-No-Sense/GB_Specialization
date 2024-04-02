-- В подключенном MySQL репозитории создать базу данных “Друзья человека”
CREATE DATABASE Human_friends;

-- Создать таблицы с иерархией из диаграммы в БД
-- Заполнить низкоуровневые таблицы именами(животных), командами которые они выполняют и датами рождения
USE Human_friends;
CREATE TABLE Animals
(
	Id INT AUTO_INCREMENT PRIMARY KEY, 
	Class_name VARCHAR(20)
);

INSERT INTO Animals (Class_name)
VALUES ('Pack'),('Home');  


CREATE TABLE Pack_Animals
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    Animal_name VARCHAR (20),
    Class_id INT,
    FOREIGN KEY (Class_id) REFERENCES Animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Pack_Animals (Animal_name, Class_id)
VALUES ('Horse', 1),('Camel', 1),('Donkey', 1); 
    
CREATE TABLE Home_Animals
(
	  Id INT AUTO_INCREMENT PRIMARY KEY,
    Animal_name VARCHAR (20),
    Class_id INT,
    FOREIGN KEY (Class_id) REFERENCES Animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Home_Animals (Animal_name, Class_id)
VALUES ('Cat', 2), ('Dog', 2), ('Hamster', 2); 

CREATE TABLE Cat 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Animal_id int,
    Foreign KEY (Animal_id) REFERENCES Home_Animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Cat (Name,Birthday,Commands,Animal_id)
VALUES ('Orange','2023-02-23','Meow',1), 
('Туся','2020-05-12','Ks-ks-ks',1);

CREATE TABLE Dog 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Animal_id int,
    Foreign KEY (Animal_id) REFERENCES Home_Animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Dog (Name,Birthday,Commands,Animal_id)
VALUES ('Drujok','2021-02-23','Woof!',2),
('Sobaka','2023-05-12','Tyaf',2);

CREATE TABLE Hamster 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Animal_id int,
    Foreign KEY (Animal_id) REFERENCES Home_Animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Hamster (Name,Birthday,Commands,Animal_id)
VALUES ('Fat','2024-01-23','Спать',3),
('Ham','2021-07-12','Жрать',3);

CREATE TABLE Horse 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Animal_id int,
    Foreign KEY (Animal_id) REFERENCES Pack_Animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Horse (Name,Birthday,Commands,Animal_id)
VALUES ('Blacky','2019-05-21','Run',1),
('Беззубик','2015-02-11','Лежать',1),
('Диего','2017-02-11','Есть',1);

CREATE TABLE Camel 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Animal_id int,
    Foreign KEY (Animal_id) REFERENCES Pack_Animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Camel (Name,Birthday,Commands,Animal_id)
VALUES ('Sandy','2015-07-01','Walk',2),
('Саманта','2018-02-06','Стоять',2);

CREATE TABLE Donkey 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Animal_id int,
    Foreign KEY (Animal_id) REFERENCES Pack_Animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Donkey (Name,Birthday,Commands,Animal_id)
VALUES ('Dumby','2017-07-25','Slow-walk',3),
('Слепыш','2020-07-25','Смотреть',3);

/* 
Удалив из таблицы верблюдов, т.к. верблюдов решили перевезти в другой питомник на зимовку. 
Объединить таблицы лошади, и ослы в одну таблицу. 
*/
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Camel;

SELECT Name, Birthday, Commands FROM Horse
UNION SELECT  Name, Birthday, Commands FROM Donkey;

/* 
Создать новую таблицу “молодые животные” в которую попадут все животные старше 1 года, 
но младше 3 лет и в отдельном столбце с точностью до месяца подсчитать возраст животных в новой таблице
*/

CREATE TEMPORARY TABLE Temp_Animals AS 
SELECT *,'Horse' as class  FROM Horse
UNION SELECT *,'Donkey' as class  FROM Donkey
UNION SELECT *,'Dog' as class  FROM Dog
UNION SELECT *,'Cat' as class FROM Cat
UNION SELECT *,'Hamster' as class FROM Hamster;

CREATE TABLE Young_Animals AS
SELECT Name, Birthday, Commands, class, TIMESTAMPDIFF(MONTH, Birthday, CURDATE()) AS Animal_age
FROM animals WHERE Birthday BETWEEN ADDDATE(curdate(), INTERVAL -3 YEAR) AND ADDDATE(CURDATE(), INTERVAL -1 YEAR);
 

/* Объединить все таблицы в одну, при этом сохраняя поля, указывающие на прошлую принадлежность к старым таблицам.*/
SELECT h.Name, h.Birthday, h.Commands, pa.Animal_name, ya.Animal_age
FROM Horse h
LEFT JOIN Young_Animals ya ON ya.Name = h.Name
LEFT JOIN Pack_Animals pa ON pa.Id = h.Animal_id
UNION 
SELECT d.Name, d.Birthday, d.Commands, pa.Animal_name, ya.Animal_age
FROM Donkey d
LEFT JOIN Young_Animals ya ON ya.Name = d.Name
LEFT JOIN Pack_Animals pa ON pa.Id = d.Animal_id
UNION
SELECT c.Name, c.Birthday, c.Commands, ha.Animal_name, ya.Animal_age
FROM Cat c
LEFT JOIN Young_Animals ya ON ya.Name = c.Name
LEFT JOIN Home_Animals ha ON ha.Id = c.Animal_id
UNION
SELECT d.Name, d.Birthday, d.Commands, ha.Animal_name, ya.Animal_age
FROM Dog d
LEFT JOIN Young_Animals ya ON ya.Name = d.Name
LEFT JOIN Home_Animals ha ON ha.Id = d.Animal_id
UNION
SELECT h.Name, h.Birthday, h.Commands, ha.Animal_name, ya.Animal_age
FROM Hamster h
LEFT JOIN Young_Animals ya ON ya.Name = h.Name
LEFT JOIN Home_Animals ha ON ha.Id = h.Animal_id