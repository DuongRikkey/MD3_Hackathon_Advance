create database new_quanlybanhang;
use new_quanlybanhang;
create table if not exists Customers(
customers_id varchar(4) primary key,
name varchar(100),
email varchar(255) unique,
phone varchar(255) unique,
address varchar(255)
);
create table if not exists Orders(
order_id varchar(4) primary key,
customer_id varchar(4),
order_date Date,
total_amount double,
constraint fk_custmomer foreign key (customer_id) references Customers(customers_id)
);
create table if not exists Products(
product_id varchar(4) primary key,
name varchar(255),
description text, 
price double,
status bit(1)
);
create table if not exists Orders_details(
order_id varchar(4),
product_id varchar(4),
quantity int(11),
price double,
primary key(order_id, product_id),
constraint fk_order foreign key(order_id) references Orders(order_id),
constraint fk_product foreign key(product_id) references Products(product_id)
);

-- B2: thêm dữ liệu
insert into customers(customers_id, name, email, phone, address) values
('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984758926', 'Ba Đình, Hà Nội'),
('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904727584', 'Mỹ Châu, Sơn La'),
('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');

insert into products(product_id, name, description, price, status) values
('P001', 'iphone 13 promax', 'bản 512 gb, xanh lá', 22999999, 1),
('P002', 'dell vostro v3510', 'core i5, ram8gb', 14999999, 1),
('P003', 'macbook pro m2', 'cpu i9cpu |8gb|256gb|', 18999999, 1),
('P004', 'apple watch ultra', 'titanium alpine loop small', 18999999, 1),
('P005', 'apple airpods 2', 'spatial audio', 409900, 1);

insert into orders(order_id, customer_id, total_amount, order_date) values
('H001', 'C001', 52999997, str_to_date('22/2/2023', '%d/%c/%Y')),
('H002', 'C001', 80999987, str_to_date('11/3/2023', '%d/%c/%Y')),
('H003', 'C002', 54399958, str_to_date('22/1/2023', '%d/%c/%Y')),
('H004', 'C003', 102999957, str_to_date('14/3/2023', '%d/%c/%Y')),
('H005', 'C003', 80999997, str_to_date('12/3/2023', '%d/%c/%Y')),
('H006', 'C004', 110499994, str_to_date('1/2/2023', '%d/%c/%Y')),
('H007', 'C004', 17999996, str_to_date('29/3/2023', '%d/%c/%Y')),
('H008', 'C004', 29999998, str_to_date('14/2/2023', '%d/%c/%Y')),
('H009', 'C005', 28999999, str_to_date('10/1/2023', '%d/%c/%Y')),
('H010', 'C005', 14999994, str_to_date('1/4/2023', '%d/%c/%Y'));

insert into orders_details(order_id, product_id, price, quantity) values
('H001', 'P002', 14999999, 1),
('H001', 'P004', 18999999, 2),
('H002', 'P001', 22999999, 1),
('H002', 'P003', 28999999, 2),
('H003', 'P004', 18999999, 2),
('H003', 'P005', 40900000, 4),
('H004', 'P002', 14999999, 3),
('H004', 'P003', 28999999, 2),
('H005', 'P001', 22999999, 1),
('H005', 'P003', 28999999, 2),
('H006', 'P005', 40900000, 5),
('H006', 'P002', 14999999, 6),
('H007', 'P004', 18999999, 3),
('H007', 'P001', 22999999, 1),
('H008', 'P002', 14999999, 2),
('H009', 'P003', 28999999, 9),
('H010', 'P003', 28999999, 4),
('H010', 'P001', 22999999, 4);
-- B3: Truy vấn dữ liệu
-- 1. Lấy ra thông tin gồm tên,email,số điện thoại và địa chỉ
select c.name,c.email,c.phone,c.address from Customers as c;
-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng)
select distinct c.name,c.phone,c.address from Customers as c inner join orders as o 
on o.customer_id=c.customers_id 
where o.order_date between '2023-03-01' and '2023-03-31';
-- 3. Tính doanh thu theo từng tháng trong năm 2023
select month(o.order_date) as Month , CONCAT(FORMAT(SUM(o.total_amount ), 0), ' VND') AS Total_Revenue_VND
from orders as o
where year(o.order_date)
group by month(o.order_date)
order by Month ;
-- 4. Thông kê những người không mua hàng trong tháng 2
select c.name, c.address, c.email , c.phone from customers as c left join
orders as o on o.customer_id=c.customers_id and month(o.order_date)=2  where o.customer_id is null 
group by c.name, c.address, c.email , c.phone;
-- Cách 2 
select c.name, c.address, c.email , c.phone from customers as c where c.customers_id not in (
select o.customer_id from orders as o where month(o.order_date)=2 
);

