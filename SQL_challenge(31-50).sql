create database sql_challenge31to60;
use sql_challenge31to60;

#==========================================================================================================
/* 31.Write an SQL query to find the npv of each query of the Queries table.*/

create table npv(
					id int,
                    year int,
                    npv int, primary key(id,year));
                    
create table queries(id int, year int,primary key(id,year));

insert into npv values(1,2018,100),(7,2020,30),(13,2019,40),(1,2019,113),
					(2,2008,121),(3,2009,12),(11,2020,99),(7,2019,0);	
                    
insert into queries values(1,2019),(2,2008),(3,2009),(7,2018),(7,2019),(7,2020),(13,2019);

select q.id,q.year,ifnull(n.npv,0) as npv
from queries q left join npv n on
q.id = n.id and q.year = n.year;


#==========================================================================================================
/* 32.Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just show null..*/

create table employees(id int,name varchar(20), primary key(id) );
create table employeesUNI(id int,unique_id int, primary key(id,unique_id));

insert into employees values(1,'Alice'),(7,'Bob'),(11,'Meir'),(90,'Winston'),(3,'Jonathan');
insert into employeesUNI values(3,1),(11,2),(90,3);

select en.unique_id,e.name
from employees e left join employeesUNI en on
e.id = en.id;

#==========================================================================================================
/* 33.Write an SQL query to report the distance travelled by each user.
Return the result table ordered by travelled_distance in descending order, if two or more users
travelled the same distance, order them by their name in ascending order.
*/

create table users(id int,name varchar(20),primary key(id));
create table rides(id int,user_id int,distance int,primary key(id));

insert into users values(1,'Alice'),(2,'Bob'),(3,'Alex'),(4,'Donald'),(7,'Lee'),(13,'Jonathan'),(19,'Elvis');
insert into rides values(1,1,120),(2,2,317),(3,3,222),(4,7,100),(5,13,312),(6,19,50),(7,7,120),(8,19,400),(9,7,230);

select * from rides;
select u.name,ifnull(sum(r.distance),0) as distance
from users u left join rides r on
r.user_id = u.id
group by name 
order by  distance DESC, name;

#==========================================================================================================
/* 34.Write an SQL query to get the names of products that have at least 100 units ordered in February 2020
and their amount.*/

create table products
(product_id int,
product_name varchar(30),
product_category varchar(30),
primary key(product_id)
);

create table orders
(product_id int,
order_date date,
unit int,
foreign key(product_id) References products(product_id)
);

insert into products values(1,'Leetcode Solutions','Book');
insert into products values(2,'Jewels of Stringology','Book');
insert into products values(3,'HP','Laptop');
insert into products values(4,'Lenovo','Laptop');
insert into products values(5,'Leetcode kit','T-Shirt');

insert into orders values(1,'2020-02-05',60);
insert into orders values(1,'2020-02-10',70);
insert into orders values(2,'2020-01-18',30);
insert into orders values(2,'2020-02-11',80);
insert into orders values(3,'2020-02-17',2);
insert into orders values(3,'2020-02-24',3);
insert into orders values(4,'2020-03-01',20);
insert into orders values(4,'2020-03-04',30);
insert into orders values(4,'2020-03-04',60);
insert into orders values(5,'2020-02-25',50);
insert into orders values(5,'2020-02-27',50);
insert into orders values(5,'2020-03-01',50);

select product_id,product_name,units
from (select p.product_id, p.product_name, sum(unit) as units
from orders o join products p on o.product_id = p.product_id 
where month(o.order_date) = 2 and YEAR(o.order_date) = 2020 group by p.product_id)abc
where units >= 100;

#==========================================================================================================
/* 35.Write an SQL query to:
● Find the name of the user who has rated the greatest number of movies. In case of a tie,
return the lexicographically smaller user name.
● Find the movie name with the highest average rating in February 2020. In case of a tie, return
the lexicographically smaller movie name*/

create table Movies
(movie_id int, title varchar(20), primary key(movie_id) );

create table Users35
(user_id int, name varchar(20), primary key(user_id) );

