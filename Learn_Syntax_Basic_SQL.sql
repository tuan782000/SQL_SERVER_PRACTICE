--create database sqltutorials;

--cú pháp tạo databse
CREATE DATABASE sqltutorials;

-- cú pháp sử dụng
use sqltutorials

-- cú pháp tạo bảng
Create table Customers (
	CustomerId int Not Null IDENTITY PRIMARY KEY,
	CustomerName varchar(300),
	Address varchar(100),
	Phone varchar(20),
	City varchar(150),
	Country varchar(200),
)
--1 customer có nhiều orders

-- sau khi tạo bảng thì cú pháp thêm dữ liệu vào bảng như sau
INSERT INTO Customers (CustomerName, Address, Phone, City, Country)
VALUES ('Thomas', '822/37 Adware 2', '0778748901', 'Ho Chi Minh ','Viet Nam');

INSERT INTO Customers (CustomerName, Address, Phone, City, Country)
VALUES ('Maria', '82/37 Adware 2', '0778748901', 'Ohio ','American');

INSERT INTO Customers (CustomerName, Address, Phone, City, Country)
VALUES ('Kesima', '822/37 Adware 2', '0778748901', 'Tokyo ','Japan');

INSERT INTO Customers (CustomerName, Address, Phone, City, Country)
VALUES ('Kapsune', '822/37 Adware 2', '0778748901', 'Bangkok ','ThaiLand');

INSERT INTO Customers (CustomerName, Address, Phone, City, Country)
VALUES ('Tuan', '822/37 Adware 2', '0778748906', 'Ho Chi Minh ','Viet Nam');

INSERT INTO Customers (CustomerName, Address, Phone, City, Country)
VALUES ('Thomas', '822/37 Adware 2', '0778748901', 'Texas','American');

INSERT INTO Customers (CustomerName, Address, Phone, City, Country)
VALUES (null, null, null, null,null);

--Hiển thị tất cả bảng ghi trong customers
Select * from Customers

--Chỉ muốn hiển thị một số các fields (trường) cụ thể. Ví dụ trường name và phone và city

Select CustomerName, Phone, City from Customers

--Hoặc một trường cũng được chẳng hạn như Country
Select Country from Customers

-- Ví dụ chúng ta muốn gộp các trường giống nhau lại thì làm sao?
-- chẳng hạn gộp các country lại 2 ông người mĩ, 3 ông việt nam, 4 ông nhật. 
-- chỉ muốn các thông tin trùng lập được gộp lại.
-- Dùng cú pháp Distinct

Select Distinct (Customers.Country) from Customers

-- Ngoài ra có thể lọc dữ liệu theo điều khiện
-- Bằng cách sử dụng where

Select * from Customers where Country='Viet nam';

-- Ngoài ra ta có thể tự bổ sung thêm điều kiện bằng các toán tử như AND và OR

-- And thì phải thỏa hết tất cả thì mới vượt qua được
Select * from Customers where Country='American' And City = 'Texas';


-- Or thì thỏa một trong các điều kiện thì mới vượt qua được
Select * from Customers where Country='American' Or City = 'Texas';


-- Not là loại trừ cái (field) trường đó ra. Có nghãi in kết quả đó ra mà không cần in ra trường đó.
Select * from Customers where Not CustomerId = '1' ;
-- Lấy hết tất cả các id và trừ (loại bỏ) 1 ra không lấy nó ra


-- Order By sắp xếp. theo bảng chữ cái a -> z đối với số cũng vậy
Select * from Customers Order by Country;

-- OrderBy .... Desc sắp xếp, theo bảng chữ cái nhưng ngược lại z -> a đối với số nguyên cũng vậy
Select * from Customers Order by Country Desc;

-- Ví dụ thêm 1 khách hàng mà khác hàng đó có giá trị null,
-- null có nghĩa là thông tin về cái gì đó của khách hàng mà chúng ta chưa có
-- chẳng hạn dưới đây cho null cả country lẫn city
INSERT INTO Customers (CustomerName, Address, Phone, City, Country)
VALUES ('Thomas', '822/37 Adware 2', '0778748901', null, null);

Select * from Customers

-- Để kiểm tra khách hàng trong danh sách có trường country bị null không thì dùng điều kiện where
-- Lưu ý giá trị null thì dùng is không dùng dấu =

Select * from Customers where Country is null

-- tương tự với City 
Select * from Customers where City is null

-- Ngược lại ta cũng có thể lọc ra các khách hàng có đầy đủ thông tin và không show ra các khách hàng có giá trị Null