-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra).
select p.product_id,p.name,Sum(od.quantity) as SoldQuantity from ORDERS_DETAILS as od 
join products as p on p.product_id=od.product_id
join orders as o on o.order_id=od.order_id
where month(o.order_date)=3
group by(p.product_id);
-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu 
-- (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).
select c.customers_id, c.name, Sum(o.total_amount) as total_expenditure
from orders as o 
join customers as c on c.customers_id=o.customer_id
where year(o.order_date)=2023
group by c.customers_id, c.name;
-- 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm 
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) .
select c.name as buyer_name, o.total_amount , o.order_date, sum(od.quantity) as total_quantity
from orders as o
join customers as c on c.customers_id=o.customer_id
join orders_details as od on od.order_id=o.order_id
group by o.order_id,c.name,o.total_amount,o.order_date 
having total_quantity>5;

-- - B4: Tạo View, Procedure
-- -- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn 
-- CREATE VIEW InvoiceDetails AS
create view DetailsInvoice as
select c.name as 'Tên khách hàng', c.phone as 'Số điện thoại', c.address as 'Địa chỉ',o.total_amount as'Tổng tiền',o.order_date as 'Ngày tạo đơn'
from customers as c 
join orders as o 
on o.customer_id=c.customers_id;

select* from DetailsInvoice;

 -- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: 
--  tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm 
create view ProductSalesSummarty as
select p.name as 'Tên sản phẩm',
       p.description as 'Mổ tả',
       p.price as 'Giá',
       coalesce(sum(od.quantity),0) as 'Tổng số lượng đã bán ra'
   from products as p
   join orders_details as od on p.product_id=od.product_id
   group by 
     p.product_id,p.name,p.description,p.price;
select*from ProductSalesSummarty;  
-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer
create index idx_phone on Customers (phone);
create index idx_email on Customers (email);
-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
 DELIMITER //
 create procedure GetCustomerInfo(in custormer_newID varchar(4))
 begin
  select* from Customers where customers_id=custormer_newID;
 end //
 DELIMITER ;
 drop procedure GetCustomerInfo;
 call  GetCustomerInfo('C001');
   -- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm
 DELIMITER // 
 create procedure GetAllProduct(in product_id_new varchar(4))
 begin
  select*from products where product_id=product_id_new;
  end //
DELIMITER ;  
 call  GetAllProduct('P001');
 -- 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng
DELIMITER //
create procedure GetInvoicesByCustomer(in customerId_new varchar(4))
begin 
 select* from orders where orders.customer_id=customerId_new;
end // 
DELIMITER //
call GetInvoicesByCustomer('C001');
-- 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo
DELIMITER //
   create procedure createOrder(
     in new_customerId varchar(4),
     in new_totalAmount double,
     in new_orderDate date,
     out neworderId varchar(4)
   )
   begin 
      set neworderid = (
        select concat('h', lpad(coalesce(max(cast(substring(order_id, 2) as unsigned)), 0) + 1, 3, '0'))
        from orders
    );
     insert into orders(order_id,customer_id,total_amount,order_date)
     values(neworderid,new_customerId,new_totalAmount,new_orderDate);
     end //
 DELIMITER ;    
 CALL createOrder('C003', 20555, '2024-05-25', @neworderId);
SELECT @neworderId;
     
-- 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian 
-- cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc
DELIMITER //
create procedure getProductSalesByDateRange(
  in startDate date,
  in endDate date
)
begin
  select
     p.product_id,
     p.name,
     coalesce(sum(od.quantity),0) as quantity_sold
   from 
      orders_details as od
    join products as p on od.product_id=p.product_id
    join orders as o on o.order_id=od.order_id
    where o.order_date between startDate and endDate
    group by p.product_id,p.name; 
    end //
    DELIMITER //
    CALL GetProductSalesByDateRange('2023-01-01','2023-02-01');
-- Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự giảm dần 
-- của tháng đó với tham số vào là tháng và năm cần thống kê.
DELIMITER // 
create procedure getMonthAndYearProductSales(
       in month int,
       in year int
    ) 
begin 
   select
     p.product_id,
     p.name,
     coalesce(sum(od.quantity),0) as quantity_sold
   from 
      orders_details as od
    join products as p on od.product_id=p.product_id
    join orders as o on o.order_id=od.order_id 
    where 
    month(o.order_date)=month and year(o.order_date)=year
    group by
        od.product_id, p.name
    order by 
        quantity_sold DESC;
  end //
DELIMITER ;  
         
call getMonthAndYearProductSales(2,2023);