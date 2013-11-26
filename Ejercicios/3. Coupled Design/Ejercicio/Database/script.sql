create table CouponDiscount(
	Coupon varchar(50) not null,
	Discount int not null
);

create table "Order"(
	Id int IDENTITY(1,1) not null,
	CouponCode varchar(max) null,
	ItemTotal decimal(10,2) null,
	Total decimal(10,2) null,
);

insert into CouponDiscount values('CHRISTMAS',10);