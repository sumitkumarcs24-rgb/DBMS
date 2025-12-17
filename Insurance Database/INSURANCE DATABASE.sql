show databases;
create database if not exists InsuranceDatabase;
show databases;
use InsuranceDatabase;

create table Person (driver_id varchar(20), name varchar(20), address varchar(20), primary key(driver_id));
create table Car (reg_num varchar(20), model varchar(10), year int, primary key(reg_num));
create table Accident (report_num int, accident_date date, location varchar(20), primary key(report_num));
create table Ownss (driver_id varchar(20), reg_num varchar(20), primary key(driver_id, reg_num),
foreign key(driver_id) references Person(driver_id), foreign key(reg_num) references Car(reg_num));
create table Participated (driver_id varchar(20), reg_num varchar(20), report_num int, damage_amount int,
primary key(driver_id, reg_num, report_num), foreign key(driver_id) references Person(driver_id),
foreign key(reg_num) references Car(reg_num), foreign key(report_num) references Accident(report_num));

insert into Person values ('A01', 'Monica', 'NR Colony'), ('A02', 'Richard', 'Srinivas Nagar'),
('A03', 'Smith', 'Ashok Nagar'), ('A04', 'John', 'Hanumanth Nagar'), ('A05', 'Venu', 'Rajaji Marg');

insert into Car values ('KA052250', 'Indica', 1990), ('KA031181', 'Lancer', 1957), ('KA095477', 'Toyota', 1998),
('KA053408', 'Honda', 2008), ('KA041702', 'Audi', 2005);

insert into Accident values (11, '2003-01-01', 'Mysore Road'), (12, '2004-02-01', 'Southend Circle'),
(13, '2003-01-21', 'Bull Temple Road'), (14, '2008-02-17', 'Mysore Road'), (15, '2005-03-04', 'Kanapura Road');

insert into Owns values ('A01', 'KA052250'), ('A02', 'KA031181'), ('A03', 'KA095477'), ('A04', 'KA053408'), 
('A05', 'KA041702');

insert into Participated values ('A01', 'KA052250', 11, 10000), ('A02', 'KA031181', 12, 50000),
('A03', 'KA095477', 13, 25000), ('A04', 'KA053408', 14, 8000), ('A05', 'KA041702', 15, 5000);


SELECT accident_date, location
FROM ACCIDENT;

UPDATE Participated
SET damage_amount = 25000
WHERE reg_num = 'KA053408' AND
	  report_num = 14;
Select * from Participated;


SELECT driver_id
FROM Participated
WHERE damage_amount >= 25000;

INSERT INTO Accident values (16, '2008-03-08', 'Dolmur');
Select * from Accident;
Select accident_date, location
FROM Accident;

SELECT *
FROM Participated
ORDER BY damage_amount DESC;


SELECT AVG (damage_amount) AS Avg_Damage_Amount
FROM Participated;

SELECT name 
FROM Person A, Participated B                                       
WHERE A.driver_id = B.driver_id
AND damage_amount > (SELECT AVG(damage_amount) FROM Participated);

SELECT MAX(damage_amount) AS MAX_damage_amount
FROM Participated;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM Participated
WHERE damage_amount < (
    SELECT avg_damage
    FROM (
        SELECT AVG(damage_amount) AS avg_damage
        FROM Participated
    ) AS temp
);

select * from participated;