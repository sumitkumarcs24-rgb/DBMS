create database EMPLL;
use EMPLL;

create table dept(
deptno decimal(2,0) primary key,
dname varchar(14) default NULL,
loc varchar(13) default NULL);

create table emp(
empno decimal(4,0) primary key,
ename varchar(10) default NULL,
mgr_no decimal(4,0) default NULL,
hiredate date default NULL,
sal decimal(7,2) default NULL,
deptno decimal(2,0) references dept(deptno) ON DELETE CASCADE ON UPDATE CASCADE);

create table incentives(
empno decimal(4,0) references emp(empno) on delete cascade on update cascade,
incentive_date date,
incentive_amount decimal(10,2),
primary key(empno,incentive_date));
 
create table project(
pno int primary key,
pname varchar(30) not null,
ploc varchar(30));
 
create table assigned_to(
empno decimal(4,0) references emp(empno) on delete cascade on update cascade,
pno int references project(pno) on delete cascade on update cascade,
job_role varchar(30),
primary key(empno,pno));

INSERT INTO dept VALUES (10,'ACCOUNTING','MUMBAI'),
(20,'RESEARCH','BENGALURU'),
(30,'SALES','DELHI'),
(40,'OPERATIONS','CHENNAI'),
(50,'LOGISTICS','HYDERABAD'),
(60,'MARKETING','MYSURU');

INSERT INTO emp VALUES 
(7369,'Adarsh',7902,'2012-12-17',80000.00,20),
(7499,'Shruthi',7698,'2013-02-20',16000.00,30),
(7521,'Anvitha',7698,'2015-02-22',12500.00,30),
(7566,'Tanvir',7839,'2008-04-02',29750.00,20),
(7654,'Ramesh',7698,'2014-09-28',12500.00,30),
(7698,'Kumar',7839,'2015-05-01',28500.00,30),
(7782,'CLARK',7839,'2017-06-09',24500.00,10),
(7788,'SCOTT',7566,'2010-12-09',30000.00,20),
(7839,'KING', NULL,'2009-11-17',50000.00,10),
(7844,'TURNER',7698,'2010-09-08',15000.00,30),
(7876,'ADAMS',7788,'2013-01-12',11000.00,20),
(7900,'JAMES',7698,'2017-12-03',9500.00,30),
(7902,'FORD',7566,'2010-12-03',30000.00,20);


INSERT INTO incentives VALUES
(7499,'2019-02-01',5000.00),
(7521,'2019-03-01',2500.00),
(7566,'2022-02-01',5070.00),
(7654,'2020-02-01',2000.00),
(7654,'2022-04-01',879.00),
(7521,'2019-02-01',8000.00),
(7698,'2019-03-01',500.00),
(7698,'2020-03-01',9000.00),
(7698,'2022-04-01',4500.00);

INSERT INTO project VALUES
(101,'AI Project','BENGALURU'),
(102,'IOT','HYDERABAD'),
(103,'BLOCKCHAIN','BENGALURU'),
(104,'DATA SCIENCE','MYSURU'),
(105,'AUTONOMUS SYSTEMS','PUNE'),
(106, 'MACHINE LEARNING','DELHI');

INSERT INTO assigned_to VALUES
(7499,101,'Software Engineer'),
(7521,101,'Software Architect'),
(7566,101,'Project Manager'),
(7654,102,'Sales'),
(7521,102,'Software Engineer'),
(7499,102,'Software Engineer'),
(7654,103,'Cyber Security'),
(7698,104,'Software Engineer'),
(7900,105,'Software Engineer'),
(7839,104,'General Manager');

SELECT a.empno
FROM assigned_to a
JOIN project p ON a.pno = p.pno
WHERE p.ploc IN ('BENGALURU', 'HYDERABAD', 'MYSURU');

SELECT empno
FROM emp
WHERE empno NOT IN (SELECT empno FROM incentives);

select e.empno, e.ename, d.dname, d.loc, a.job_role, p.ploc
from emp e, dept d, assigned_to a, project p
where e.deptno=d.deptno and e.empno=a.empno and a.pno=p.pno and d.loc=p.ploc;

select m.ename, count(*)
from emp e, emp m
where e.mgr_no = m.empno
group by m.ename
having count(*) = (select max(mycount)
				   from (select count(*) mycount
						 from emp
						 group by mgr_no)a);
                         
select ename
from emp m
where m.empno IN (select mgr_no
				  from emp)
and m.sal> (select avg(e.sal)
            from emp e
			where e.mgr_no = m.empno);
            
SELECT d.deptno, d.dname, e.ename AS top_manager
FROM dept d
JOIN emp e ON d.deptno = e.deptno
WHERE e.mgr_no IS NULL;

select *
from emp e, incentives i
where e.empno = i.empno 
and 2 = (select count(*)
         from incentives j
         where i.incentive_amount <= j.incentive_amount);
         
SELECT e.ename
FROM emp e
LEFT JOIN incentives i ON e.empno = i.empno
GROUP BY e.empno, e.ename, e.sal
HAVING (e.sal + IFNULL(SUM(i.incentive_amount), 0)) >= ANY (SELECT sal FROM emp);

select *
from emp e
where e.deptno = (select e1.deptno
				  from emp e1
				  where e1.empno = e.mgr_no);