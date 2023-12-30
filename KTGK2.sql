use QLNhanVien
go
-- cau 1
create proc TaoPhanManhPB
as
Begin
	select *into PBSG
	from dbo.PhongBan
	where ChiNhanh like N'Sài gòn'
	
	select *into PBHN
	from dbo.PhongBan
	where ChiNhanh like N'Hà nội'
End
Go
Exec TaoPhanManhPB
go
create proc TaoPhanManhNV
as
Begin
	select *into NV1
	from dbo.NhanVien
	where MaPB in(select MaPB from dbo.PBSG)
	
	select *into NV2
	from dbo.NhanVien
	where MaPB in(select MaPB from dbo.PBHN)
End
Go
Exec TaoPhanManhNV
go
--cau 2
create proc DSNhanVienMuc1 (@TenPB nvarchar(50))
as
Begin
	if @TenPB is null
		Begin
			Print N'Đéo đc null'
			return;
		End
	if exists(select*from PhongBan where TenPB=@TenPB)
	Begin
		select nv.MaNV,nv.Ho,nv.Ten,pb.MaPB,pb.TenPB,pb.ChiNhanh
		from PhongBan pb,NhanVien nv
		where pb.MaPB=nv.MaPB and @TenPB=pb.TenPB
	End
	else
		Print N'Đéo có tên'
End
Exec DSNhanVienMuc1 N'Thiết kế'
go
--
create proc DSNhanVienMuc2 (@TenPB nvarchar(50))
as
Begin
	if @TenPB is null
		Begin
			Print N'Đéo đc null'
			return;
		End
	if exists(select*from PhongBan where TenPB=@TenPB)
	Begin
				select nv.MaNV,nv.Ho,nv.Ten,pb.MaPB,pb.TenPB,pb.ChiNhanh
				from PBSG pb,NV1 nv
				where pb.MaPB=nv.MaPB and pb.TenPB=@TenPB
				union
				select nv.MaNV,nv.Ho,nv.Ten,pb.MaPB,pb.TenPB,pb.ChiNhanh
				from PBHN pb,NV2 nv
				where pb.MaPB=nv.MaPB and pb.TenPB=@TenPB
	End
	else
		Print N'Đéo có tên'
End
Exec DSNhanVienMuc2 N'Sản xuất'
go
--cau 3
create proc ThemPhongBanMuc1 (@MaPB nvarchar(50),@TenPB nvarchar(50),@ChiNhanh nvarchar(50))
as
Begin
	if @TenPB is null or @MaPB is null or @ChiNhanh is null
		Begin
			Print N'Đéo đc null'
			return;
		End
	if exists(select*from PhongBan where MaPB=@MaPB)
		Begin
			Print N'Trùng mã pb'
			return;
		End
	if exists(select*from PhongBan where ChiNhanh=@ChiNhanh)
	Begin
				insert into PhongBan
				values(@MaPB,@TenPB,@ChiNhanh)
	End
	else
		Print N'Đéo có tên chi nhánh'
End
Exec ThemPhongBanMuc1 N'PB11',N'Hihi',null
go

create proc ThemPhongBanMuc2 (@MaPB nvarchar(50),@TenPB nvarchar(50),@ChiNhanh nvarchar(50))
as
Begin
	if @TenPB is null or @MaPB is null or @ChiNhanh is null
		Begin
			Print N'Đéo đc null'
			return;
		End
	if exists(select*from PBSG where MaPB=@MaPB)
		Begin
			Print N'Trùng mã pb'
			return;
		End
	if exists(select*from PBHN where MaPB=@MaPB)
		Begin
			Print N'Trùng mã pb'
			return;
		End
	if not exists(select*from PhongBan where ChiNhanh=@ChiNhanh)
		Begin
			Print N'Không tồn tại chi nhánh'
			return;
		End

	if exists(select*from PhongBan where ChiNhanh=N'Sài gòn')
	Begin

				insert into PBSG
				values(@MaPB,@TenPB,@ChiNhanh)
	End
	else
		Begin

					insert into PBHN
					values(@MaPB,@TenPB,@ChiNhanh)
		End
End
Exec ThemPhongBanMuc2 N'PB13',N'Hihi',N'Cần thơi'
go
--cau 4
create proc SuaPhongBanMuc1  (@MaPB nvarchar(50),@TenPB nvarchar(50),@ChiNhanh nvarchar(50))
as
Begin
	if @MaPB is null or @ChiNhanh is null
		Begin
			Print N' mã pb null'
			return;
		End

	if @ChiNhanh is null
		Begin
			Print N'chi nhánh null'
			return;
		End
	if not exists(select*from PhongBan where MaPB=@MaPB)
		Begin
			Print N'Không tìm thấy mã PB'
			return;
		End
	if exists(select*from PhongBan where ChiNhanh=@ChiNhanh)
		Begin
			Update PhongBan
			set TenPB=@TenPB,ChiNhanh=@ChiNhanh
			where MaPB=@MaPB
		End
	else
		Print N'Không tìm thấy chi nhánh'
End
Exec SuaPhongBanMuc1 N'PB01',N'Nghiên cứu', N'Sài gòn'
go

alter proc SuaPhongBanMuc2  (@MaPB nvarchar(50),@TenPB nvarchar(50),@ChiNhanh nvarchar(50))
as
Begin
	if @MaPB is null 
		Begin
			Print N' mã pb null'
			return;
		End

	if @ChiNhanh is null
		Begin
			Print N'chi nhánh null'
			return;
		End
	if not exists(select*from PBSG where MaPB=@MaPB) and not exists(select*from PBHN where MaPB=@MaPB)
		Begin
			Print N'Không tìm thấy mã PB'
			return;
		End
	if exists(select*from PhongBan where ChiNhanh=@ChiNhanh)
		Begin
			if exists(select *from PBSG where @MaPB=MaPB and @ChiNhanh=ChiNhanh)
				Begin
					Update PBSG
					set TenPB=@TenPB,ChiNhanh=@ChiNhanh
					where MaPB=@MaPB
					return;
				End
			if exists(select *from PBSG where @MaPB=MaPB ) and @ChiNhanh=N'Hà nội'
				Begin
					delete from PBSG where @MaPB=MaPB 
					insert into PBHN(MaPB,TenPB,ChiNhanh)
					values(@MaPB,@TenPB,@ChiNhanh)
					return;
				End
			if exists(select *from PBHN where @MaPB=MaPB and @ChiNhanh=ChiNhanh)
				Begin
					Update PBHN
					set TenPB=@TenPB,ChiNhanh=@ChiNhanh
					where MaPB=@MaPB
					return;
				End
			if exists(select *from PBHN where @MaPB=MaPB)  and @ChiNhanh=N'Sài gòn'
				Begin
					delete from PBHN where @MaPB=MaPB 
					insert into PBSG(MaPB,TenPB,ChiNhanh)
					values(@MaPB,@TenPB,@ChiNhanh)
					return;
				End		
		End
	else
		Print N'Không tìm thấy chi nhánh'
End

Exec SuaPhongBanMuc2  N'PB09',N'Kỹ thuật',N'Sài gòn'