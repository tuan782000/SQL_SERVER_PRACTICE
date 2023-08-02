--03.Bài toán quản lý dịch vụ du lịch với SQL Server-Constraint, Trigger, View, Join Table
/*
1.Tạo Database
Create Database TravelManagement;
2. Có database xong thì nên use TravelManagement để focus tập trung vào Database đó
*/

Create Database TravelManagement;

use TravelManagement
select * from tblTravels; -- kiểm tra tên bảng này có được dùng chưa
--Bảng dịch vụ du lịch
Create table tblTravels (
	id int Primary Key Not Null Identity (1,1), --start from 1, icrease 1 -- Bắt đầu từ 1 và tăng lên 1 -- là khóa chính
	name nvarchar(200) Not null,
	price float default 0.0, -- trường giá cả, nếu để trống sẽ mặc định là 0.0
	numberOfDays int default 1, -- số ngày đi (vì đi du lịch ít nhất cũng 1 ngày nên nếu không điền mặc định là 1)
	startDate Date default GETDATE() -- ngày bắt đầu đi, nếu người dùng không điền sẽ lấy mặc định ngay thời điểm hiện tại today
);

--Tạo khóa ngoại 
-- Phân tích 1 danh mục có nhiều chuyến du lịch, nhiều chuyến du lịch có thể thuộc 1 danh mục
-- Thành ra trong cái bảng (nhiều) là phải chứa cái id của bảng (1) và đồng thời id đó sẽ là khóa ngoại giao tiếp giữa 2 bảng
-- (tblTravels) n -> 1 (tblCategories)
-- Câu lệnh cập nhật bảng Alter Table 

Alter table tblTravels Add categoryId int; -- Thêm trường dữ liệu
--Bắt đầu thêm foreign key cho bảng (nhiều)
Alter table tblTravels Add Constraint FK_TravelsCategories -- Tạo khóa ngoại
foreign key (categoryId) References tblCategories(id) -- ghép khóa ngoại đó cho bảng (1) trái n -> phải 1
--xong khóa ngoại

--loại bỏ khóa ngoại
Alter table tblTravels Drop Constraint FK_TravelsCategories

-- Bên cạnh đó sử dụng chức năng check (Constraint) ràng buộc dữ liệu đầu vào của số ngày của bảng tblTravels
-- numberOfDays must be (giá trị trường numberOfDays) 1->20 ngày. Số này có thể nâng lên tùy yêu cầu bài toán
-- Sử dụng CHECK 1 trong những tính năng (Constraint) ràng buộc cung cấp

-- Chỉ định bảng	 thêm Constraint  tên Constraint  phương thức sử dụng là check   Cuối cùng là điều kiện ràng buộc của Constraint
Alter Table tblTravels Add Constraint CK_NumberOfDays CHECK (numberOfDays >= 1 And numberOfDays <= 20);

-- Test Constraint CK_NumberOfDays mới tạo
-- Bằng cách thêm thử 1 dữ liệu mẫu vào trong Database của bảng tblTravels

Insert into tblTravels (name, price, numberOfDays, startDate)
Values ('travel from vietnam to sweden', 12300.0, 12, '2023-08-07')

Select * from tblTravels

-- Thử để trống cốt start date - nó sẽ lấy ngày hiện tại
Insert into tblTravels (name, price, numberOfDays)
Values ('travel from China to Japan', 23300.0, 12) 

--Câu lệnh update 1 trường trong bảng dữ liệu
Update tblTravels
set name = 'travel from China to Japan', price = 23300.0, numberOfDays = 19
where id = 2

-- thử để số âm vào trường ngày để test xem ràng buộc (Constraint) có hoạt động không
Insert into tblTravels (name, price, numberOfDays)
Values ('travel from China to Japan', 12300.0, -12) 
-- nó sẽ báo lỗi vi phạm "CK_NumberOfDays"

--xóa 1 trường dữ liệu trong 1 bảng
DELETE FROM tblTravels WHERE id=3;

-- Thử vi phạm vượt quá số ngày quy định (quy định ít hơn 20 ngày)
Insert into tblTravels (name, price, numberOfDays)
Values ('travel from China to Japan', 23300.0, 30) 


--hợp lệ
Insert into tblTravels (name, price, numberOfDays)
Values ('travel from Viet Nam to Singapore', 23300.0, 17) 


-- Ví dụ muốn tên là duy nhất thì sao
----cập nhật lại giá trị cho bảng đó quy định rằng bảng tblTravels phải có tên unique
Alter table tblTravels Add Constraint Uc_Name Unique(name);





