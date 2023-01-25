use sql_practice;

/*Q1.Write a query to display the columns in a specific order, such as order date,
salesman ID, order number, and purchase amount for all orders.*/

create table orders(ord_no int,purch_amt float,ord_date date,customer_id int,salesman_id int);
insert into orders values(70001,150.5,'2012-10-05',3005,5002),(70009,270.65,'2012-09-10',3001,5005),
						(70002,65.26,'2012-10-05',3002,5001),(70004,110.5,'2012-08-17',3009,5003),
                        (70007,948.5,'2012-09-10',3005,5002),(70005,2400.6,'2012-07-27',3007,5001),
                        (70008,5760,'2012-09-10',3002,5001),(70010,1983.43,'2012-10-10',3004,5006),
                        (70003,2480.4,'2012-10-10',3009,5003),(70012,250.45,'2012-06-27',3008,5002),
                        (70011,75.29,'2012-08-17',3003,5007),(70013,3045.6,'2012-04-25',3002,5001);
select ord_date,salesman_id,ord_no,purch_amt
from orders;


/* 2.From the following table, write a SQL query to locate salespeople who live in the city
of 'Paris'. Return salesperson's name, city.*/

create table city (salesman_id int,name varchar(20),city varchar(20),commission float);
insert into city values(5001,'James Hoog','New York',0.15),(5002,'Nail Knite','Paris',0.13),(5005,'Pit Alex','London',0.11),
				(5006,'Mc Lyon','Paris',0.14),(5007,'Paul Adam','Rome',0.13),(5003,'Lauson Hen','San Jose',0.12);
                
select name from city
where city = 'Paris';

/* Q3.From the following table, write a SQL query to select a range of products whose
price is in the range Rs.200 to Rs.600. Begin and end values are included. Return
pro_id, pro_name, pro_price, and pro_com.*/

create table products(PRO_ID int,PRO_NAME varchar(20),PRO_PRICE float,PRO_COM int);

insert into products values(101,'Motherboard',3200.00,15),(102,'Keyboard',450.00,16),(103,'ZIP drive',250.00,14),(104,'Speaker',550.00,16),
(105,'Monitor',5000.00,11),(106,'DVD drive',900.00,12),(107,'CD drive',800.00,12),(108,'Printer',2600.00,13),(109,'Refill cartridge',350.00,13),
(110,'Mouse',250.00,12);

select PRO_ID,PRO_NAME,PRO_PRICE
from products
where PRO_PRICE between 200 and 600;

/* Q4.From the following table, write a SQL query to find the items whose prices are
higher than or equal to $550. Order the result by product price in descending, then
product name in ascending.*/

select PRO_ID,PRO_NAME,PRO_PRICE
from products
where PRO_PRICE >= 550;
                        
/*Q5.From the following table, write a SQL query to find details of all orders excluding
those with ord_date equal to '2012-09-10' and salesman_id higher than 5005 or
purch_amt greater than 1000.Return ord_no, purch_amt, ord_date, customer_id and
salesman_id.*/

select ord_no,purch_amt,ord_date,customer_id,salesman_id
from orders
where ord_date != '2012-09-10' and (salesman_id < 5005 or purch_amt < 1000);

/*Q6.Create the table world with your schema and find the below queries ! table with countries and population*/

create table countries(name varchar(20),continent varchar(20),area int,population bigint,gdp bigint);
insert into countries values('Afghanistan','Asia',652230,25500100,20343000000),('Albania','Europe',28748,2831741,12960000000),
							('Algeria','Africa',2381741,37100000,188681000000),('Andorra','Europe',468,78115,3712000000),
                            ('Angola','Africa',1246700,20609294,100990000000),('Dominican','Republic Caribbean',48671,9445281,58898000000),
                            ('China','Asia',9596961,1365370000,8358400000000),('Colombia','South America',1141748,47662000,369813000000),
                            ('Comoros','Africa',1862,743798,616000000),('Denmark','Europe',43094,5634437,314889000000),
                            ('Djibouti','Africa',23200,886000,1361000000),('Dominica','Caribbean',751,71293,499000000);
                            
select name, population
from countries
order by population DESC limit 1;

select name, gdp
from countries
order by gdp limit 1;

select name
from countries
where name LIKE '%C';


select name
from countries
where name LIKE 'D%';

select continent, sum(gdp) as cnt_gdp
from countries
group by 1
order by 2 DESC
limit 1;

