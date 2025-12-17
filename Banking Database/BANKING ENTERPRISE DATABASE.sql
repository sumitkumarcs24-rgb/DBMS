show databases;
create database IF NOT
exists BankDatabase;
show databases;
use BankDatabase;

create table Branch (branchname varchar(30), 
branchcity varchar(30), assests real, primary key(branchname));
desc Branch;

create table BankAccount(accno integer, branchname varchar(30), balance real,
primary key(accno), foreign key(branchname) references Branch(branchname));
desc BankAccount;

create table BankCustomer(customername varchar(30), customerstreet varchar(30),
customercity varchar(30), primary key(customername));
desc BankCustomer;

create table Depositer(customername varchar(30), accno integer,
primary key(customername, accno), foreign key(customername) references 
BankCustomer(customername), foreign key(accno) references BankAccount(accno));
desc Depositer;

create table Loan(loannumber int, branchname varchar(30), amount real,
primary key (loannumber), foreign key(branchname) references Branch(branchname));
desc Loan;

insert into Branch values('SBI_Chamrajpet', 'Bangalore', 50000),
('SBI_ResidencyRoad', 'Bangalore', 10000),('SBI_ShivajiRoad', 'Bombay', 20000),
('SBI_ParliamentRoad', 'Delhi', 10000),('SBI_Jantarmantar', 'Delhi', 20000);
select * from Branch;

insert into Loan values (2, 'SBI_ResidencyRoad', 2000),
(1, 'SBI_Chamrajpet', 1000), (3,'SBI_ShivajiRoad', 3000),
(4, 'SBI_ParliamentRoad', 4000), (5, 'SBI_Jantarmantar', 5000);
select * from Loan;

insert into BankAccount values
(1, 'SBI_Chamrajpet', 2000), (2, 'SBI_ResidencyRoad', 5000),
(3, 'SBI_ShivajiRoad', 6000), (4, 'SBI_ParliamentRoad', 9000),
(5, 'SBI_Jantarmantar', 8000), (6, 'SBI_ShivajiRoad', 4000),
(8, 'SBI_ResidencyRoad', 4000), (9, 'SBI_ParliamentRoad', 3000),
(10, 'SBI_ResidencyRoad', 5000), (11, 'SBI_Jantarmantar', 2000);
select * from BankAccount;

insert into BankCustomer values
('Avinaash', 'VV Road', 'Bangalore'),
('Dinesh', 'Bull Temple Road', 'Bangalore'),
('Nikil', 'Churchgate Street', 'Bombay'),
('Ravi', 'Karol Bagh', 'Delhi'),
('Avinash', 'Jantarmantar Road', 'Delhi');
select * from BankCustomer;

insert into Depositer values ('Avinaash', 1), ('Dinesh', 2), ('Nikil', 3), ('Ravi', 4), ('Avinash', 8), ('Nikil', 9),
('Dinesh', 10), ('Nikil', 11);
select * from Depositer;

SELECT 
    D.customername,
    B.branchname,
    COUNT(D.accno) AS total_accounts
FROM Depositer D
JOIN BankAccount B 
    ON D.accno = B.accno
GROUP BY D.customername, B.branchname
HAVING COUNT(D.accno) >= 2;


SELECT 
    D.customername
FROM 
    Depositer D
    JOIN BankAccount A ON D.accno = A.accno
    JOIN Branch B ON A.branchname = B.branchname
WHERE 
    B.branchcity = 'Delhi'
GROUP BY 
    D.customername
HAVING 
    COUNT(DISTINCT B.branchname) = (
        SELECT COUNT(*)  
        FROM Branch 
        WHERE branchcity = 'Delhi');



DELETE D
FROM Depositer D
JOIN BankAccount A ON D.accno = A.accno
JOIN Branch B ON A.branchname = B.branchname
WHERE B.branchcity = 'Bombay';

DELETE A
FROM BankAccount A
JOIN Branch B ON A.branchname = B.branchname
WHERE B.branchcity = 'Bombay';
SELECT * FROM BankAccount;

CREATE VIEW BRANCH_TOTAL_LOAN AS
SELECT
    branchname,
    SUM(amount) AS total_loan_amount
FROM
    Loan
GROUP BY
    branchname;
SELECT * FROM BRANCH_TOTAL_LOAN;

SELECT *
FROM Loan
Order By amount desc;

create table Borrower(
customername varchar(30), loannumber int, primary key(customername, loannumber),
foreign key(customername) references BankCustomer(customername), 
foreign key(loannumber) references Loan(loannumber));

insert into Borrower values
('Avinaash',1), ('Ravi',4), ('Nikil',3);

SELECT customername 
FROM Depositer
UNION
SELECT customername 
FROM Borrower;

SET SQL_SAFE_UPDATES = 0;
UPDATE Branch 
SET assests = assests * 1.05;
SET SQL_SAFE_UPDATES = 1;
SELECT * FROM Branch;