create database sql_challange51to70;

use sql_challange51to70;

#=====================================================================================================
/* Q.51 Write an SQL query to report the name, population, and area of the big countries.
Return the result table in any order.*/

create table world(name varchar(20),continent varchar(20),area int,population int,gdp bigint,primary key(name));
insert into world values('Afghanistan','Asia',652230,25500100,20343000000),('Albania','Europe',28748,2831741,12960000000),
						('Algeria','Africa',2381741,37100000,188681000000),('Andorra','Europe',468,78115,3712000000),('Angola','Africa',1246700,20609294,100990000000);

select name, population,area
from (                        
select name, population,area, (case when (area >= 3000000 or population >= 25000000) then 'BigCountry' else 'Small' end) as country_size
from world)abc
where country_size = 'BigCountry';                        


#=====================================================================================================
/* Q.52 Write an SQL query to report the names of the customer that are not referred by the customer with id
= 2.*/

create table Customer(id int, name varchar(20),referee_id int,primary key(id));
insert into Customer values(1,'Will',null),(2,'Jane',null),(3,'Alex',2),(4,'Bill',null),(5,'Zack',1),(6,'Mark',2);

select name
from Customer 
where referee_id != 2 or referee_id is null;

#=====================================================================================================
/* Q.53 Write an SQL query to report all customers who never order anything.*/

create table Customers(id int,name varchar(20),primary key(id));
create table Orders(id int, customerId int,primary key(id),foreign key(customerId) references Customers(id));

insert into Customers values(1,'Joe'),(2,'Henry'),(3,'Sam'),(4,'Max');
insert into Orders values(1,3),(2,1);

select name
from Customers
where id not in (select distinct customerId
from Orders);

#=====================================================================================================
/* Q.54 Write an SQL query to find the team size of each of the employees.*/

create table employee(employee_id int,team_id int,primary key(employee_id));

insert into employee values(1,8),(2,8),(3,8),(4,7),(5,9),(6,9);

select employee_id,(select count(*) from employee where team_id = e.team_id)
from employee e;

select employee_id, count(team_id) over (partition by team_id) as team_size
from employee
order by team_size;

#=====================================================================================================
/* Q.55 A telecommunications company wants to invest in new countries. The company intends to invest in
the countries where the average call duration of the calls in this country is strictly greater than the
global average call duration.
Write an SQL query to find the countries where this company can invest*/

create table person(id int,name varchar(20),phone_number varchar(20),primary key(id));
create table country(name varchar(20),country_code varchar(20),primary key(country_code));
create table calls(caller_id int,callee_id int,duration int);

insert into person values(3,'Jonathan','051-1234567'),(12,'Elvis','051-7654321'),(1,'Moncef','212-1234567'),
						(2,'Maroua','212-6523651'),(7,'Meir','972-1234567'),(9,'Rachel','972-0011100');                       
insert into country values('Peru','51'),('Israel','972'),('Morocco','212'),('Germany','49'),('Ethiopia','251');
insert into calls values(1,9,33),(2,9,4),(1,2,59),(3,12,102),(3,12,330),(12,3,5),(7,9,13),(9,7,1),(1,7,7),(7,1,3);

select c.name as country
from person p join country c on
substring(phone_number from 1 for 3) = c.country_code
inner join (select caller_id as caller, duration as duration
			from calls
			union all
			select callee_id as caller, duration as duration
			from calls) a1 on
p.id = a1.caller
group by country
having avg(duration) > (select avg(duration) from calls);


#=====================================================================================================
/* Q.56. Write an SQL query to report the device that is first logged in for each player.*/

create table Activity(player_id int,device_id int,event_date date,games_played int,primary key(player_id,event_date));
 
insert into Activity values(1,2,'2016-03-01',5),(1,2,'2016-05-02',6),(2,3,'2017-06-25',1),(3,1,'2016-03-02',0),(3,4,'2018-07-03',5);

select * from activity ;

select a.player_id,a.device_id
from activity a join (select player_id, min(event_date) as first_login
from activity
group by player_id)abc on
a.event_date = abc.first_login;

#=======================================================================================================================
/* Q.57. Write an SQL query to find the customer_number for the customer who has placed the largest number of orders.*/

create table orders57(order_number int,customer_number int,primary key(order_number));

insert into orders57 values(1,1),(2,2),(3,3),(4,3);

select customer_number, count(order_number) as max_orders
from orders57
group by customer_number
order by max_orders DESC
Limit 1;

select customer_number
from orders57
group by 1
having count(*) >= all(select count(customer_number) from orders57 group by customer_number);

#=======================================================================================================================
/* Q.58. Write an SQL query to report all the consecutive available seats in the cinema.
Return the result table ordered by seat_id in ascending order.*/