Select * from Customers where Country is not null And City is not null


--Update record (cập nhật bản ghi)
-- Trước khi update thì phải xác định đúng mục tiêu cần update
Select * from Customers where CustomerId=1;
-- Sau đó thấy được customer cần update thì tiến hành dùng lệnh update
-- set là giá trị sẽ thay đổi 
-- where là điều kiện (tìm tới customer cần chỉnh sửa, làm sao xác định được đối tượng cần sửa)
Update Customers 
Set CustomerName = 'Tom', City = 'Quy Nhon'
Where CustomerId=1


-- Quy định số lượng bảng ghi cần lấy ra. Thí dụ lấy ra 5 hoặc 10 bản ghi cho 1 lần query

--Lấy ra 5 bảng ghi trong 1 lần query
Select Top 5 * from Customers

-- Có thể lấy ra theo % bảng ghi (ví dụ: bảng ghi có tất cả 10, lấy 50% số lượng bảng ghi ra là 5)
Select Top 50 Percent * from Customers

--Lấy ra search
--Like ở đây là tìm trong bảng đó những thằng nào có chứa ký tự giống như điều kiện đặt ra thì lấy ra.
--% là ký tự bất kỳ (%d) các ký tự bất kỳ trước d  
--(%m) các ký từ trước m đều được sau m thì không
--(a%) các ký tự bất kỳ sau a, trước nó a thì không thỏa điều kiện
-- nếu không quan trọng trước sau thì %a%
Select * from Customers Where CustomerName Like 'm%'

Select * from Customers Where CustomerName Like '%a'

Select * from Customers Where CustomerName Like '%a%'

--Tìm ra các cái tên có ít nhất 2 ký tự trở lên 
--Đây là những ví dụ trường hợp sẽ thỏa mãn với câu query dưới (Leona Messi, Ciristia Ronaldo, Thmomas Eddy, Ha Long)
Select * from Customers Where CustomerName Like '%_%_%'

-- Tìm ra các khách hàng có chữ cái là liên quan trong các từ sau.
-- những khách hàng có ký tự trong chữ đầu tiên là ace thì sẽ được chọn ra, vần A Vần C Vần E là thỏa điều kiện
Select * from customers where CustomerName like '[ace]%'

-- Ngoài ra chúng ta cũng có thể sử dụng để lọc ra từ vị trí bắt đầu đến vị trí kết thúc
-- '[a-e]%' chữ cái từ a đến e, % trước nó là những ký tự bất kỳ

-- Lọc ra những người có chữ cái đầu tiên từ a đến e
Select * from customers where CustomerName like '[a-e]%'

-- Ngoải ra chúng ta có thể đảo nghịch nó là không tìm những người có tên '[a-e%]'
Select * from customers where CustomerName Not like '[a-e]%'

-- Muốn lấy ra những khách hàng những nước và thuộc vietnam và mỹ
-- từ khóa in là các tập hợp bên trong
select * from Customers where Country in ('Viet Nam', 'American')


-- Bảng nhà cung cấp - Suppliers (nhà cung cấp)
-- 1 nhà cung cấp có thể cung cấp nhiều sản phẩm (Mối quan hệ một nhiều)
-- nhà cung cấp (1) --- sản phẩm (n)
Create Table Suppliers (
	SupplierId int Not Null IDENTITY PRIMARY KEY,
	SupplierName varchar(400),
	ContactName varchar(400),
	Address varchar(1000),
	Phone varchar(20),
	City varchar(150),
	Country varchar(200),
)

-- Nhà cung cấp sẽ là nơi cung cấp hàng hóa cho mình

-- Sau đó liên hệ nhà cung cấp nhập hàng về
-- Câu lệnh SELECT * FROM Sys.Tables; sẽ trả về danh sách tất cả các bảng trong cơ sở dữ liệu hiện tại.
-- List all tables in your database: Đưa ra danh sách tất cả các dữ liệu trong bảng.
Select * from Sys.Tables;

INSERT INTO Suppliers(SupplierName, ContactName, Address, Phone, City, Country)
Values('Exotic Liquid', 'Charlotte Cooper', '49 Gilbert St.', '020 7424 4000', 'London', 'UK')

