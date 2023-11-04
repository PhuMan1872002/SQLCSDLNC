create function TenNhanVien(@MaNV int)
returns nvarchar(100)
as
Begin
	declare @ten nvarchar(50)
	select @ten=FirstName+' '+LastName
	from Employees
	where EmployeeID=@MaNV
	return @ten
End
go
select dbo.TenNhanVien(7)
go
--
create function SLKhachHangCuaQuocGia(@TenQG char(50))
returns int
as
Begin
	declare @sl int
	select @sl=count(CustomerID)
	from Customers
	where Country=@TenQG
	return @sl
End
go
select dbo.SLKhachHangCuaQuocGia('USA')
go
--
create function  DSDonHangCuaQuocGiaKhachHang1
(@TenQG nvarchar(50))
returns table
as return
(
	select o.*
	from Customers c,Orders o
	where c.CustomerID=o.CustomerID and c.Country=@TenQG
)
go
select*from dbo.DSDonHangCuaQuocGiaKhachHang1('UK')
go
--10
set dateformat dmy
go
create function  DSDonHangCuaQuocGiaKhachHang2
(@TenQG nvarchar(50))
returns table
as return
(
	select o.OrderID,FORMAT(o.OrderDate,'dd/MM/yyyy') as OrderDate,Sum(od.Quantity*od.UnitPrice) as TongTien
	from Customers c,Orders o,[Order Details] od
	where c.CustomerID=o.CustomerID and od.OrderID=o.OrderID and c.Country=@TenQG
	group by o.OrderID,o.OrderDate
)
go
set dateformat dmy
go
select*from dbo.DSDonHangCuaQuocGiaKhachHang2('USA')
--trigger
create table R(A int,B int,C int)
go
create trigger Trigger2 on R
for update,insert,delete
as
if Update(C)
	Print N'Cột c được cập nhật'
if exists(select*from inserted)
	Print N'Cột c vừa được thêm'
if exists(select*from deleted)
	Print N'Cột c vừa được xóa'
go
insert into R values(1,2,3)
update R
set C=4
where C=3
delete from R where C=3
go
--14
create trigger Trigger3 on R
for update
as
if (UPDATE(A))
	Begin
		Raiserror(N'K cho update',16,10)
		Rollback transaction
	End
go
Update R
set A=10
where A=1
go
--4
create function  SLDonHangCuaKhachHang1(@TenCty nvarchar(50))
returns nvarchar(100)
as
Begin
	declare @sl int
	select @sl=Count(o.OrderID)
	from Customers c,Orders o
	where c.CompanyName=@TenCty and c.CustomerID=o.CustomerID
	return @sl
End
go
select dbo.SLDonHangCuaKhachHang1('Cactus Comidas para llevar')
go
--6
create function  SLDonHangCuaKhachHang3(@TenQG nvarchar(50))
returns int
as
Begin
	declare @sl int
	if @TenQG is null or @TenQG =''
		Begin
			select @sl=count(*)
			from Orders
		End
	else
		Begin
			select @sl=Count(o.OrderID)
			from Customers c,Orders o
			where c.Country=@TenQG and c.CustomerID=o.CustomerID
		End
	return @sl
End
go
select dbo.SLDonHangCuaKhachHang3('USA')
go
--11
create function DSHangHoaCuaKhachHang1(@MaKH char(50))
returns table
as
Return
(
	select p.ProductID,p.ProductName,sum(od.Quantity) as TongSL
	from Customers c,[Order Details]od,Orders o,Products p
	where c.CustomerID=o.CustomerID and o.OrderID=od.OrderID and p.ProductID=od.ProductID and c.CustomerID=@MaKH
	group by p.ProductID,p.ProductName
)
go
select*from DSHangHoaCuaKhachHang1('ALFKI')
go
--16
create trigger Trigger4 on R
for update
as
if (UPDATE(B))
	if exists(select*from inserted where B>99)
		Begin
			Raiserror(N'K cho update cột B',16,10)
			Rollback transaction
		End
go
Update R
set B=100
where B=2
go
--17
create trigger Trigger5 on R
for delete
as
if (Exists (select*from deleted))
		Begin
			Raiserror(N'K cho xóa',16,10)
			Rollback transaction
		End
go
delete from R where A=1
go
--12
create function DSHangHoaCuaKhachHang2(@MaKH char(50))
returns table
as
Return
(
	
	case
		when @MaKH is null or @MaKH =''
			then select *from Products
		else
			select p.ProductID,p.ProductName,sum(od.Quantity) as TongSL
			from Customers c,[Order Details]od,Orders o,Products p
			where c.CustomerID=o.CustomerID and o.OrderID=od.OrderID and p.ProductID=od.ProductID and c.CustomerID=@MaKH
			group by p.ProductID,p.ProductName
	end
)
go
select*from DSHangHoaCuaKhachHang1('ALFKI')
go


CREATE FUNCTION dbo.DSHangHoaCuaKhachHang2
(
    @MaKhachHang NVARCHAR(10) = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT OD.ProductID, P.ProductName, SUM(OD.Quantity) AS TongSoLuong
    FROM Orders O
    JOIN Customers C ON O.CustomerID = C.CustomerID
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    WHERE @MaKhachHang IS NULL OR C.CustomerID = @MaKhachHang
    GROUP BY OD.ProductID, P.ProductName
)
go
SELECT *
FROM dbo.DSHangHoaCuaKhachHang2('BLAUS')

SELECT *
FROM dbo.DSHangHoaCuaKhachHang2(NULL)
go
--5
create function TongTienMuahangCuaKhachHang(@MaKH char(50))
returns float
as
Begin
	declare @Gia float
	select @Gia=sum(od.Quantity*od.UnitPrice*(1-od.Discount))
	from Customers c join Orders o on c.CustomerID=o.CustomerID join
		[Order Details] od on o.OrderID=od.OrderID
	where c.CustomerID=@MaKH
	return @Gia
End
go
select dbo.TongTienMuahangCuaKhachHang('QUICK')