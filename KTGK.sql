use QLNhanVien
go
--cau 1 a)
create proc TaoPM_Ngang_PB
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
Exec TaoPM_Ngang_PB
go
select*from PBHN
select *from PBSG
go
--cau 1b)
create proc TaoPM_Ngang_NhanVien
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
Exec TaoPM_Ngang_NhanVien
select*from NV1
select*from NV2
go
--cau 2
create proc ThemPB(@MaPB nvarchar(50) , @TenPB nvarchar(50),  @ChiNhanh nvarchar(50))
as
Begin
	if (@MaPB is null or @TenPB is null or @ChiNhanh is null)
		Print N'Mã phòng bị null hoặc tên phòng bị null hoặc chi nhánh null'
	else if (@ChiNhanh !=N'Sài gòn' and @ChiNhanh !=N'Hà nội' )
		Print N'Chi nhánh khác sg hoặc hn'
	else if exists(select MaPB from PBSG where @MaPB=MaPB) or exists (select MaPB from PBHN where @MaPB=MaPB)
		Print N'Trùng mã phòng ban'
	else
		if @ChiNhanh like N'Sài gòn'
			insert into PBSG(MaPB,TenPB,ChiNhanh)
			values(@MaPB,@TenPB,@ChiNhanh)
		else
			insert into PBHN(MaPB,TenPB,ChiNhanh)
			values(@MaPB,@TenPB,@ChiNhanh)
		Print N'Thêm thành công'
end
go
Exec ThemPB 'PB008','IT',N'Hà nội'
go
--cau 3
create proc SuaPB(@MaPB nvarchar(50) , @TenPB nvarchar(50),  @ChiNhanh nvarchar(50))
as
Begin
	if (@MaPB is null or @TenPB is null or @ChiNhanh is null)
		Print N'Mã phòng bị null hoặc tên phòng bị null hoặc chi nhánh null'
	else if (@ChiNhanh !=N'Sài gòn' and @ChiNhanh !=N'Hà nội' )
		Print N'Chi nhánh khác sg hoặc hn'
	else if not exists(select MaPB from PBSG where @MaPB=MaPB) and not exists (select MaPB from PBHN where @MaPB=MaPB)
		Print N'Không có mã phòng ban'
	else if exists (select MaPB from PBSG where @MaPB=MaPB)
		if @ChiNhanh like N'Sài gòn'
			Begin
				Update PBSG
				set TenPB=@TenPB
				where @MaPB=MaPB
				Print N'Sửa thành công ở bảng sài gòn'
			End
		else
			Begin
				delete from PBSG where MaPB=@MaPB
				insert into PBHN values(@MaPB,@TenPB,@ChiNhanh)
				Print N'Xóa dữ liệu ở bảng sài gòn và dời sang bảng hà nội'
			End
	else if exists (select MaPB from PBHN where @MaPB=MaPB)
		if @ChiNhanh like N'Hà nội'
			Begin
				Update PBHN
				set TenPB=@TenPB
				where @MaPB=MaPB
				Print N'Sửa thành công ở bảng hà nội'
			End
		else
			Begin
				delete from PBHN where MaPB=@MaPB
				insert into PBSG values(@MaPB,@TenPB,@ChiNhanh)
				print N'Xóa dữ liệu ở bảng hà nội và dời sang bảng sài gòn'
			End	
end
go
Exec SuaPB 'PB04',N'I tờ',N'Sài gòn'
go
--cau 4
create proc TaoPM_Doc_PB
as
Begin
	select MaPB,TenPB into PhongBan_Doc1
	from PhongBan

	select MaPB,ChiNhanh into PhongBan_Doc2
	from PhongBan
end

Exec TaoPM_Doc_PB
go

--cau 5
create proc XemPB_Doc
as
Begin
	select pb1.MaPB,pb1.TenPB,pb2.ChiNhanh
	from PhongBan_Doc1 pb1,PhongBan_Doc2 pb2
	where pb1.MaPB=pb2.MaPB
End
go
--cau 6
alter proc SuaPB_Doc(@MaPB nvarchar(50) , @TenPB nvarchar(50),  @ChiNhanh nvarchar(50))
as
Begin
	if (@MaPB is null or @TenPB is null or @ChiNhanh is null)
		Print N'Mã phòng bị null hoặc tên phòng bị null hoặc chi nhánh null'
	else if (@ChiNhanh !=N'Sài gòn' and @ChiNhanh !=N'Hà nội' )
		Print N'Chi nhánh khác sg hoặc hn'
	else if not exists(select MaPB from PhongBan_Doc1 where @MaPB=MaPB) and not exists(select MaPB from PhongBan_Doc2 where @MaPB=MaPB) 
		Print N'không có mã phòng ban'
	else
		update PhongBan_Doc1
		set MaPB=@MaPB,TenPB=@TenPB
		where MaPB=@MaPB

		update PhongBan_Doc2
		set MaPB=@MaPB,ChiNhanh=@ChiNhanh
		where MaPB=@MaPB
End
go
Exec SuaPB_Doc 'PB09',N'Đồ chơi',N'Sài gòn'

