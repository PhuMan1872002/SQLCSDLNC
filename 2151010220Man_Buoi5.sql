--cau 2 muc 1
create view ViewThongKeSLKHTheoQG
as
select count(CustomerID) as slkh ,Country
from Northwind.dbo.Customers
group by Country
go
select*from dbo.ViewThongKeSLKHTheoQG
go
--cau 2 muc 2
create view ViewThongKeSLKHTheoQG1
as
select count(CustomerID) as slkh ,Country
from Northwind1.dbo.KH1
group by Country
union 
select count(CustomerID) as slkh ,Country
from Northwind1.dbo.KH2
group by Country
go
select*from dbo.ViewThongKeSLKHTheoQG1
go
--cau 3 muc 1
create view ViewThongKeSLDHTheoQG
as
select count(dh.OrderID) as slkh ,Country
from Northwind.dbo.Customers kh,Northwind.dbo.Orders dh
where kh.CustomerID =dh.CustomerID
group by kh.Country
go
select*from dbo.ViewThongKeSLDHTheoQG
go
-- cau 3 muc 2
create view ViewThongKeSLDHTheoQG1
as
select count(dh1.OrderID) as slkh ,Country
from Northwind1.dbo.KH1 kh1,Northwind1.dbo.DH1 dh1
where kh1.CustomerID =dh1.CustomerID
group by kh1.Country
union
select count(dh2.OrderID) as slkh ,Country
from Northwind1.dbo.KH2 kh2,Northwind1.dbo.DH2 dh2
where kh2.CustomerID =dh2.CustomerID
group by kh2.Country
go
select*from dbo.ViewThongKeSLDHTheoQG1
go
--cau 4 muc 1
create proc ProcKHChuaMuaHangMuc1
as
Begin
	select *
	from Northwind.dbo.Customers kh
	where kh.CustomerID not in(select CustomerID from Northwind.dbo.Orders)
End
go
Exec ProcKHChuaMuaHangMuc1
go
--cau 4 muc 2
create proc ProcKHChuaMuaHangMuc2
as
Begin
	select *
	from Northwind1.dbo.KH1 kh1
	where kh1.CustomerID not in(select CustomerID from Northwind1.dbo.DH1)
	union
	select *
	from Northwind1.dbo.KH2 kh1
	where kh1.CustomerID not in(select CustomerID from Northwind1.dbo.DH2)
End
go
Exec ProcKHChuaMuaHangMuc1
go
--cau 5 muc 1
create proc ProcThemKHMuc1 @MaKH char(10),@TenCty nchar(50),@ThanhPho nchar(50),@QuocGia nchar(50)
as
begin
	insert into Northwind.dbo.Customers(CustomerID,CompanyName,City,Country)
	values(@MaKH,@TenCty,@ThanhPho,@QuocGia)
end
go
Exec ProcThemKHMuc1 'KH002','fsdf','fdsef','ử5ytrergert'
select *from Northwind.dbo.Customers order by CustomerID desc
go
--cau 5 muc 2
create proc ProcThemKHMuc2 @MaKH char(10),@TenCty nchar(50),@ThanhPho nchar(50),@QuocGia nchar(50)
as
begin
	if @QuocGia ='USA' or @QuocGia='UK'
		insert into Northwind1.dbo.KH1(CustomerID,CompanyName,City,Country)
		values(@MaKH,@TenCty,@ThanhPho,@QuocGia)
	else
		insert into Northwind1.dbo.KH2(CustomerID,CompanyName,City,Country)
		values(@MaKH,@TenCty,@ThanhPho,@QuocGia)
end
Exec ProcThemKHMuc2 'KH001','NB',N'Sài Gòn','VietNam'
Exec ProcThemKHMuc2 'KH002','NB1',N'London','UK'
select*
from KH1
Union
select*
from KH2
go
--cau 6 muc 1
create proc ProcSuaKHMuc1 @MaKH char(10),@ThanhPho nchar(50),@QuocGia nchar(50)
as
begin
	Update Northwind.dbo.Customers
	set City=@ThanhPho,Country=@QuocGia
	where CustomerID=@MaKH
end
go
Exec ProcSuaKHMuc1'KH001','San Fran','USA'
select*from Northwind.dbo.Customers
go
--cau 6 muc 2
USE Northwind1
GO

