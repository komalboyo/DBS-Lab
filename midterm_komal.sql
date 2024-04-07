CREATE TABLE Customer(
cid int,
cname varchar(10),
address varchar(20),
incomegroup varchar(10));

alter table customer add constraint c1 primary key(cid);

CREATE TABLE Sales(
sid int,
dop date,
cid int,
item varchar(20),
qty int,
unitprice int ,
primary key (sid),
foreign key (cid) references customer);

insert into customer values(1, 'Anand', 'Main Road Manipal', 'High');
insert into customer values(2, 'Mohan', 'Tiger Circle Manipal', 'Medium');
insert into customer values(3, 'Jacob', 'Main Road Udupi', 'Medium');

insert into sales values(101, '27-jan-2023',1,'Sugar',10, 50);
insert into sales values(102, '20-dec-2022',2,'Rice',5, 40);
insert into sales values(103, '12-nov-2022',3,'Oil',1, 150);
insert into sales values(104, '25-dec-2022',1,'Rice',2, 40);
insert into sales values(105, '21-nov-2022',1,'Oil',2, 150);

select * from customer where address like '%Manipal%';

with date_order(cid, price) as
(select cid, qty*unitprice price from sales)
select sum(price) from date_order where cid=2 group by cid;

select distinct cname
from sales s, customer c 
where s.cid =c.cid and not exists ((select distinct x.item from sales x) minus
(select distinct t.item from sales t where s.cid=t.cid));