create table MovieRating
(movie_id int, user_id int,rating int,created_at date, primary key(movie_id,user_id) );

insert into Movies values(1,'Avengers'),(2,'Frozen 2'),(3,'Joker');
insert into Users35 values(1,'Daniel'),(2,'Monica'),(3,'Maria'),(4,'James');
insert into MovieRating values(1,1,3,'2020-01-12'),(1,2,4,'2020-02-11'),(1,3,2,'2020-02-12'),(1,4,1,'2020-01-01'),(2,1,5,'2020-02-17'),
				(2,2,2,'2020-02-01'),(2,3,2,'2020-03-01'),(3,1,3,'2020-02-22'),(3,2,4,'2020-02-25');
                

(select name,number_of_movies_rated
from (select u.user_id, name,count(*) as number_of_movies_rated
from MovieRating m join Users35 u on
m.user_id = u.user_id
group by u.user_id)a
order by number_of_movies_rated DESC , name ASC
limit 1)
UNION
(select title,average_rating
from (select mv.movie_id, title,avg(rating) as average_rating
from MovieRating m join movies mv on
m.movie_id = mv.movie_id
where month(created_at) = 2
group by mv.movie_id)a
order by average_rating DESC , title ASC
limit 1);


#==========================================================================================================
/* 36.Write an SQL query to report the distance travelled by each user.
Return the result table ordered by travelled_distance in descending order, if two or more users
travelled the same distance, order them by their name in ascending order.
*/
 ##IT IS SAME AS Q.33##
 
#==========================================================================================================
/* 37.Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just
show null */ 

 ##IT IS SAME AS Q.32##
 
 #==========================================================================================================
/* 38.Write an SQL query to find the id and the name of all students who are enrolled in departments that no
longer exist. */ 

create table departments( id int,name varchar(50),primary key(id));
create table Students( id int,name varchar(20),department_id int,primary key(id));

insert into departments values(1,'Electrical Engineering'),(7,'Computer Engineering'),(13,'Business Administration');
insert into Students values(23,'Alice',1),(1,'Bob',7),(5,'Jennifer',13),(2,'John',14),(4,'Jasmine',77),(3,'Steve',74),(6,'Luis',1),
							(8,'Jonathan',7),(7,'Daiana',33),(11,'Madelynn',1);
                            
select name,department_id from students where department_id not in (select id from departments);

 #==========================================================================================================
/* 39.Write an SQL query to report the number of calls and the total call duration between each pair of
distinct persons (person1, person2) where person1 < person2 */ 

create table calls (from_id int, to_id int, duration int);
insert into calls values(1,2,59),(2,1,11),(1,3,20),(3,4,100),(3,4,200),(3,4,200),(4,3,499);

with callers as (select from_id as person1,to_id as person2 ,duration from calls
					union all
				select to_id as person1,from_id as person2,duration from calls),

unified_calls as (select person1,person2,duration from callers where person1 < person2)

select person1,person2, count(*) as no_of_calls, sum(duration) as total_call_duration from unified_calls group by person1,person2;
				


 #==========================================================================================================
/* 40.Write an SQL query to find the average selling price for each product. average_price should be
rounded to 2 decimal places. */ 


create table prices( product_id int,start_date date,end_date date,price int, primary key(product_id,start_date,end_date));
create table unitssold( product_id int,purchase_date date,units int);

insert into prices values(1,'2019-02-17','2019-02-28',5),(1,'2019-03-01','2019-03-22',20),(2,'2019-02-01','2019-02-20',15),(2,'2019-02-21','2019-03-31',30);
insert into unitssold values(1,'2019-02-25',100),(1,'2019-03-01',15),(2,'2019-02-10',200),(2,'2019-03-22',30);



select product_id, round((sum(price_sum)/sum(units)),2) as avg_price
from (select p.product_id as product_id, units,(price*units) as price_sum
from prices p join unitssold u on
p.product_id = u.product_id and purchase_date between start_date and end_date
)abc
group by product_id;

 #==========================================================================================================
/* 41.Write an SQL query to report the number of cubic feet of volume the inventory occupies in each
warehouse. */ 