create table Cinema(seat_id int auto_increment, free bool,primary key(seat_id));
insert into Cinema(free) values(1),(0),(1),(1),(1);

select distinct c1.seat_id
from cinema c1 join cinema c2 on
abs(c1.seat_id - c2.seat_id) = 1 and c1.free = 1 and c2.free = 1
order by 1;

#=======================================================================================================================
/* Q.59. Write an SQL query to report the names of all the salespersons who did not have any orders related to
the company with the name "RED".*/

create table salesperson ( sales_id int,name varchar(20),salary int,commission_rate int,hire_date varchar(10),primary key(sales_id));
create table company(com_id int,name varchar(20),city varchar(20),primary key(com_id));
create table Orders59(order_id int,order_date varchar(10),com_id int,sales_id int,amount int,
					primary key(order_id),foreign key(com_id) references company(com_id),
                    foreign key(sales_id) references salesperson(sales_id));


insert into company values(1,'RED','Boston'),(2,'ORANGE','New York'),(3,'YELLOW','Boston'),(4,'GREEN','Austin');
insert into salesperson values(1,'John',100000,6,'4/1/2006'),(2,'Amy',12000,5,'5/1/2010'),(3,'Mark',65000,12,'12/25/2008'),
							(4,'Pam',25000,25,'1/1/2005'),(5,'Alex',5000,10,'2/3/2007');
insert into Orders59 values(1,'1/1/2014',3,4,10000),(2,'2/1/2014',4,5,5000),(3,'3/1/2014',1,1,50000),(4,'4/1/2014',1,4,25000);


select name
from salesperson 
where name not in (select s.name as name
from salesperson s join Orders59 o on (s.sales_id = o.sales_id) 
join company c on o.com_id = c.com_id and c.name = 'RED');

#=======================================================================================================================
/* Q.60. Write an SQL query to report for every three line segments whether they can form a triangle.
Return the result table in any order*/

create table triangle (x int,y int,z int);

insert into triangle values(13,15,30),(10,20,15);

select x,y,z, case when (x+y > z) and (x+z > y) and (z+y >= x) then 'Yes' else 'No' end as traingle
from triangle;

#=======================================================================================================================
/* Q.61. Write an SQL query to report the shortest distance between any two points from the Point table.*/

create table point(x int);
insert into point values(-1),(0),(2);

select min(abs(t2.x - t1.x)) shortest
from point t1 join point t2 on
t1.x != t2.x;

#=======================================================================================================================
/* Q.62. Write a SQL query for a report that provides the pairs (actor_id, director_id) where the actor has
cooperated with the director at least three times*/

create table ActorDirector(actor_id int,director_id int,timestamp int,primary key(timestamp));

insert into ActorDirector values(1,1,0),(1,1,1),(1,1,2),(1,2,3),(1,2,4),(2,1,5),(2,1,6);

select actor_id,director_id
from ActorDirector 
group by actor_id,director_id
having count(*) >= 3;


#=======================================================================================================================
/* Q.63. Write an SQL query that reports the product_name, year, and price for each sale_id in the Sales table*/

create table sales63(sale_id int,product_id int,year int,quantity int,price int,primary key(sale_id,year));
create table product(product_id int,product_name varchar(20),primary key(product_id));

insert into sales63 values(1,100,2008,10,5000),(2,100,2009,12,5000),(7,200,2011,15,9000);
insert into product values(100,'Nokia'),(200,'Apple'),(300,'Samsung');

select product_name,year,price
from sales63 s join product p on
s.product_id = p.product_id;


#=======================================================================================================================
/* Q.64. Write an SQL query that reports the average experience years of all the employees for each project,
rounded to 2 digits.*/

create table employee64(employee_id int,name varchar(20),experience_years int,primary key(employee_id));
create table project(project_id int,employee_id int,primary key(project_id,employee_id),foreign key(employee_id) references employee64(employee_id));

insert into employee64 values(1,'Khaled',3),(2,'Ali',2),(3,'John',1),(4,'Doe',2);
insert into project values(1,1),(1,2),(1,3),(2,1),(2,4);

select p.project_id, avg(e.experience_years) as avg_exp
from project p,employee64 e
where p.employee_id = e.employee_id
group by p.project_id;

#=======================================================================================================================
/* Q.65. Write an SQL query that reports the best seller by total sales price, If there is a tie, report them all.*/

create table product65(product_id int,product_name varchar(20),unit_price int,primary key(product_id));
create table sales65(seller_id int,product_id int,buyer_id int,sale_date date,quantity int,price int,foreign key(product_id) references product65(product_id));

insert into product65 values(1,'S8',1000),(2,'G4',800),(3,'iPhone',1400);
insert into sales65 values(1,1,1,'2019-01-21',2,2000),(1,2,2,'2019-02-17',1,800),(2,2,3,'2019-06-02',1,800),(3,3,4,'2019-05-13',2,2800);

