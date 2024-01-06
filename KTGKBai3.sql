create proc TaoPhanManhNXB
as
Begin
	select *into nxb1
	from NhaXuatBan
	where LoaiHinh = N'T? nhân'

	select *into nxb2
	from NhaXuatBan
	where LoaiHinh = N'Nhà n??c'
End
Exec TaoPhanManhNXB
go

create proc TaoPhanManhSach
as
Begin
	select *into sach1
	from Sach
	where MaNXB in (select MaNXB from nxb1)

	select *into sach2
	from Sach
	where MaNXB in (select MaNXB from nxb2)
End
Exec TaoPhanManhSach
go
--2
create proc DSSachMuc1(@TenNXB nvarchar(50))
as
Begin
	if @TenNXB is null
		Print N'nxb không null'
	else if not exists(select*from NhaXuatBan where TenNXB=@TenNXB)
		Print N'nxb không có trong csdl'
	else
		Begin
			select sa.MaSach,sa.TuaSach,nxb.MaNXB,nxb.TenNXB
			from NhaXuatBan nxb,Sach sa
			where nxb.MaNXB=sa.MaNXB and @TenNXB=nxb.TenNXB
		End
End
go
Exec DSSachMuc1 N'Tu?i hoa'
Exec DSSachMuc1 N'S? th?t'
Exec DSSachMuc1 N'M? thu?t'
go
create proc DSSachMuc2(@TenNXB nvarchar(50))
as
Begin
	if @TenNXB is null
		Print N'nxb không null'
	else if not exists(select*from NhaXuatBan where TenNXB=@TenNXB)
		Print N'nxb không có trong csdl'
	else
		Begin
			select sa.MaSach,sa.TuaSach,nxb.MaNXB,nxb.TenNXB
			from nxb1 nxb,sach1 sa
			where nxb.MaNXB=sa.MaNXB and @TenNXB=nxb.TenNXB
			union
			select sa.MaSach,sa.TuaSach,nxb.MaNXB,nxb.TenNXB
			from nxb2 nxb,sach2 sa
			where nxb.MaNXB=sa.MaNXB and @TenNXB=nxb.TenNXB
		End
End
go
Exec DSSachMuc2 N'Tu?i hoa'
Exec DSSachMuc2 N'S? th?t'
Exec DSSachMuc2 N'M? thu?t'
go
--cau 3
create proc ThemNXBMuc1(@MaNXB nvarchar(50),@TenNXB nvarchar(50),@loaiHinh nvarchar(50))
as
Begin
	if @TenNXB is null 
		Print N'ten nxb không null'
	else if  @MaNXB is null 
		Print N'ma nxb không null'
	else if @loaiHinh is null
		Print N'loai hình không null'
	else if not exists(select*from NhaXuatBan where LoaiHinh=@loaiHinh)
		Print N'Lo?i hình khác t? nhân ho?c nhà n??c'
	else if exists(select*from NhaXuatBan where @MaNXB=MaNXB)
		Print N'Trùng Mã NXB'
	else
		Begin
			insert into NhaXuatBan(MaNXB,TenNXB,LoaiHinh)
			values(@MaNXB,@TenNXB,@loaiHinh)
		End
End
go
Exec ThemNXBMuc1 NULL,N'T??ng lai',N'T? nhân'
Exec ThemNXBMuc1 N'NXB20',NULL, N'T? nhân'
Exec ThemNXBMuc1 N'NXB20',N'T??ng lai',NULL
Exec ThemNXBMuc1 N'NXB10',N'T??ng lai',N'T? nhân'
Exec ThemNXBMuc1 N'NXB11',N'Giáo d?c',N'Nhà n??c'
Exec ThemNXBMuc1 N'NXB5',N'Thi?u niên',N'Nhà n??c'
Exec ThemNXBMuc1 N'NXB6',N'Thanh niên',N'Nhà n??c'
go
create proc ThemNXBMuc2(@MaNXB nvarchar(50),@TenNXB nvarchar(50),@loaiHinh nvarchar(50))
as
Begin
	if @TenNXB is null 
		Print N'ten nxb không null'
	else if  @MaNXB is null 
		Print N'ma nxb không null'
	else if @loaiHinh is null
		Print N'loai hình không null'
	else if not exists(select*from NhaXuatBan where LoaiHinh=@loaiHinh)
		Print N'Lo?i hình khác t? nhân ho?c nhà n??c'
	else if exists(select*from nxb1 where @MaNXB=MaNXB)
		Print N'Trùng Mã NXB'
	else if exists(select*from nxb2 where @MaNXB=MaNXB)
		Print N'Trùng Mã NXB'
	else
		Begin
			if @loaiHinh=N'T? nhân'
				Begin
					insert into nxb1(MaNXB,TenNXB,LoaiHinh)
					values(@MaNXB,@TenNXB,@loaiHinh)
				End
			else
				Begin
					insert into nxb2(MaNXB,TenNXB,LoaiHinh)
					values(@MaNXB,@TenNXB,@loaiHinh)
				End
		End