create table Warehouse( name varchar(20),product_id int,units int, primary key(name,product_id));
create table Products41( product_id int,product_name varchar(20),Width int,Length int,Height int,primary key(product_id));

insert into Warehouse values('LCHouse1',1,1),('LCHouse1',2,10),('LCHouse1',3,5),('LCHouse2',1,2),('LCHouse2',2,2),('LCHouse3',4,1);
insert into Products41 values(1,'LC-TV',5,50,40),(2,'LC-KeyChain ',5,5,5),(3,'LC-Phone',2,10,10),(4,'LC-TShirt',4,10,20);

select name,sum(volume) as volume_occupies
from(
select name,w.product_id,(width*Length*Height*units) as volume
from Warehouse w join Products41 p on
w.product_id = p.product_id)x
group by name;
                         
#==========================================================================================================
/* 42.Write an SQL query to report the difference between the number of apples and oranges sold each day.
Return the result table ordered by sale_date.. */ 

create table sales(sale_date date,fruit enum('apples','oranges'),sold_num int, primary key(sale_date,fruit));
insert into sales values('2020-05-01','apples',10),('2020-05-01','oranges',8),('2020-05-02','apples',15),('2020-05-02','oranges',15),
						('2020-05-03','apples',20),('2020-05-03','oranges',0),('2020-05-04','apples',15),('2020-05-04','oranges',16);
                        
select * from sales;

select date(sale_date) as sale_date, 
sum(case when fruit = 'apples' then sold_num
	when fruit = 'oranges' then -sold_num end) as diff from sales
    group by sale_date
    order by sale_date;
    

                         
#==========================================================================================================
/* 43.Write an SQL query to report the fraction of players that logged in again on the day after the day they
first logged in, rounded to 2 decimal places. In other words, you need to count the number of players
that logged in for at least two consecutive days starting from their first login date, then divide that
number by the total number of players.*/

create table Activity(player_id int,device_id int,event_date date,games_played int,primary key(player_id,event_date));

insert into activity values(1,2,'2016-03-01',5),(1,2,'2016-03-02',6),(2,3,'2017-06-25',1),(3,1,'2016-03-02',0),(3,4,'2018-07-03',5);

with cte as (select player_id, min(event_date) as start_date
from activity group by player_id)

select (count(distinct c.player_id)) / (select count(distinct player_id) from activity) as a
from cte c join activity a on
c.player_id = a.player_id and datediff(c.start_date,a.event_date) = -1;

#==========================================================================================================
/* 44.Write an SQL query to report the managers with at least five direct reports.*/

create table employee (id int,name varchar(20),department varchar(20),managerId int,primary key(id));

insert into employee values(102,'Dan','A',101),(103,'James','A',101),(104,'Amy','A',101),(105,'Anne','A',101),(106,'Ron','B',101);
insert into employee(id,name,department) values(101,'John','A');

select * from employee;

select a.name
from employee a join employee b on
a.id = b.managerId
group by name
having count(b.managerId) >= 5;

#==========================================================================================================
/* 45.Write an SQL query to report the respective department name and number of students majoring in
each department for all departments in the Department table (even ones with no current students).
Return the result table ordered by student_number in descending order. In case of a tie, order them by
dept_name alphabetically.*/

create table department(dept_id int,dept_name varchar(20),primary key(dept_id));
create table student (student_id int,student_name varchar(20),gender varchar(10),dept_id int,
						primary key(student_id),foreign key(dept_id) references department(dept_id));
    
insert into department values(1,'Engineerig'),(2,'Science'),(3,'Law');    
insert into student values(1,'Jack','M',1),(2,'Jane','F',1),(3,'Mark','M',2);

select dept_name, ifnull(count(student_id),0) as students_enrolled
from student s right join department d on (s.dept_id = d.dept_id)
group by dept_name
order by students_enrolled DESC , dept_name ASC;

#==========================================================================================================
/* 46.Write an SQL query to report the customer ids from the Customer table that bought all the products in
the Product table.*/

create table Product46(product_key int,primary key(product_key));
create table customer46(customer_id int,product_key int,foreign key(product_key) references Product46(product_key));

