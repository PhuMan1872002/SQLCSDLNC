use QLTruongDH
go
create proc TaoPM_Doc_Khoa
as
Begin
	select MaKhoa,TenKhoa into Khoa_Doc1
	from Khoa
	select MaKhoa,CoSo into Khoa_Doc2
	from Khoa
End
Exec TaoPM_Doc_Khoa
go
--cau 2
create proc XemKhoa_Doc @CoSo nvarchar(50)
as
Begin
	if @CoSo is null
		Begin
			select MaKhoa,TenKhoa,CoSo
			from Khoa
		End
	else if not exists (select*from Khoa where @CoSo=CoSo)
		Begin
			Print N'Ten co so khong hop le'
		End
	else
		Begin
			select MaKhoa,TenKhoa,CoSo
			from Khoa
			where CoSo=@CoSo
		End
End
Exec XemKhoa_Doc Null
