-- Muốn sử dụng tiếng việ có dấu trong cơ sở dữ liệu phải thêm nvarchar cho tiếng việt hoặc trung... UTF-8

--Xem lại các bảng đã tạo
Select * from sys.tables

Select * from Employees

--Drop Table Employees

--1 dannh mục sản phẩm có nhiều sản phẩm
-- Chính vì vậy phải làm 1 cái constraints là ràng buộc dữ liệu, cụ thể là danh mục sản phẩm với bảng sản phẩm

-- Có 2 cách tạo ràng buộc
-- 2.1 Là tạo ngay lúc tạo bảng

--Drop table Products
select * from Products

 Create table Products (
	ProductId int not null Identity primary key,
	ProductName varchar(400),
	SupplierId int,
	CategoryId int,
	Unit varchar(250),
	Price float,

	-- Có nghĩa trong bảng Products có trường (filed) CategoryId, trường CategoryId cho ta biết sản phẩm thuộc danh mục nào

	--Đây là rang buộc khóa ngoại (1 Category has N Products)
	constraint fk_CategoryProduct
	foreign key (CategoryId)
	references Categories(CategoryId)
 )

 -- Test xem đã nối tới bảng danh mục chưa.

 Select * from Categories; 
 -- trường hợp CategoryId 4 có tồn tại thì insert được product vào
 INSERT INTO Products(ProductName,SupplierID,CategoryID,Unit,Price) VALUES('Chocolade', 2,4,'boxes', 12);

  -- trường hợp CategoryId 6 không có tồn tại thì không insert được product vào
 INSERT INTO Products(ProductName,SupplierID,CategoryID,Unit,Price) VALUES('Ipad mini 2014', 2,6,'pieces', 712.35);
 -- sẽ báo lỗi là vi phạm ràng buộc.

 --CategoryID - là - 4
  Select * from Categories where CategoryID = 4; 

-- 2.2 Là update lại bảng

-- Đây là cách không cần xóa bảng product mà vẫn có thể nối ràng buộc bảng Products với bảng Categories
Alter table Products --chỉ đạnh bảng sẽ nối
Add Constraint fk_CategoryProduct -- tên bảng sẽ nối tới
Foreign key (CategoryId) References Categories(CategoryId) -- đặt khóa ngoại của bảng Products là CategoryId đến CategoryId của bảng Categories 

--constraints ngoài tác dụng nối FK còn cung cấp thêm tính năng check, giúp rang buộc thêm cả dữ liệu đầy vào
Alter table Products
Add Constraint Check_Product
Check (Price >= 0 And Price <= 2000) -- Bắt buộc giá của sản phẩm phải lớn hơn hoặc bằng 0 và nhỏ hơn hoặc bằng 2000

--Nếu không muốn sử dụng check nữa thì dùng cách sau
ALTER TABLE Products
DROP CONSTRAINT Check_Product;


--test constraints
--lỗi vì Price vượt qua 2000
INSERT INTO Products(ProductName,SupplierID,CategoryID,Unit,Price) VALUES('Macbook pro 15.4 inches 2017', 2,6,'boxes', 2200);

-- Nhưng nếu Price nằm trong ngưỡng thì sẽ được
-- Thành công
INSERT INTO Products(ProductName,SupplierID,CategoryID,Unit,Price) VALUES('Japanese seafood sushi', 7,2,'dishes', 25.5);


-- Tính năng thứ 3 của constraints là unique(tồn tại duy nhất một mình nó, độc nhất vô nhị) 
Alter table Products
Add Constraint UN_Product unique (ProductName)

--test constraints
--Kiểm tra sản phẩm trong db
select * from Products
--Lỗi vì đã insert trùng tên sản phẩm
INSERT INTO Products(ProductName,SupplierID,CategoryID,Unit,Price) VALUES('Japanese seafood sushi', 7,2,'dishes', 25.5);

-- thành công (tên này chưa có tồn tại, dẫn đến vượt qua bài test và cho vào trong db)
INSERT INTO Products(ProductName,SupplierID,CategoryID,Unit,Price) VALUES('Beer 555', 3,1,'cups', 12);


-- Tính năng thứ 3 của constraints là datetime(năm tháng ngày) 

INSERT INTO Employees(FullName, DateOfBirth, Notes) VALUES('Margaret Fuller','1994-10-25', 'He is in sales department');
Select * from Employees