insert into Product46 values(5),(6);
insert into customer46 values(1,5),(2,6),(3,5),(3,6),(1,6);

select customer_id
from Product46 p inner join customer46 c on (p.product_key = c.product_key) 
group by customer_id
having count(distinct p.product_key) = (select count(*) from Product46);

#==========================================================================================================
/* 47.Write an SQL query that reports the most experienced employees in each project. In case of a tie,
report all employees with the maximum number of experience years*/

create table Employee47(employee_id int,name varchar(20),experience_years int,primary key(employee_id));
create table project(project_id int, employee_id int,primary key(project_id, employee_id),foreign key(employee_id) references Employee47(employee_id));

insert into employee47 values(1,'Khaled',3),(2,'Ali',2),(3,'John',3),(4,'Doe',2);
insert into project values(1,1),(1,2),(1,3),(2,1),(2,4);


select project_id,e.employee_id
from project p join Employee47 e on p.employee_id = e.employee_id
where (project_id,experience_years) in (select project_id, max(experience_years)
from project p join Employee47 e on p.employee_id = e.employee_id
group by project_id);

#==========================================================================================================
/* 48.Write an SQL query that reports the books that have sold less than 10 copies in the last year,
excluding books that have been available for less than one month from today. Assume today is
2019-06-23.*/

create table books(book_id int,name varchar(20),available_from date,primary key(book_id));
create table orders48(order_id int,book_id int,quantity int,dispatch_date date,primary key(order_id),foreign key(book_id) references books(book_id));

insert into books values(1,'\"Kalila And Demna\"','2010-01-01'),(2,'\"28 Letters\"','2012-05-12'),(3,'\"The Hobbit\"','2019-06-10'),
				(4,'\"13 Reasons Why\"','2019-06-01'),(5,'\"The HungerGames\"','2008-09-21');
                
insert into orders48 values(1,1,2,'2018-07-26'),(2,1,1,'2018-11-05'),(3,3,8,'2019-06-11'),(4,4,6,'2019-06-05'),
							(5,4,5,'2019-06-20'),(6,5,9,'2009-02-02'),(7,5,8,'2010-04-13');
                            
    
select book_id,name
from books
where book_id not in (
					select book_id
                    from orders48
                    where dispatch_date  between date_sub('2019-06-23',interval 1 year) and '2019-06-23'
                    group by book_id
                    having sum(quantity) >= 10)
	and available_from  < date_sub('2019-06-23',interval 1 month);
    
#==========================================================================================================
/* 49.Write a SQL query to find the highest grade with its corresponding course for each student. In case of
a tie, you should find the course with the smallest course_id. Return the result table ordered by student_id in ascending order.*/    

create table Enrollments(student_id int,course_id int,grade int,primary key(student_id, course_id));

insert into Enrollments values(2,2,95),(2,3,95),(1,1,90),(1,2,99),(3,1,80),(3,2,75),(3,3,82);

select student_id,course_id,grade
from (select student_id,course_id,grade,rank() over (partition by student_id order by grade DESC,course_id ASC,student_id ASC) as bbc
from Enrollments)abc
where bbc = 1;

#==========================================================================================================
/* 50.The winner in each group is the player who scored the maximum total points within the group. In the
case of a tie, the lowest player_id wins. Write an SQL query to find the winner in each group.*/   

create table Players(player_id int,group_id int,primary key(player_id));
create table Matches(match_id int,first_player int,second_player int,first_score int,second_score int,primary key(match_id));

insert into Players values(15,1),(25,1),(30,1),(45,1),(10,2),(35,2),(50,2),(20,3),(40,3);
insert into Matches values(1,15,45,3,0),(2,30,25,1,2),(3,30,15,2,0),(4,40,20,5,2),(5,35,50,1,1);


select group_id,player_id
from (select p.player_id as player_id,group_id,sum(score) as sum_score
from players p join 
	(select first_player as player_id, first_score as score
	from matches
	union all
	select second_player as player_id, second_score as score
	from matches) a_s on
p.player_id = a_s.player_id
group by a_s.player_id
order by group_id,sum_score DESC,p.player_id)tp
group by group_id;



    

 













