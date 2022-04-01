create table if not exists Suppliers (
 sid serial primary key,
 sname text,
 address text
);

create table if not exists Parts (
 pid serial primary key,
 pname text,
 color text
);

create table if not exists Catalog_ (
 sid int,
 pid int,
 cost real,
 primary key (sid, pid)
);


insert into Suppliers (sname, address) values 
 ('Yosemite Sham', 'Devil’s canyon, AZ'), 
 ('Wiley E. Coyote', 'RR Asylum, NV'), 
 ('Elmer Fudd', 'Carrot Patch, MN');
 
insert into Parts (pname, color) values 
 ('Red1', 'Red'),
 ('Red2', 'Red'),
 ('Green1', 'Green'),
 ('Blue1', 'Blue'),
 ('Red3', 'Red');

insert into Catalog_ (sid, pid, cost) values 
 (1, 1, 10.00),
 (1, 2, 20.00),
 (1, 3, 30.00),
 (1, 4, 40.00),
 (1, 5, 50.00),
 (2, 1, 9.00),
 (2, 3, 34.00),
 (2, 5, 48.00);

select distinct sid from Parts
join Catalog_ on Catalog_.pid = Parts.pid
join Suppliers on Catalog_.sid = Suppliers.sid 
where Parts.color = 'Red';

select distinct sid from Parts
join Catalog_ on Catalog_.pid = Parts.pid
join Suppliers on Catalog_.sid = Suppliers.sid 
where Parts.color = 'Red' or Parts.color = 'Green';

select distinct sid from Parts
join Catalog_ on Catalog_.pid = Parts.pid
join Suppliers on Catalog_.sid = Suppliers.sid 
where Parts.color = 'Red' or Suppliers.address = '221 Packer Street';
  
select sid from Suppliers
except
select distinct sid from (
 select sid, pid from Suppliers, Parts
 where Parts.color = 'Red' or Parts.color = 'Green'
 except 
 select sid, pid from Catalog_ 
) as s1;


select sid from Suppliers 
except (
 select distinct sid from (
  select sid, pid from Suppliers, Parts
  where Parts.color = 'Red'
  except 
  select sid, pid from Catalog_
 ) as s1
 intersect
 select distinct sid from (
  select sid, pid from Suppliers, Parts
  where Parts.color = 'Green'
  except 
  select sid, pid from Catalog_
 ) as s2
);

select c1.sid, c2.sid from Catalog_ c1, Catalog_ c2
where c1.cost > c2.cost and c1.pid = c2.pid;

select pid from (
 select pid, count(sid) as sc from Catalog_ 
 group by pid
) as s1
where sc > 1;

select 
 sid, 
 avg(cost) filter (where Parts.color = 'Red') as avg_red, 
 avg(cost) filter (where Parts.color = 'Green') as avg_green,
 avg(cost) filter (where Parts.color = 'Red' or Parts.color = 'Green') as avg_red_green
from Catalog_ 
join Parts on Parts.pid = Catalog_.pid
group by sid;
 
select distinct sid
from Catalog_
where Catalog_.cost >= 50