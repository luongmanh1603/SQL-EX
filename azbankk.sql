Create database AZBankk
go
use AZbankk
go

--2
create table Customer (
  CustomerId int Primary key Not NUll,
  Name nvarchar(50),
  City nvarchar(50),
  Country nvarchar(50),
  Phone nvarchar(50),
  Email nvarchar(50),
  )

create table CustomerAccount (
  AccountNumber char(9) Primary key not null,
  CustomerId int not null,
  Balance money not null,
  MinAccount money,
  FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId)
)

create table CustomerTransaction (
  TransactionId int Primary key not null,
  AccountNumber char(9),
  TransactionDate smalldatetime,
  Amount money,
  DepositorWithdraw bit,
      FOREIGN KEY (AccountNumber) REFERENCES CustomerAccount (AccountNumber)

)

--3
insert into Customer values 
(1, 'Nguyen Van A', 'Bee', 'HaNoi','00001','a00001@gmail.com'),
(2, 'Le Van B', 'Beamin', 'ThanhHoa','00002','b00002@gmail.com'),
(3, 'Dang Van C', 'ShoppeFood', 'NgheAn','00003','c00003@gmail.com')

insert into CustomerAccount values 
('nva01', 1, 15000, ''),
('lvb02', 2, 10000, ''),
('dvc03', 3, 19000, '')

insert into CustomerTransaction values 
(01, 'nva01', '', '', ''),
(02, 'lvb02', '', '', ''),
(03, 'dvc03', '', '', '')
 select * from Customer
 select * from CustomerAccount
 select * from CustomerTransaction
--4
select * from Customer
where Country = 'HaNoi'

--5
select name, phone, Email, AccountNumber, Balance
from Customer c
join CustomerAccount ca
on c.CustomerId = ca.CustomerId


--6 ???
ALTER TABLE CustomerTransaction
ADD CONSTRAINT CK_Amount 
CHECK (Amount > 0 AND Amount <= 1000000);

--7 ???
CREATE NONCLUSTERED INDEX IX_Customer_Name
ON Customer (Name);
--8
Create view vCustomerTransactions 
as 
select Name, Balance, TransactionDate, Amount, DepositorWithdraw 
from Customer c
join CustomerAccount ca
on c.CustomerId = ca.CustomerId
join CustomerTransaction ct
on ct.AccountNumber= ca.AccountNumber

select * from vCustomerTransactions
--9
--9--
CREATE PROCEDURE spAddCustomer (@CustomerId INT, @CustomerName VARCHAR(50), @Country VARCHAR(50), @Phone VARCHAR(50), @Email VARCHAR(50))
AS
BEGIN
    INSERT INTO Customer (CustomerId, Name, Country, Phone, Email)
    VALUES (@CustomerId, @CustomerName, @Country, @Phone, @Email)
END

EXEC spAddCustomer 1, 'John Doe', 'Hanoi', '123 456 789', 'johndoe@email.com'
EXEC spAddCustomer 2, 'Jane Doe', 'Hanoi', '0987 654 321', 'janedoe@email.com'
EXEC spAddCustomer 3, 'Jim Smith', 'USA', '+1 123 456 789', 'jimsmith@email.com'



--10--
CREATE PROCEDURE spGetTransactions (@AccountNumber INT, @FromDate DATE, @ToDate DATE)
AS
BEGIN
    SELECT Customer.Name, CustomerAccount.AccountNumber, CustomerTransaction.TransactionDate, CustomerTransaction.Amount, CustomerTransaction.DepositorWithdraw
    FROM Customer
    INNER JOIN CustomerAccount ON Customer.CustomerId = CustomerAccount.CustomerId
    INNER JOIN CustomerTransaction ON CustomerAccount.AccountNumber = CustomerTransaction.AccountNumber
    WHERE CustomerAccount.AccountNumber = @AccountNumber
      AND CustomerTransaction.TransactionDate BETWEEN @FromDate AND @ToDate
END