End
go
Exec ThemNXBMuc2 NULL,N'T??ng lai',N'T? nhân'
Exec ThemNXBMuc2 N'NXB20',NULL, N'T? nhân'
Exec ThemNXBMuc2 N'NXB20',N'T??ng lai',NULL
Exec ThemNXBMuc2 N'NXB10',N'T??ng lai',N'T? nhân'
Exec ThemNXBMuc2 N'NXB11',N'Giáo d?c',N'Nhà n??c'
Exec ThemNXBMuc2 N'NXB5',N'Thi?u niên',N'Nhà n??c'
Exec ThemNXBMuc2 N'NXB6',N'Thanh niên',N'Nhà n??c'
go
--cau 4 --
create proc SuaNXBMuc1(@MaNXB nvarchar(50),@TenNXB nvarchar(50),@loaiHinh nvarchar(50))
as
Begin
	if  @MaNXB is null 
		Print N'ma nxb không null'
	else if @loaiHinh is null
		Print N'loai hình không null'
	else if not exists(select*from NhaXuatBan where LoaiHinh=@loaiHinh)
		Print N'Lo?i hình khác t? nhân ho?c nhà n??c'
	else if not exists(select*from NhaXuatBan where @MaNXB=MaNXB)
		Print N'Không tìm th?y mã nxb'
	else
		Begin
			update NhaXuatBan
			set TenNXB=@TenNXB,LoaiHinh=@loaiHinh
			where @MaNXB=MaNXB
		End
End
go
Exec SuaNXBMuc1 NULL,N'Sáng t?o m?i',N'T? nhân'
Exec SuaNXBMuc1 N'NXB123',N'K? thu?t',N'T? nhân'
Exec SuaNXBMuc1 N'NXB1',N'K? thu?t',NULL
Exec SuaNXBMuc1 N'NXB1',N'K? thu?t',N'Nh?p kh?u'
Exec SuaNXBMuc1 N'NXB1',N'Sáng t?o m?i',N'T? nhân'
Exec SuaNXBMuc1 N'NXB6',N'??t Vi?t',N'T? nhân'
go
create proc SuaNXBMuc2(@MaNXB nvarchar(50),@TenNXB nvarchar(50),@loaiHinh nvarchar(50))
as
Begin
	if  @MaNXB is null 
		Print N'ma nxb không null'
	else if @loaiHinh is null
		Print N'loai hình không null'
	else if not exists(select*from NhaXuatBan where LoaiHinh=@loaiHinh)
		Print N'Lo?i hình khác t? nhân ho?c nhà n??c'
	else if not exists(select*from nxb1 where @MaNXB=MaNXB) and not exists(select*from nxb2 where @MaNXB=MaNXB)
		Print N'Không tìm th?y mã nxb'
	else
		Begin
			if @loaiHinh=N'T? nhân' and exists(select*from nxb1 where @MaNXB=MaNXB)
			Begin
				update nxb1
				set TenNXB=@TenNXB,LoaiHinh=@loaiHinh
				where @MaNXB=MaNXB
			end
			else if @loaiHinh=N'Nhà n??c' and exists(select*from nxb1 where @MaNXB=MaNXB)
			Begin
				insert into nxb2(MaNXB,TenNXB,LoaiHinh)
				values(@MaNXB,@TenNXB,@loaiHinh)

				delete from nxb1 where MaNXB=@MaNXB
			End
			else if @loaiHinh=N'Nhà n??c' and exists(select*from nxb2 where @MaNXB=MaNXB)
			Begin
				update nxb2
				set TenNXB=@TenNXB,LoaiHinh=@loaiHinh
				where @MaNXB=MaNXB
			End
			else if @loaiHinh=N'T? nhân' and exists(select*from nxb2 where @MaNXB=MaNXB)
			Begin
				insert into nxb1(MaNXB,TenNXB,LoaiHinh)
				values(@MaNXB,@TenNXB,@loaiHinh)

				delete from nxb2 where MaNXB=@MaNXB
			End
		End
End
go
Exec SuaNXBMuc2 NULL,N'Sáng t?o m?i',N'T? nhân'
Exec SuaNXBMuc2 N'NXB123',N'K? thu?t',N'T? nhân'
Exec SuaNXBMuc2 N'NXB1',N'K? thu?t',NULL
Exec SuaNXBMuc2 N'NXB1',N'K? thu?t',N'Nh?p kh?u'
Exec SuaNXBMuc2 N'NXB1',N'Sáng t?o m?i',N'T? nhân'
Exec SuaNXBMuc2 N'NXB6',N'??t Vi?t',N'T? nhân'
Exec SuaNXBMuc2 N'NXB3',N'Thành công',N'Nhà n??c'
go
--cau 5
create proc XoaSachMuc1(@MaSach nvarchar(50))
as
Begin
	if  @MaSach is null 
		Print N'ma sach không null'
	else if not exists(select*from Sach where @MaSach=MaSach)
		Print N'không tìm th?y mã sách ?? xóa d? li?u'
	else
		Begin
			delete from Sach where @MaSach=MaSach
		End
End
go
Exec XoaSachMuc1 NULL 
Exec XoaSachMuc1 N'S123'
Exec XoaSachMuc1 N'S004'
Exec XoaSachMuc1 N'S005'
go
create proc XoaSachMuc2(@MaSach nvarchar(50))
as
Begin
	if  @MaSach is null 
		Print N'ma sach không null'
	else if not exists(select*from sach1 where @MaSach=MaSach) and not exists(select*from sach2 where @MaSach=MaSach)
		Print N'không tìm th?y mã sách ?? xóa d? li?u'
	else
		Begin
			if exists(select*from sach1 where @MaSach=MaSach)
				delete from sach1 where @MaSach=MaSach
			else
				delete from sach2 where @MaSach=MaSach
		End
End
go
Exec XoaSachMuc2 NULL 
Exec XoaSachMuc2 N'S123'
Exec XoaSachMuc2 N'S004'
Exec XoaSachMuc2 N'S005'