--constraints (năm tháng ngày)
Alter table Orders
Add Constraint Of_OrderDate -- vì không có trường Of_OrderDate mình sẽ chữa cháy bằng cách GETDATE hiện tại
Default GETDATE() For OrderDate -- Có nghĩa thêm rang buộc cho Orders là trường OrderDate, thường trường này sẽ không thêm mặc định
-- mà phải dùng Default GETDATE() để lấy thời gian ngay lúc tạo luôn cho tiện.


--test constraints
INSERT INTO Orders(CustomerID,EmployeeID,ShipperID) VALUES(2,1,3); -- chúng ta cố tình bỏ qua trường OrderDate

select * from Orders --Nó vẫn tự set thời gian mặc định năm tháng ngày vào trong

-- Tóm lại constraints: thường có 4 nhiệm vụ chính.
--1 Ràng buộc khóa ngoại
--2 Ràng buộc dữ liệu check, giúp đưa ra một điều kiện để rang buộc dữ liệu đầu vào
--3 Ràng buộc dữ liệu unique, giúp giá trị được Nhập vào tránh bị trùng lập (mặc dù không phải là khóa chính nhưng khi đã ràng buộc vào thì dữ liệu đó nhập vào phải là duy nhất)
--4 Có thể rang buộc năm tháng ngày tự động


--AI tổng hợp:
/*
Một số constraints SQL phổ biến bao gồm:

NOT NULL: Constraints này yêu cầu một cột không thể có giá trị NULL.
UNIQUE: Constraints này yêu cầu tất cả các giá trị trong một cột phải khác nhau.
PRIMARY KEY: Constraints này là một combination của constraint NOT NULL và UNIQUE. Nó chỉ định một cột hoặc một nhóm các cột là duy nhất và xác định một hàng trong bảng.
FOREIGN KEY: Constraints này xác định một mối quan hệ giữa hai bảng. Nó chỉ định rằng một giá trị trong một cột phải khớp với một giá trị trong một cột khác.
*/


--Triggers, 

--Trigger là một khối mã được thực thi tự động khi một sự kiện nhất định xảy ra đối với một bảng. 
--Sự kiện có thể là chèn, cập nhật hoặc xóa một hàng. 
--Trigger có thể được sử dụng để thực hiện một số nhiệm vụ, chẳng hạn như:

/*
CREATE TRIGGER my_trigger
ON my_table
AFTER INSERT
AS
BEGIN

 -- Insert code to be executed after an insert operation.

END

Trigger này sẽ được thực thi sau khi mỗi lần chèn một hàng vào bảng my_table.


Trigger có thể là một công cụ mạnh mẽ để quản lý dữ liệu trong cơ sở dữ liệu. 
Tuy nhiên, điều quan trọng cần lưu ý là trigger có thể làm chậm hiệu suất của cơ sở dữ liệu. 
Do đó, chỉ nên sử dụng trigger khi thực sự cần thiết.
*/

--Triggers = "function" Các hàm được gọi sau khi insert update delete dữ liệu vảo bảng
-- Tóm lại dùng các câu lệnh tác động vào dữ liệu insert update delete thì triggers function sẽ được kích hoạt



Create trigger trg_UpdateProduct -- khởi tạo trigger sau khi update
On Products After Update As		 -- update sản phẩn thì sẽ chạy triggers này, sau chữ as là toàn bộ nội dung của triggers 
Declare @price as Float			 -- Declare khai báo biến trong triggers
Set @price = (Select top 1 Price from Products where Price < 0) -- Biến price này sẽ chọn ra giá trị đầu tiên có price bảng ghi là số âm
If @price < 0					 -- Nếu Price âm sẽ vi phạm điều kiện và không cho phép insert nữa
Begin
	Raiserror ('Cannot update negative Price', 16, 10); -- Raiserror là xảy ra lỗi và đo đạc mức độ nghiêm trọng của lỗi 11->20
														-- Raiserror là 16 (11->20)
														-- Mã lỗi là từ 0->255 trong ví dụ này là số 10
	RollBack				-- Quay lại trạng thái trước đó, trước khi cập nhật
End

--test triggers
-- đề: sau khi cho chạy câu lệnh triggers, mình sẽ cập lại 1 bảng ghi sản phẩm có giá là số âm và xem thông báo lỗi
select * from Products
Update Products
Set Price = -2.2
where ProductId=4;

--lỗi trả về Cannot update negative Price Level của lỗi là 16 đúng như triggers đã tạo


-- Bổ sung trường count cho categories, đếm được trong categories có bao nhiêu sản phẩm
-- Alter table chỉnh sửa các trường liên quan đến bổ sung cột, thêm khóa bỏ khóa ngoại,..., chỉnh sửa giá trị varchar nvarchar int,...
-- Update chỉnh sửa nội dung bên trong của dữ liệu được lưu vào trong bảng
Alter table Categories
Add counts int