CREATE PROC ProcSuaKHMuc2
@MaKH nchar(5), @ThanhPho nvarchar(15), @QuocGia nvarchar(15)
AS
BEGIN
	DECLARE @TenCty nvarchar(50)
	IF EXISTS (SELECT CustomerID FROM Northwind1.dbo.KH1 WHERE CustomerID = @MaKH)
		BEGIN
		UPDATE Northwind1.dbo.KH1
		SET City = @ThanhPho, Country = @QuocGia
		WHERE CustomerID = @MaKH
		SELECT @TenCty = CompanyName FROM Northwind1.dbo.KH1 WHERE CustomerID = @MaKH
		IF @QuocGia <> 'USA' AND @QuocGia <> 'UK'
			BEGIN
			INSERT INTO Northwind1.dbo.KH2(CustomerID, CompanyName, City, Country)
			VALUES (@MaKH, @TenCty, @ThanhPho, @QuocGia)
			DELETE FROM KH1 WHERE CustomerID = @MaKH
			END
		END
	ELSE
		BEGIN
		UPDATE Northwind1.dbo.KH2
		SET City = @ThanhPho, Country = @QuocGia
		WHERE CustomerID = @MaKH
		SELECT @TenCty = CompanyName FROM Northwind1.dbo.KH2 WHERE CustomerID = @MaKH
		IF @QuocGia = 'USA' OR @QuocGia = 'UK'
			BEGIN
			INSERT INTO Northwind1.dbo.KH1(CustomerID, CompanyName, City, Country)
			VALUES (@MaKH, @TenCty, @ThanhPho, @QuocGia)
			DELETE FROM KH2 WHERE CustomerID = @MaKH
			END
		END
END
GO

EXEC ProcSuaKHMuc2 'KH001', 'San Francisco', 'USA'
GO
EXEC ProcSuaKHMuc2 'KH002', 'Hanoi', 'Vietnam'
GO


SELECT * FROM Northwind1.dbo.KH1
UNION
SELECT * FROM Northwind1.dbo.KH2
GO
--cau 7 muc 1
create proc ProcXoaKHMuc1 @MaKH char(10)
as
Begin
delete from Northwind.dbo.Customers where CustomerID=@MaKH
End
go
--cau 7 muc 2
create proc ProcXoaKHMuc2 @MaKH char(10)
as
Begin
delete from KH1 where CustomerID=@MaKH
delete from KH2 where CustomerID=@MaKH
End
--cau 8 muc 1
Exec ProcXoaKHMuc1 'KH001'
select*from Northwind.dbo.Customers
Exec ProcXoaKHMuc2 'KH001'
select*from Northwind1.dbo.KH1
go
--cau 8 muc 2
create function FuncSLDHMuc1(@QuocGia nchar(50))
returns int
as
	begin
		declare @sl int
		select @sl=count(CustomerID)
		from Northwind.dbo.Customers
		where Country=@QuocGia
		return @sl
	end
go
select Northwind1.dbo.FuncSLDHMuc1 ('UK')
go
--cau 9 muc 2
create function FuncSLDHMuc2(@QuocGia nchar(50))
returns int
as
	begin
		declare @sl int
		declare @sl1 int
		declare @sl2 int
		select @sl1=count(CustomerID)
		from Northwind1.dbo.KH1
		where Country=@QuocGia
	 
		select @sl2=count(CustomerID)
		from Northwind1.dbo.KH2
		where Country=@QuocGia
		set @sl=@sl1+@sl2
		return @sl
	end
go
select Northwind1.dbo.FuncSLDHMuc2 ('USA')
go
--cau 9 muc 1
CREATE FUNCTION FuncDSDHMuc1(@QG nvarchar(50))
RETURNS TABLE
AS RETURN
(
		SELECT o.*
		FROM Northwind.dbo.Customers c , Northwind.dbo.Orders o 
		WHERE c.Country = @QG and c.CustomerID = o.CustomerID
)
GO

SELECT * FROM dbo.FuncDSDHMuc1('USA')
SELECT * FROM dbo.FuncDSDHMuc1('UK')
SELECT * FROM dbo.FuncDSDHMuc1('Vietnam')
SELECT * FROM dbo.FuncDSDHMuc1('Brazil')

-- Mức 2:
USE Northwind1
GO

CREATE FUNCTION FuncDSDHMuc2(@QG nvarchar(50))
RETURNS TABLE
AS RETURN
(
		SELECT o.*
		FROM Northwind1.dbo.KH1 c , Northwind1.dbo.DH1 o 
		WHERE c.Country = @QG and c.CustomerID = o.CustomerID
		UNION
		SELECT o.*
		FROM Northwind1.dbo.KH2 c ,Northwind1.dbo.DH2 o 
		WHERE c.Country = @QG and c.CustomerID = o.CustomerID
)
GO

SELECT * FROM dbo.FuncDSDHMuc2('USA')
SELECT * FROM dbo.FuncDSDHMuc2('UK')
SELECT * FROM dbo.FuncDSDHMuc2('Vietnam')
SELECT * FROM dbo.FuncDSDHMuc2('Brazil')





