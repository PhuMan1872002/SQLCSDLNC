use master
go
create database NorthWind1
go
use NorthWind1
go
CREATE TABLE Kh1(
	[CustomerID] [nchar](5) NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL
)
go
CREATE TABLE Kh2(
	[CustomerID] [nchar](5) NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL
)
go
--manh 1
insert into NorthWind1.dbo.Kh1
select*
from Northwind.dbo.Customers
where Country='USA' or Country='UK'
--manh 2
insert into NorthWind1.dbo.Kh2
select*
from Northwind.dbo.Customers
where Country !='UK' and Country!='USA'
--
select *from KH2
go
--
create proc KHMuc1
as
Begin
	select*from Northwind.dbo.Customers
End
go
Exec dbo.KHMuc1
go
--Cau 6
create proc KHMuc2
as
Begin
	select*from Northwind1.dbo.KH1
	Union
	select*from Northwind1.dbo.KH2
End
go
Exec KHMuc2
go
--cau 7
create proc KHMuc1Can(@QG nvarchar(30))
as
Begin
	select*
	from Northwind.dbo.Customers
	where Country = @QG
End
go
Exec KHMuc1Can 'Canada'
go
--Cau 8
create proc KHMuc2Can(@QG nvarchar(30))
as
Begin
SELECT *
FROM
(
    SELECT * FROM NorthWind1.dbo.Kh1
    UNION
    SELECT * FROM NorthWind1.dbo.Kh2
) AS tbl
WHERE Country =@QG
End
go
Exec KHMuc2Can 'UK'
go
--cau 9
CREATE TABLE [dbo].[DH1](
	[OrderID] [int]  NOT NULL,
	[CustomerID] [nchar](5) NULL,
	[EmployeeID] [int] NULL,
	[OrderDate] [datetime] NULL,
	[RequiredDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[ShipVia] [int] NULL,
	[Freight] [money] NULL,
	[ShipName] [nvarchar](40) NULL,
	[ShipAddress] [nvarchar](60) NULL,
	[ShipCity] [nvarchar](15) NULL,
	[ShipRegion] [nvarchar](15) NULL,
	[ShipPostalCode] [nvarchar](10) NULL,
	[ShipCountry] [nvarchar](15) NULL
)
go
CREATE TABLE [dbo].[DH2](
	[OrderID] [int]  NOT NULL,
	[CustomerID] [nchar](5) NULL,
	[EmployeeID] [int] NULL,
	[OrderDate] [datetime] NULL,
	[RequiredDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[ShipVia] [int] NULL,
	[Freight] [money] NULL,
	[ShipName] [nvarchar](40) NULL,
	[ShipAddress] [nvarchar](60) NULL,
	[ShipCity] [nvarchar](15) NULL,
	[ShipRegion] [nvarchar](15) NULL,
	[ShipPostalCode] [nvarchar](10) NULL,
	[ShipCountry] [nvarchar](15) NULL
)
go
 
select * into NorthWind1.dbo.Dh1
from Northwind.dbo.Orders
where CustomerID in (select CustomerID from Kh1)
go
select * into NorthWind1.dbo.Dh2
from Northwind.dbo.Orders
where CustomerID in (select CustomerID from Kh2)
go
--10
select *from Northwind.dbo.Orders
--11
select *from Northwind1.dbo.dh1
union 
select *from Northwind1.dbo.dh2
go
--12
create proc Cau12(@QG char(50))
as
Begin
select *
from Northwind.dbo.Orders
where OrderID in (select OrderID from Northwind.dbo.Customers where Country=@QG)
End
go
Exec Cau12 'Canada'
go
--13
create proc Cau13(@QG char(50))
as
Begin
SELECT *
FROM
(
    SELECT * FROM NorthWind1.dbo.DH1 where OrderID in(select OrderID from Kh1 where Country=@QG)
    UNION
     SELECT * FROM NorthWind1.dbo.DH2 where OrderID in(select OrderID from Kh2 where Country=@QG)
) AS tbl
End
go
Exec Cau13 'Canada'
--14
use NorthWind1
go
SELECT [EmployeeID]
      ,[LastName]
      ,[FirstName]
      ,[Title]
      ,[TitleOfCourtesy]
	  into NV1
  FROM [Northwind].[dbo].[Employees]
--
SELECT [EmployeeID]
      ,[BirthDate]
      ,[HireDate]
      ,[Address]
      ,[City]
      ,[Region]
      ,[PostalCode]
      ,[Country]
      ,[HomePhone]
      ,[Extension]
      ,[Photo]
      ,[Notes]
      ,[ReportsTo]
      ,[PhotoPath]
	  into NV2
  FROM [Northwind].[dbo].[Employees]
  --15
  select *from Northwind.dbo.Employees
  go
  --16
  select *
  from Northwind1.dbo.NV1 nv1, Northwind1.dbo.NV2 nv2
  where nv1.EmployeeID = nv2.EmployeeID