--Muốn để dấu nháy ' trong chuỗi thì thêm 2 dấu nháy '' sẽ được 1 dấu nháy
INSERT INTO Suppliers(SupplierName, ContactName, Address, Phone, City, Country)
Values('New Orleans Cajun Delight ''s', 'Shelley Burke', 'P.O. Box 78934', '504 555 6534', 'New Orleans', 'USA')
INSERT INTO Suppliers(SupplierName, ContactName, Address, Phone, City, Country)
Values('Grandma Kellys Homestead', 'Regina Murphy', '123 Main St.', '312 555 1212', 'Chicago', 'USA')

INSERT INTO Suppliers(SupplierName, ContactName, Address, Phone, City, Country)
Values('Tokyo Traders', 'Yoshi Tanaka', '1-2-3 Shinjuku', '03 3333 4444', 'Tokyo', 'Japan')
INSERT INTO Suppliers(SupplierName, ContactName, Address, Phone, City, Country)
Values('China Tea Company', 'Wei Lee', '34 Main St.', '212 555 1212', 'New York', 'USA')
INSERT INTO Suppliers(SupplierName, ContactName, Address, Phone, City, Country)
Values('Coffee Beanery', 'John Smith', '123 Elm St.', '408 555 1212', 'San Jose', 'USA')
INSERT INTO Suppliers(SupplierName, ContactName, Address, Phone, City, Country)
Values('The Spice Merchant', 'Sally Jones', '567 Pine St.', '650 555 1212', 'Mountain View', 'USA')


INSERT INTO Suppliers(SupplierName, ContactName, Address, Phone, City, Country)
Values(null, null, null, null, null, null)

Select * from Suppliers


-- Category danh mục sản phẩm
Create Table Categories (
	CategoryId int not null Identity primary key,
	CategoryName varchar(400),
	Description text
);

-- cú pháp update
Update Categories
Set CategoryName = 'Books', Description = 'This category includes all types of books, such as novels, non-fiction, children''s books, etc.'
where CategoryId=4;

INSERT INTO Categories(CategoryName, Description)
Values('Fashion', 'This category includes all types of clothing, shoes, accessories, etc.')

INSERT INTO Categories(CategoryName, Description)
Values('Toys', 'This category includes all types of toys, such as dolls, cars, puzzles, etc.')

INSERT INTO Categories(CategoryName, Description)
Values('Books', 'This category includes all types of books, such as novels, non-fiction, children''s books, etc.')

INSERT INTO Categories(CategoryName, Description)
Values(null, null)

Select * from Categories


Select * from Sys.Tables;

 Create table Products (
	ProductId int not null Identity primary key,
	ProductName varchar(400),
	SupplierId int,
	CategoryId int,
	Unit varchar(250),
	Price float,
 )

 Select * from Products

 --Tạo 1 lúc nhiều dòng
 INSERT INTO Products (ProductName, SupplierId, CategoryId, Unit, Price)
VALUES
('iPhone 13 Pro Max', 1, 1, 'Tech', 1299),
('Galaxy S22 Ultra', 2, 1, 'Tech', 1199),
('MacBook Pro 14" M1 Pro', 3, 2, 'Tech', 1999),
('iPad Pro 12.9" M1', 4, 2, 'Tech', 1099),
('Surface Laptop Studio', 5, 3, 'Tech', 1599),
('Dell XPS 13', 6, 3, 'Tech', 999),
('Lenovo ThinkPad X1 Carbon', 7, 3, 'Tech', 1299),
('Samsung Galaxy Watch 4', 1, 4, 'Tech', 299),
('Apple Watch Series 7', 2, 4, 'Tech', 399);


INSERT INTO Products (ProductName, SupplierId, CategoryId, Unit, Price)
VALUES(null, null, null, null, null)


--Products có 2 cái khóa ngoại SupplierId, CategoryId

Select * from Products where CategoryId=4

Select * from Products where SupplierId=7


--Kiểm tra giá cả
-- Hiện mỗi giá và tên
Select ProductName, Price From Products 

-- sắp xếp theo giá trị tăng dần, hiển thị tên sản phẩm và giá
select ProductName, Price from Products Order by Price;

--sắp xếp theo thứ tự giảm dần, hiển thị tên sản phẩm và giá
select ProductName, Price from Products Order by Price Desc;


-- Tìm ra sản phẩm có giá lớn nhất
select Max(price) from Products

-- Tìm ra sản phẩm có giá lớn nhất và Để kèm theo tên và giá 
SELECT ProductName, Price
FROM Products
WHERE Price = (SELECT MAX(Price) FROM Products);


-- Tìm ra sản phẩm có giá nhỏ nhất
select Min(price) from Products