select continent, sum(gdp) 
from countries
where continent = 'Africa';

select continent, sum(population) as total_population
from countries
group by 1;

select continent,count(name),population
from countries
where population >= 200000000;

/*Q7.7. Problem statement: Suppose we have two table students and course */

create table students(student_id int,
student_name varchar(60) not null,
city varchar(60) not null,
primary key(student_id));

create table course(student_id int,
course_name varchar(60) not null,
Marks int not null,
primary key(student_id),
foreign key(student_id) references students(student_id));

insert into students values(200,'John Doe','Delhi'),
(210,'John Doe','Delhi'),
(220,'Moon ethan','Rajasthan'),
(230,'Jessie','Bangalore'),
(240,'Benbrook','Bihar'),
(250,'Ethan','Bihar'),
(260,'Johnnie','Bangalore'),
(270,'Goh','Delhi'),(380,'John Doe','Delhi'),
(280,'Pavi','Delhi'),
(290,'Sanvi','Rajasthan'),
(300,'Navyaa','Bangalore'),
(310,'Ankul','Bihar'),
(311,'Hitanshi','Bihar'),
(312,'Aayush','Bangalore'),
(313,'Rian','Delhi');

insert into course values(200,'Datascience',75),
(210,'Datascience',75),
(220,'Dataanalyst',80),
(230,'Dataanalyst',80),
(240,'Dataanalyst',84),
(250,'Dataanalyst',50),
(260,'Datascience',80),
(270,'Datascience',99),
(380,'Datascience',45),
(280,'Datascience',78),
(290,'Dataanalyst',78),
(300,'Computer vision',90),
(310,'Computer vision',90),
(311,'Computer vision',75),
(312,'Computer vision',39);

select student_name,max(Marks)
from students s join course c on
s.student_id = c.student_id
group by course_name;

select student_name
from (select student_name,row_number() over (partition by course_name order by marks DESC) as rownum
from students s join course c on
s.student_id = c.student_id)a
where rownum = 3;

select student_name,min(Marks)
from students s join course c on
s.student_id = c.student_id
group by course_name;

select student_name
from (select student_name,row_number() over (partition by course_name order by marks ASC) as rownum
from students s join course c on
s.student_id = c.student_id)a
where rownum = 4;

select city
from(select student_name,city,marks,row_number() over (order by marks DESC) as rownum
from students s join course c on
s.student_id = c.student_id)aa
where rownum = 2;

select city,count(city)
from students
group by city;

select s.student_name,s.city as city
from students s join students c on
s.city = c.city;

select student_name
from students
where student_name LIKE 'A%';

select city,countt
from(select count(student_name) as countt,city
from students s join course c on
s.student_id = c.student_id
group by city)aa;


/* Q8.Write an SQL query to report the first login date for each player.
Return the result table in any order.
The query result format is in the following example. */

create table Activity(player_id int,device_id int,event_date date,games_played int,primary key(player_id, event_date));
insert into Activity values(1,2,'2016-03-01',5),(1,2,'2016-05-02',6),(2,3,'2017-06-25',1),(3,1,'2016-03-02',0),(3,4,'2018-07-03',5);

select player_id,min(event_date)
from Activity
group by player_id;

/* Q.9 Write an SQL query to find the ids of products that are both low fat and recyclable.
Return the result table in any order. */

create table Products9(product_id int,low_fats enum('Y','N'),recyclable enum('Y','N'));
insert into Products9 values(0,'Y','N'),(1,'Y','Y'),(2,'N','Y'),(3,'Y','Y'),(4,'N','N');

select product_id
from Products9
where low_fats = 'Y' and recyclable = 'Y';

##============================================================================================
##Q10. 
##1. Select the statement that shows the sum of population of all countries in africa

select sum(population)
from countries
where continent = 'Africa';

##2. Select the statement that shows the number of countries with population smaller than 150000

select name
from countries
where population < 150000;

##3. Select the list of core SQL aggregate functions
select max(population),min(population),avg(population)
from countries
group by continent;

##5. Select the statement that shows the average population of 'Poland', 'Germany' and 'Denmark'

select avg(population)
from countries
where name in ('Poland','Germany','Denmark');


##6. Select the statement that shows the medium population density of each region
select avg(population/area)
from countries
group by continent;

##7. Select the statement that shows the name and population density of the countrywith the largest population

select (population/area)
from countries;