-- Tất nhiên mới tạo sẽ có nội dung là null

-- sau khi thêm kiểm tra lại
select * from Categories


-- Nhưng mà null sẽ không có tính toán được nên phải Update lại từng giá trị bên trong cột count là 0 thì mới bắt đầu thực hiện tính toán

Update Categories
Set Categories.counts = 0
Where Categories.counts is null -- để ý dung null phải is

-- Update các cái Categories và set giá trị counts của nó là 0. Điều kiện cứ counts có giá trị là nulls thì phải đổi thành 0 hết

-- Để mà cập nhật trường counts mình sẽ tạo ra 1 triggers

Create trigger trg_InsertProduct --Câu lệnh Create trigger tạo một trigger mới có tên trg_InsertProduct. Trigger này sẽ được kích hoạt sau khi một hàng mới được chèn vào bảng Products.
On Products After insert as --Cụm từ On Products xác định rằng trigger sẽ được kích hoạt trên bảng Products. Cụm từ After insert xác định rằng trigger sẽ được kích hoạt sau khi một hàng mới được chèn vào bảng.
Declare @CategoryId as int --Câu lệnh Declare @CategoryId as int khai báo một biến có tên @CategoryId và đặt nó thành kiểu int.

Begin
	set @CategoryId=(select CategoryId from inserted) 
	-- Câu lệnh set @CategoryId=(select CategoryId from inserted) đặt giá trị của @CategoryId thành giá trị của cột CategoryId trong hàng mới được chèn.
	Update Categories -- Câu lệnh Update Categories cập nhật cột counts trong bảng Categories bằng cách thêm 1.
	Set counts = counts + 1
	where CategoryId = @CategoryId -- Cụm từ where CategoryId = @CategoryId xác định rằng việc cập nhật chỉ nên được áp dụng cho các hàng trong đó cột CategoryId bằng với giá trị của @CategoryId.
end -- Câu lệnh end đánh dấu cuối của trigger.

/*
Trigger này có tác dụng cập nhật cột counts trong bảng Categories bằng cách thêm 1 mỗi khi một hàng mới được chèn vào bảng Products. 
Cột counts trong bảng Categories theo dõi số lượng sản phẩm trong mỗi danh mục. 
Trigger đảm bảo rằng cột counts luôn được cập nhật.
*/

--Test triggers

Select * from Categories
--Nhu cầu đang muốn thêm iphone vào danh mục Electronics có categoryId là 5

-- Sau đó chạy câu lệnh Insert into
INSERT INTO Products(ProductName, SupplierID, CategoryID, Unit, Price)
VALUES('Iphone XS Plus', 2,5,'pieces',233);

Select * from Products


--Triggers Delete
--Mong muốn khi xóa cái product nào đó trong categories thì trường count giảm đi một

Create trigger trg_DeleteProduct
On Products After Delete As
Declare @CategoryId as int
Begin
	set @CategoryId=(select CategoryId from deleted) --deleted là xóa product
	Update Categories
	set counts = counts - 1
	where CategoryId = @CategoryId And counts > 0 -- Điều kiện thực hiện thành công câu lệnh này là CategoryId = @CategoryId và đồng thời counts > 0 là counts phải là số dương không được phép = 0 hay là số âm, tránh trường hợp người ta trừ âm  
end

--test trigger
Select * from Products
Select * from Categories

-- Tiến hành delete để kích hoạt trigger
Delete from Products where ProductId = 1007
-- khi xóa thì bên categories từ 1 sẽ xuống 0
-- Nếu tiếp tục xóa từ 0 xuống -1 sẽ báo lỗi

--procedures, hàm thủ tục

/*
Thủ tục trong SQL là một nhóm các lệnh SQL được lưu trữ dưới một tên. 
Bạn có thể sử dụng thủ tục để thực hiện các tác vụ thường xuyên một cách hiệu quả hơn. 
Ví dụ: bạn có thể tạo một thủ tục để thêm một bản ghi mới vào bảng hoặc để cập nhật bản ghi hiện có.


Hàm này sẽ không trả về giá trị

VIết được nhiều câu lệnh bên trong

*/

Create procedure searchProducts
	@NameContain nvarchar(200)
As
	Select * 
	From Products
	Where ProductName Like '%'+@NameContain+'%';
Go

--Test this procedure?
-- run a procedure, N - Unicode
Execute searchProducts N'japanese'