-- Tìm ra sản phẩm có giá nhỏ nhất và Để kèm theo tên và giá 
SELECT ProductName, Price
FROM Products
WHERE Price = (SELECT Min(Price) FROM Products);


-- Tính trung bình cộng số đơn hàng
Select AVG(Price) from Products

-- AVG(Price) này sẽ là không tên dùng as viết tắt của từ alias để đặt bí danh cho nó là "Average"
-- chúng ta có thể đặt bí danh cho một cột không có tên
Select AVG(Price) as "Average" from Products


-- Tính tổng giá trị đơn hàng (Tạo 1 cột có tên giả Sum: chứa dữ liệu tính tổng được)
Select SUM(Price) as "Sum" from Products

--Tính tổng tiền của tất cả sản phẩm và đồng thời tính tổng số lượng sản phẩm có trong Database
-- Sum là cộng, Count là đếm
Select SUM(Price) as "Sum", Count(*) as "Number of Products" From Products


-- Gộp bảng Join bảng 

-- Join nội bộ (INNER JOIN): Loại join này trả về tất cả các hàng từ cả hai bảng, 
--chỉ khi các hàng có giá trị khớp trong khóa ngoại của bảng bên trái với khóa chính của bảng bên phải.

--Đoạn mã này sẽ chọn tất cả các cột từ cả bảng Categories và bảng Products. Từ khóa * được sử dụng để chọn tất cả các cột từ một bảng. 
Select Categories.*, Products.* 
From Categories
--Từ khóa INNER JOIN được sử dụng để nối hai bảng theo cột CategoryId. 
Inner JOIN Products ON Categories.CategoryId=Products.CategoryId
--Điều này có nghĩa là chỉ các hàng trong đó cột CategoryId trong bảng Categories bằng với 
--cột CategoryId trong bảng Products sẽ được trả về.

-- Kết quả của truy vấn sẽ là một bảng với tất cả các cột từ cả bảng Categories và bảng Products. 
--Các hàng trong bảng kết quả sẽ là các hàng có giá trị CategoryId khớp nhau trong hai bảng.

-- Lấy ra tất cả các giá trị tồn tại cả trong bảng categories và bảng product
-- Đảm bảo có giá trị lấy ra làm join phải giống nhau như trong ví dụ này là CategoryId là cái phần ON là phần giao nhau


-- Join bên trái (LEFT JOIN): Loại join này trả về tất cả các hàng từ bảng bên trái, 
--ngay cả khi không có hàng khớp trong bảng bên phải. 
--Các hàng không có hàng khớp trong bảng bên phải sẽ được trả về với giá trị null cho các cột từ bảng bên phải.

--Left Join 1-n

Select Categories.*, Products.*
From Categories
Left Join Products On Categories.CategoryId=Products.CategoryId
Order By Categories.CategoryId

-- Bảng Categories nằm phía tay trái và products nằm phía tay phải
-- Riêng cái CategoryId là điểm chung sẽ xuất hiện đầu tiên. Sau đó bắt đầu Categories rồi mới đến Products
-- Lấy ra các records tồn tại bên trong ("Categories" và "Products") hoặc Categories



-- Join bên phải (RIGHT JOIN): Loại join này trả về tất cả các hàng từ bảng bên phải, 
-- ngay cả khi không có hàng khớp trong bảng bên trái. 
-- Các hàng không có hàng khớp trong bảng bên trái sẽ được trả về với giá trị null cho các cột từ bảng bên trái.

Select Categories.*, Products.*
From Categories
Right Join Products On Categories.CategoryId=Products.CategoryId
Order By Categories.CategoryId

-- Lấy ra các records tồn tại bên trong ("Categories" và "Products") hoặc Products


-- Join toàn bộ (FULL JOIN): Loại join này trả về tất cả các hàng từ cả hai bảng, ngay cả khi không có hàng khớp trong khóa ngoại của bảng bên trái với khóa chính của bảng bên phải.

Select Categories.*, Products.*
From Categories
Full Outer Join Products On Categories.CategoryId=Products.CategoryId
Order By Categories.CategoryId

--Giúp tìm kiếm cái sản phẩm nào chưa thuộc category hoặc ngược lại cái category nào chưa có sản phẩm.


-- Join toàn bộ (Full join) Trả về tất cả các hàng từ cả hai bảng, ngay cả khi không có hàng khớp trong khóa ngoại của bảng bên trái với khóa chính của bảng bên phải.