with cte1 as (select seller_id, sum(price) as total_price
from sales65
group by seller_id)
select seller_id
from cte1
where total_price = (select max(total_price) from cte1);

#=======================================================================================================================
/* Q.66. Write an SQL query that reports the buyers who have bought S8 but not iPhone. Note that S8 and
iPhone are products present in the Product table*/

create table Product66(product_id int,product_name varchar(20),unit_price int,primary key(product_id));
create table sales66(seller_id int,product_id int,buyer_id int,sale_date date,quantity int,price int,foreign key(product_id) references Product66(product_id));

insert into Product66 values(1,'S8',1000),(2,'G4',800),(3,'Iphone',1400);
insert into sales66 values(1,1,1,'2019-01-21',2,2000),(1,2,2,'2019-02-17',1,800),(2,1,3,'2019-06-02',1,800),(3,3,3,'2019-05-13',2,2800);

select distinct buyer_id from sales66 s join Product66 p on s.product_id = p.product_id
where p.product_name = 'S8' and buyer_id not in
 (Select buyer_id from sales66 s join Product66 p on s.product_id = p.product_id where p.product_name = 'Iphone');
 
 

#=======================================================================================================================
/* Q.67. Write an SQL query to compute the moving average of how much the customer paid in a seven days
window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places*/

create table Customer67 (customer_id int,name varchar(20),visited_on date,amount int,primary key(customer_id, visited_on));

insert into Customer67 values(1,'Jhon','2019-01-01',100),(2,'Daniel','2019-01-02',110),
		(3,'Jade','2019-01-03',120),(4,'Khaled','2019-01-04',130),(5,'Winston','2019-01-05',110),
        (6,'Elvis','2019-01-06',140),(7,'Anna','2019-01-07',150),(8,'Maria','2019-01-08',80),
        (9,'Jaze','2019-01-09',110),(1,'Jhon','2019-01-10',130),(3,'Jade','2019-01-10',150);
         
    
Select v.visited_on , sum(c.amount) as amount, round(sum(c.amount) / 7 ,2) as avgamount
from ( select distinct visited_on from Customer67
		where datediff(visited_on,(select min(visited_on) from Customer67)) >= 6) v
        left join Customer67 c 
        on datediff(v.visited_on, c.visited_on) between 0 and 6
group by v.visited_on
order by v.visited_on;
        
#=======================================================================================================================
/* Q.68. Write an SQL query to find the total score for each gender on each day.
Return the result table ordered by gender and day in ascending order*/

create table Scores68 (player_name varchar(20),gender varchar(10),day date,score_points int,primary key(gender, day));

insert into Scores68 values('Aron','F','2020-01-01',17),('Alice','F','2020-01-07',23),('Bajrang','M','2020-01-07',7),
			('Khali','M','2019-12-25',11),('Slaman','M','2019-12-30',13),('Joe','M','2019-12-31',3),
            ('Jose','M','2019-12-18',2),('Priya','F','2019-12-31',23),('Priyanka','F','2019-12-30',17);
            
select 	gender,day,sum(score_points) over (partition by gender order by day) as total
from Scores68;

#=======================================================================================================================            
/* Q.69. Write an SQL query to find the start and end number of continuous ranges in the table Logs.
Return the result table ordered by start_id.*/

create table logs69(Log_id bigint,primary key(log_id));

insert into logs69 values(1),(2),(3),(7),(8),(10);

select min(Log_id) as start_id, max(Log_id) as end_id
from (select l.Log_id , (l.Log_id - l.rownum) as diff
from (select Log_id, row_number() over () as rownum from logs69) l) l2
group by diff;


#=======================================================================================================================            
/* Q.70. Write an SQL query to find the number of times each student attended each exam.
Return the result table ordered by student_id and subject_name.*/

create table Students70(student_id int,student_name varchar(20),primary key(student_id));
create table Subjects70(subject_name varchar(20),primary key(subject_name));
create table Examinations70(student_id int,subject_name varchar(20));

insert into Students70 values(1,'Alice'),(2,'Bob'),(13,'John'),(6,'Alex');
insert into Subjects70 values('Math'),('Physics'),('Programming');
insert into Examinations70 values(1,'Math'),(1,'Physics'),(1,'Programming'),(2,'Programming'),(1,'Physics'),(1,'Math'),(13,'Math'),
								(13,'Programming'),(13,'Physics'),(2,'Maths'),(1,'Math');

select a.student_id,a.student_name,b.subject_name,count(b.subject_name) as attended_exam
from  Students70 a join Subjects70 b left join Examinations70 c on a.student_id = c.student_id and b.subject_name = c.subject_name
group by a.student_id,b.subject_name;