-- Sau khi tạo khóa ngoại giữa 2 bảng thì sẽ dùng exec sp_columns ten_bản_muốn_xem; để xem chi tiết cụ thể cái bảng chứa bao nhiêu trường
exec sp_columns tblTravels;



select * from tblCategories; -- kiểm tra tên bảng này có được dùng chưa
--Danh mục các sản phẩm dịch vụ (các chủ đề: đi chơi, đi nghỉ dưỡng, thám hiểm,...)
Drop table tblCategories
Create table tblCategories(
	id int Primary Key Not Null Identity (1,3), --start from 1, icrease 3 -- Bắt đầu từ 1 và tăng lên 3 đơn vị -- là khóa chính
	name nvarchar (250) Not Null,
	numberOfTravels int Check(numberOfTravels >= 0) Not Null Default 0
);
-- kiểm tra cụ thể các thông tin trong cái bảng có được tạo đúng như yêu cầu hay chưa
exec sp_columns tblCategories;

Insert into tblCategories(name) values ('Family travels')
Insert into tblCategories(name) values ('Beaches travels')
Insert into tblCategories(name) values ('Food & drinks travels')

--Thêm ràng buộc là tên của category không được trùng lặp
Alter table tblCategories Add Constraint Uc_CategoryName Unique(name);





select * from tblCategories; 
select * from tblTravels; 

Update tblTravels
set categoryId = 1
where id = 1

Update tblTravels
set categoryId = 10
where id = 2

Update tblTravels
set categoryId = 13
where id = 6


--Join 2 table lại với nhau: tblCategories and tblTravels 
--(inner join lấy toàn bộ dữ liệu của 2 bảng vào và đối với các giá trịn null của 2 bảng thì sẽ bị loại bỏ ra)
			--1				--n
Select tblCategories.id as categoryId, 
tblCategories.name as categoryName,
tblTravels.name as travelName,
tblTravels.numberOfDays,
tblTravels.price as travelPrice,
tblTravels.startDate
--sử dụng bí danh để phân biệt các cột cho dễ
from tblCategories 
Inner Join tblTravels 
on tblCategories.id = tblTravels.categoryId
-- Ngoài ra có thể Orderby sắp xếp theo thứ tự A->Z
Order By categoryName;


-- Có thể dùng alias để gói ghém lại thành 1 từ khóa cho dễ gọi dễ sử dụng
Select viewCategoriesTravels.* from (
Select tblCategories.id as categoryId, 
tblCategories.name as categoryName,
tblTravels.name as travelName,
tblTravels.numberOfDays,
tblTravels.price as travelPrice,
tblTravels.startDate
--sử dụng bí danh để phân biệt các cột cho dễ
from tblCategories 
Inner Join tblTravels 
on tblCategories.id = tblTravels.categoryId
) as viewCategoriesTravels;


-- Trong bảng travel có nhiều thằng trùng categoryId nhau, khi gộp 2 bảng lại thì Mình dùng group by để nhóm lại

Select Count(viewCategoriesTravels.travelId) as numberOfTravels, 
ViewCategoriesTravels.categoryName from (
Select tblCategories.id as categoryId, 
tblCategories.name as categoryName,
tblTravels.id as travelId,
tblTravels.name as travelName,
tblTravels.numberOfDays,
tblTravels.price as travelPrice,
tblTravels.startDate
--sử dụng bí danh để phân biệt các cột cho dễ
from tblCategories 
Inner Join tblTravels 
on tblCategories.id = tblTravels.categoryId
-- Ngoài ra có thể Orderby sắp xếp theo thứ tự A->Z
) as viewCategoriesTravels
Group by viewCategoriesTravels.categoryName
;


--Nhóm các category trùng nhau trong bảng travel
select Count(id) as numberOfTravels, categoryId
From tblTravels Group By categoryId


-- giời muốn join 2 bảng csdl 1 bảng (đã được count và group by ở trên) với bảng tblCategories
-- 1 bảng đã gộp
select 
	travelsByCategories.*, 
	tblCategories.*
From (
	Select Count(id) as numberOfTravels, 
						categoryId
	From tblTravels Group By categoryId) as travelsByCategories
Inner Join tblCategories
On travelsByCategories.categoryId = tblCategories.id
Order by tblCategories.id;

-- cũng tương tự tính năng ở trên nhưng giờ đây lấy ít hơn không lây hết
-- nhưng dùng alias nhìn đẹp hơn lấy ra id và name của category và lấy cái numberOfTravels của travel đã được groupby