--union ? Gộp (bảng nhà cung cấp Suppliers là có cột country và bảng Customer cũng có cái cột country)
-- Nhưng 2 cái country này nó không liên quan gì tới nhau thành ra chỉ gộp lại để xem thử đã bao phủ được bao nhiêu quốc gia

select Customers.Country from Customers
Union
select Suppliers.Country from Suppliers
Order by Country

--Order By sắp xếp các chữ cái theo dạng a->z
-- Giúp xem được phủ kín được bao nhiêu quốc gia tập khách hàng và nhà cung cấp


Select COUNT (Customers.CustomerId), Customers.Country
From Customers
Group by Customers.Country
Having Customers.Country is Not null;


--exists
Select Suppliers.*
from Suppliers
Where EXISTS (Select ProductName From Products Where Products.SupplierId = Suppliers.SupplierId And Price > 1000);

--EXISTS sẽ phải có ít nhất 1 bảng ghi trong kết quả thì cấu lệnh này mới chạy
-- Tìm các cái nhà cung cấp, cung cấp các sản phẩm trên 1000


-- Ngoải ra có cung cấp nhân bảng 1 cái bảng lên
Select Products.* Into ProductsBackup from Products;
-- giống chép ra 1 bảng tương tự products và chúng ta sẽ thao tác trên bảng này. Nếu mà tình huống xấu thì dữ liệu cũng sẽ không bị mất
Select * From ProductsBackup

-- Chúng ta cũng có thể lưu được các khách hàng cụ thể vào 1 backup
-- Cụ thể lưu khách hàng đến từ vùng USA vào trong bảng CustomersBackup (bảng này là bảng ảo, nó sao chép tương tự Customers)
--Nạp giá trị Customers vào CustomersBackup kèm điều kiện (phân biệt dữ liệu nào có thể được đi vào)
Select Customers.* Into CustomersBackup from Customers where Customers.Country='Viet Nam';

--Sử dụng dữ liệu của bảng sau khi clone ra
Select * from CustomersBackup

--Câu lệnh xóa bảng (dùng xong thì xóa cho đở rác)
Drop table CustomersBackup

-- Có thể áp dụng làm Khách hàng Vip

-- Đặt câu hỏi làm sao clone bảng ra mà không lấy dữ liệu từ bảng đó qua (where bắt buộc phải false, để không lấy dữ liệu qua)
Select Customers.* Into CustomersBackup2 from Customers where 2=3;

Select * from CustomersBackup2

Drop table CustomersBackup2

-- Thí dụ tạo ra bảng clone và bảng clone lấy 2 trường thui chằng hạn product name và price không lấy trường khác
Insert into ProductsBackup(ProductName, Price)
Select Products.ProductName, Products.Price From Products;

select * from ProductsBackup

Drop table ProductsBackup


select * from Categories
select * from Customers
select * from Products
select * from Suppliers


--Hiện tương đối 1 giá trị nào đó
--case when
Select Products.*,
Case
	When Products.Price > 100.0 then 'Price: greater than 100'
	When Products.Price > 15 then 'Price: greater than 15'
	Else 'Price: under 15'
END AS TextPrice
From Products;

-- Hiện giá text thể hiện độ tương đối là sản phẩm giá khoảng bao nhiêu tiền
-- AS là tạo tên cho cột đó 


-- 1 người khách hàng có thể có nhiều order
-- 1 shiper có thể giao nhiều đơn hàng


Create Table Orders (
	OrderId int not null identity primary key,
	CustomerId int,
	EmployeeId int,
	OrderDate datetime,
	ShipperId int
)
-- 1 order có nhiều orderdetails


Create Table Shippers (
	ShipperId int not null identity primary key,
	ShipperName varchar(400),
	Phone varchar(20),
	Description text
)
--1 shipper có thể ship nhiều order

INSERT INTO Shippers (ShipperName, Phone, Description)
VALUES
('FedEx', '1-800-593-5289', 'FedEx is a shipping company that specializes in overnight delivery.'),
('UPS', '1-800-742-5877', 'UPS is a shipping company that specializes in ground delivery.'),
('DHL', '1-800-225-5345', 'DHL is a shipping company that specializes in international delivery.');

Select * from Shippers

Create Table OrderDetails (
	OrderDetailId int not null identity primary key,
	OrderId int,
	ProductId int,
	Quantity int
)

Create Table Employees (
	EmployeeId int not null identity primary key,
	FullName varchar (400),
	DateOfBirth datetime,
	Notes text
)
--1 nhân viên có thểm chăm sóc được nhiều order

Select * From sys.tables
