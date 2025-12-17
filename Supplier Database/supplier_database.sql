create database supplir;
show databases;
use supplir;

create table suppliers (sid int primary key, sname varchar(20), city varchar(20));
create table parts (pid int primary key, pname varchar(20), color varchar(10));
create table catalog (sid int, pid int, foreign key(sid) references suppliers(sid), foreign key(pid) references parts(pid), cost float(6), primary key(sid,pid));

insert into suppliers values (10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'), (10003, 'Vimal', 'Mumbai'), (10004, 'Reliance', 'Delhi'), (10005, 'Mahindra', 'Mumbai');

insert into PARTS values(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

insert into CATALOG values(10001, 20001,10), (10001, 20002,10), (10001, 20003,30), (10001, 20004,10), (10001, 20005,10),
(10002, 20001,10), (10002, 20002,20), (10003, 20003,30), (10004, 20003,40);

select distinct p.pname
from parts p, catalog c
where p.pid = c.pid;

select s.sname
from suppliers s
where (select count(p.pid)
	   from parts p) = (select count(c.pid)
                        from catalog c
                        where c.sid = s.sid);
                        
select s.sname
from suppliers s 
where (select count(p.pid)
       from parts p 
       where color = 'Red') = (select count(c.pid)
                               from catalog c, parts p 
                               where c.sid = s.sid and
                                     c.pid = p.pid and
                                     p.color = 'Red');
                                     
select p.pname
from parts p, catalog c, suppliers s 
where p.pid = c.pid and
      c.sid = s.sid and
      s.sname = 'Acme Widget' and
      NOT EXISTS (select *
                  from catalog c1, suppliers s1
                  where p.pid = c1.pid and
                        c1.sid = s1.sid and
                        s1.sname <> 'Acme Widget');
                        
select distinct c.sid
from catalog c
where c.cost > (select avg(c1.cost)
                from catalog c1
                where c1.pid = c.pid);
                
select p.pid, s.sname
from parts p, suppliers s, catalog c 
where c.pid = p.pid and
      c.sid = s.sid and
      c.cost = (select max(c1.cost)
                from catalog c1
                where c1.pid = p.pid);
                
SELECT p.pid, p.pname, s.sname, c.cost
FROM parts p 
JOIN catalog c ON p.pid = c.pid
JOIN suppliers s ON s.sid = c.sid
WHERE c.cost = (SELECT MAX(cost) FROM catalog);

SELECT s.sname
FROM suppliers s
WHERE s.sid NOT IN (
    SELECT c.sid
    FROM catalog c 
    JOIN parts p ON p.pid = c.pid
    WHERE p.color = 'Red'
);

SELECT s.sid, s.sname, SUM(c.cost) AS total_value
FROM suppliers s
LEFT JOIN catalog c ON s.sid = c.sid
GROUP BY s.sid, s.sname;

SELECT s.sname
FROM suppliers s
JOIN catalog c ON s.sid = c.sid
WHERE c.cost < 20
GROUP BY s.sid, s.sname
HAVING COUNT(c.pid) >= 2;

SELECT p.pid, p.pname, s.sname, c.cost
FROM parts p
JOIN catalog c ON c.pid = p.pid
JOIN suppliers s ON s.sid = c.sid
WHERE c.cost = (
    SELECT MIN(c1.cost)
    FROM catalog c1
    WHERE c1.pid = p.pid
);

CREATE VIEW SupplierPartCount AS
SELECT s.sid, s.sname, COUNT(c.pid) AS total_parts
FROM suppliers s
LEFT JOIN catalog  c ON s.sid = c.sid
GROUP BY s.sid, s.sname;
SELECT * FROM SupplierPartCount;

CREATE VIEW MostExpensiveSupplier AS
SELECT p.pid, p.pname, s.sname, c.cost
FROM parts p
JOIN catalog c ON c.pid = p.pid
JOIN suppliers s ON s.sid = c.sid
WHERE c.cost = (
    SELECT MAX(c1.cost)
    FROM catalog c1
    WHERE c1.pid = p.pid
);
SELECT * FROM MostExpensiveSupplier;

DELIMITER $$
CREATE TRIGGER prevent_low_cost
BEFORE INSERT ON catalog
FOR EACH ROW
BEGIN
    IF NEW.cost < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cost cannot be less than 1';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER default_cost
BEFORE INSERT ON catalog
FOR EACH ROW
BEGIN
    IF NEW.cost IS NULL THEN
        SET NEW.cost = 10;
    END IF;
END $$
DELIMITER ;