select
	tblCategories.id as categoryId,
	tblCategories.name as categoryName,
	travelsByCategories.numberOfTravels
From (
	Select Count(id) as numberOfTravels, categoryId
	From tblTravels Group By categoryId) 
		as travelsByCategories
Inner Join tblCategories -- chỗ này là bảng sẽ được join
On travelsByCategories.categoryId = tblCategories.id -- bảng này là bảng đem đi join
Order by tblCategories.id;

--Để hiểu kỹ hơn nên chạy từ trong ra ngoài, thay vì chạy hết 1 lần 1 khối

Create View viewCategoryAndNumberOfTravels As 
select
	tblCategories.id as categoryId,
	tblCategories.name as categoryName,
	travelsByCategories.numberOfTravels
From (
	Select Count(id) as numberOfTravels, categoryId
	From tblTravels Group By categoryId) 
		as travelsByCategories
Inner Join tblCategories -- chỗ này là bảng sẽ được join
On travelsByCategories.categoryId = tblCategories.id
--Select view
Select * from viewCategoryAndNumberOfTravels;

Update tblCategories Set tblCategories.numberOfTravels = viewCategoryAndNumberOfTravels.numberOfTravels
From tblCategories
Inner Join viewCategoryAndNumberOfTravels
On tblCategories.id = viewCategoryAndNumberOfTravels.categoryId

Select * from tblCategories
select * from tblTravels


-- Increase price to 10% if numberOfDays >= 19
-- Tăng giá 10% đối với các chuyến dài ngày cụ thể là numberOfDays >= 19 (100% = 1 => 10% của 1 là 0.1) => 1 + 0.1

-- Giải quyết dùng lệnh update
Update tblTravels 
set price = 1.1*tblTravels.price 
where tblTravels.numberOfDays >= 19

-- Tương tự giảm giá 20% với các chuyến ngắn ngày cụ thể là numberOfDays <= 12  (100% = 1 => 20% của 1 là 0.2) => 1 + 0.2
-- Giải quyết dùng lệnh update

Update tblTravels 
set price = 1.2*tblTravels.price 
where tblTravels.numberOfDays <= 12

-- Tăng 15% đối với những chuyên từ viet nam sang sing và đồng thời chuyến đó phải bằng 17 ngày
-- Điều kiện tblTravels.numberOfDays = 17 and tblCategories.name = "Food & drinks travels"
-- quy về id đối với các bảng nằm ngoài để cho dễ lập điều kiện tại vì đó là khóa ngoại
Update tblTravels
set price = 1.15*tblTravels.price 
where tblTravels.numberOfDays = 17 and tblTravels.categoryId = 13

--Trigger
Drop Trigger triggerTravelsUpdate
Create Trigger triggerTravelsUpdate on tblTravels
After Update as
Begin 
	Declare @newPrice as numeric(14,2);
	Select @newPrice = inserted.price from inserted;
	if @newPrice < 0.0
	Begin
		Raiserror(N'Price must be >= 0', 
		10, 
		1
		);
		RollBack Transaction;
	End
End
Select * from tblCategories;
Select * from tblTravels
--test trigger
Update tblTravels Set price = -1.0 where id=6;


--After insert data tblTravels, startDate must >= "Current date"
-- sau khi nạp dữ liệu vào bảng điều kiện ngày bắt đầu phải lớn hơn hoặc bằng ngày hiện tại.
-- let's use trigger (sử dụng trigger)
Drop trigger triggerInsertTravels
Create trigger triggerInsertTravels on tblTravels
After insert as 
Begin
	Declare @newStartDate As Date;
	Select @newStartDate = inserted.startDate from inserted;
	If @newStartDate < GETDATE()
	Begin 
		RaisError(N'Start Date must be after the current date', 10, 1);
		RollBack transaction;
	End
End

--Test trigger
select * from tblCategories
select * from tblTravels

--lỗi ngay vì vi phạm trigger ngày đang được set nó nhỏ hơn ngày hiện tại làm sao kiểm tra ngày hiện tại chạy lệnh Select GETDATE()
Insert into tblTravels (name, price, numberOfDays, startDate, categoryId)
Values ('go to Germance', 1234.5, 12, '2017-12-30', 13)

--success vì ngày hiện tại 02-08-2022
Insert into tblTravels (name, price, numberOfDays, startDate, categoryId)
Values ('go to Germance', 1234.5, 12, '2025-12-30', 13)




