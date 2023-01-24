


create DATABASE SQL_challange;

use SQL_challange;

create table city
(
    id int,
    name varchar(20),
    countrycode varchar(20),
    district VARCHAR(20),
    population bigint
);

set session sql_mode = ' ';

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\city_table.csv"
INTO TABLE city
fields terminated by ','
enclosed by '"'
LINES TERMINATED BY '\n'
IGNORE 1 rows;

# Q1. Query all columns for all American cities in the CITY table with populations larger than 100000.
# The CountryCode for America is USA.

select * from city where countrycode = 'USA' and population > 100000;

# Q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000.
# The CountryCode for America is USA.

select name from city where countrycode = 'USA' and population > 120000;

# Q3. Query all columns (attributes) for every row in the CITY table.

select * from city;

# Q4. Query all columns for a city in CITY with the ID 1661.

select * from city where id = 1661;

# Q5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.

select * from city where countrycode = 'JPN';

#Q6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.

select name from city where countrycode = 'JPN';

#=================================================================================================================

create table station
(
    id int,
    city varchar(21),
    state varchar(20),
    LAT_N bigint,
    LONG_W bigint
);

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\station_data.csv"
INTO TABLE station
fields terminated by ','
enclosed by '"'
LINES TERMINATED BY '\n'
IGNORE 2 rows;

select * from station;

#Q7. Query a list of CITY and STATE from the STATION table.

select state,city from station;

#Q8. Query a list of CITY names from STATION for cities that have an even ID number. Print the results
#in any order, but exclude duplicates from the answer.

select city from station where id%2 = 0 ;

/*Q9. Find the difference between the total number of CITY entries in the table and the number of
#distinct CITY entries in the table.
For example, if there are three records in the table with CITY values 'New York', 'New York', 
'Bengalaru',there are 2 different city names: 'New York' and 'Bengalaru'. The query returns , 
because total number of records - number of unique city names = 3-2 =1*/

select count(city) as no_of_citynames, count(DISTINCT city) as no_of_distinct_citynames, (count(city) - count(DISTINCT city)) as diff from station;

/* Q10. Query the two cities in STATION with the shortest and longest CITY names, as well as their
respective lengths (i.e.: number of characters in the name). If there is more than one smallest or
largest city, choose the one that comes first when ordered alphabetically.*/

select city,length(city) as min_length from station order by min_length ASC limit 1;
select city,length(city) as max_length from station order by max_length DESC limit 1;


/*Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result
cannot contain duplicates*/

select distinct city from station where city LIKE 'a%' or city LIKE 'e%' or city LIKE 'i%' or city LIKE 'o%' or city LIKE 'u%';


/*Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot
contain duplicates*/

select distinct city from station where city LIKE '%a' or city LIKE '%e' or city LIKE '%i' or city LIKE '%o' or city LIKE '%u';


/*Q13. Query the list of CITY names from STATION that do not start with vowels. Your result cannot
contain duplicates.*/

select distinct city from station where substr(city,1,1) not in ('a','e','i','o','u');

/*Q14. Query the list of CITY names from STATION that do not end with vowels. Your result cannot
contain duplicates*/

select distinct city from station where substr(city,length(city),1) not in ('a','e','i','o','u');

/*Q15. Query the list of CITY names from STATION that either do not start with vowels or do not end
with vowels. Your result cannot contain duplicates.*/

select distinct city from station where (substr(city,1,1) not in ('a','e','i','o','u')) or (substr(city,length(city),1) not in ('a','e','i','o','u'));

/*Q16. Query the list of CITY names from STATION that do not start with vowels and do not end with
vowels. Your result cannot contain duplicates.*/

select distinct city from station where (substr(city,1,1) not in ('a','e','i','o','u')) and (substr(city,length(city),1) not in ('a','e','i','o','u'));

#======================================================================================================================
create table products
(product_id int PRIMARY	KEY, 
product_name varchar(20),
unit_price int);

create table sales
(seller_id int,
product_id int,
buyer_id int,
sale_date date,
quantity int,
price int ,
constraint fk foreign key (product_id) references products(product_id)
);

/*17. Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
between 2019-01-01 and 2019-03-31 inclusive.*/

insert into products values(1,'S8',1000),(2,'G4',800),(3,'iPhone',1400);

insert into sales values(1,1,1,'2019-01-21',2,2000),(1,2,2,'2019-02-17',1,800),(2,2,3,'2019-06-02',1,800),(3,3,4,'2019-05-13',2,2800);

select p.product_id,product_name from sales s join products p on
p.product_id = s.product_id
where sale_date between '2019-01-01' AND '2019-03-31';

#=================================================================================================================================
/*18.  Write an SQL query to find all the authors that viewed at least one of their own articles.*/

create table views
(
 article_id int,
 author_id int,
 viewer_id int,
 view_date date
);

insert into views values(1,3,5,'2019-08-01'),(1,3,6,'2019-08-02'),(2,7,7,'2019-08-01'),(2,7,6,'2019-08-02'),(4,7,1,'2019-07-22'),(3,4,4,'2019-07-21'),(3,4,4,'2019-07-21');

select distinct author_id from views where author_id = viewer_id order by author_id;

#=================================================================================================
/*19.Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal
places*/

create table delivery
(
 delivery_id int PRIMARY KEY,
 customer_id int,
 order_date date,
 customer_pref_delvery_date date
);

insert into delivery values(1,1,'2019-08-01','2019-08-02'),(2,5,'2019-08-02','2019-08-02'),(3,1,'2019-08-11','2019-08-11'),(4,3,'2019-08-24','2019-08-26'),(5,4,'2019-08-21','2019-08-22'),(6,2,'2019-08-11','2019-08-13');

select round(((d2.immediate_orders/count(*))*100),2) as immediate_req 
from delivery d1, 
				(select count(order_date) as immediate_orders 
                from delivery 
                where order_date = customer_pref_delvery_date) as d2;

#=======================================================================================================================
/* 20. Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.*/

create table ads
(
 ad_id int,
 user_id int,
 action enum ('Clicked', 'Viewed', 'Ignored'),
 primary KEY (ad_id,user_id)
);

insert into ads values(1,1,'Clicked'),(2,2,'Clicked'),(3,3,'Viewed'),(5,5,'Ignored'),(1,7,'Ignored'),(2,7,'Viewed'),(3,5,'Clicked'),(1,4,'Viewed'),(2,11,'Viewed'),(1,2,'Clicked');

with cte1 as (select ad_id,
			sum(case when action = 'Clicked' then 1 else 0 end) as total_clicks,
            sum(case when action = 'Viewed' then 1 else 0 end) as total_views
from ads
group by ad_id
order by ad_id)
select ad_id,ifnull(((total_clicks/(total_clicks+total_views))*100),0) as ctr
from cte1;

#=======================================================================================================================
/* 21. Write an SQL query to find the team size of each of the employees.*/

create table Employee
( employee_id int , team_id int);

insert into Employee values(1,8),(2,8),(3,8),(4,7),(5,9),(6,9);

select employee_id , count(team_id) over (partition by team_id) as ab from employee;

#=======================================================================================================================
/* 22. Write an SQL query to find the type of weather in each country for November 2019.
The type of weather is:
● Cold if the average weather_state is less than or equal 15,
● Hot if the average weather_state is greater than or equal to 25, and
● Warm otherwise.
Return result table in any order*/

create table Countries
(country_id int PRIMARY key, country_name varchar(20));

create table weather (country_id int, weather_state int,day date, primary	key(country_id,day));

insert into Countries values(2,'USA'),(3,'Australia'),(7,'Peru'),(5,'China'),(8,'Morocco'),(9,'Spain');

insert into weather values(2,15,'2019-11-01'),(2,12,'2019-10-28'),(2,12,'2019-10-27'),(3,-2,'2019-11-10'),(3,0,'2019-11-11'),
						  (3,3,'2019-11-12'),(5,16,'2019-11-07'),(5,18,'2019-11-09'),(5,21,'2019-11-23'),(7,25,'2019-11-28'),
                          (7,22,'2019-12-01'),(7,20,'2019-10-02'),(8,25,'2019-11-05'),(8,27,'2019-11-15'),(8,31,'2019-11-25'),
                          (9,7,'2019-10-23'),(9,3,'2019-12-23');
                          
                          


select c.country_name , case 
				when avg(weather_state) <= 15 then 'Cold'
				when avg(weather_state) >= 25 then 'Hot'
                else 'Warm' end as type_of_weather
from weather w join countries c on
w.country_id = c.country_id
group by c.country_name; 						
                          
#=======================================================================================================================
/* 23.Write an SQL query to find the average selling price for each product. average_price should be
rounded to 2 decimal places.*/

create table prices( 
				product_id int,
                start_date date,
                end_date date,
                price int,
                primary key(product_id,start_date,end_date));
                
create table unitssold( 
				product_id int,
                purchase_date date,
                units int);
                
insert into prices values(1,'2019-02-17','2019-02-28',5),(1,'2019-03-01','2019-03-22',20),(2,'2019-02-01','2019-02-20',15),(2,'2019-02-21','2019-03-31',30);

insert into unitssold values(1,'2019-02-25',100),(1,'2019-03-01',15),(2,'2019-02-10',200),(2,'2019-03-22',30);

select product_id, (sum(price_sum)/sum(units)) as aver
from (select p.product_id as product_id, units, (units*price) as price_sum
from prices p join unitssold u on
p.product_id = u.product_id and purchase_date between start_date and end_date) temp
group by product_id;

#=======================================================================================================================
/* 24.Write an SQL query to report the first login date for each player.*/

create table activity
( player_id int,
device_id int,
event_date date,
games_played int,
primary key(player_id,event_date));

insert into activity values(1,2,'2016-03-01',5),(1,2,'2016-05-02',6),(2,3,'2017-06-25',1),(3,1,'2016-03-02',0),(3,4,'2018-07-03',5);

select player_id,min(event_date) as first_login from activity group by player_id;

/* 25.Write an SQL query to report the first login date for each player.*/

select player_id,device_id from (select player_id,device_id,event_date,min(event_date) as first_login from activity group by player_id)abc
where first_login = event_date;

#==========================================================================================================
/* 26.Write an SQL query to get the names of products that have at least 100 units ordered in February 2020 and their amount*/

create table products26
(product_id int,
product_name varchar(30),
product_category varchar(30),
primary key(product_id)
);

create table orders26
(product_id int,
order_date date,
unit int,
foreign key(product_id) References products26(product_id)
);

insert into products26 values(1,'Leetcode Solutions','Book');
insert into products26 values(2,'Jewels of Stringology','Book');
insert into products26 values(3,'HP','Laptop');
insert into products26 values(4,'Lenovo','Laptop');
insert into products26 values(5,'Leetcode kit','T-Shirt');

insert into orders26 values(1,'2020-02-05',60);
insert into orders26 values(1,'2020-02-10',70);
insert into orders26 values(2,'2020-01-18',30);
insert into orders26 values(2,'2020-02-11',80);
insert into orders26 values(3,'2020-02-17',2);
insert into orders26 values(3,'2020-02-24',3);
insert into orders26 values(4,'2020-03-01',20);
insert into orders26 values(4,'2020-03-04',30);
insert into orders26 values(4,'2020-03-04',60);
insert into orders26 values(5,'2020-02-25',50);
insert into orders26 values(5,'2020-02-27',50);
insert into orders26 values(5,'2020-03-01',50);

select * from products26;

select product_name,total_sales
from (select product_name,sum(unit) as total_sales from products26 p join orders26 o on p.product_id = o.product_id 
WHERE MONTH(o.order_date) = 2 AND YEAR(o.order_date) = 2020 group by product_name)abc 
where total_sales >= 100;


#==========================================================================================================
/* 27.Write an SQL query to find the users who have valid emails.
A valid e-mail has a prefix name and a domain where:
● The prefix name is a string that may contain letters (upper or lower case), digits, underscore
'_', period '.', and/or dash '-'. The prefix name must start with a letter.
● The domain is '@leetcode.com'.*/

create table users
(user_id int,
name varchar(20),
mail varchar(30),
primary key (user_id)
);

insert into users values(1,'Winston','winston@leetcode.com');
insert into users values(2,'Jonathan','jonathanisgreat');
insert into users values(3,'Annabelle','bella-@leetcode.com');
insert into users values(4,'Sally','sally.come@leetcode.com');
insert into users values(5,'Marwan','quarz#2020@leetcode.com');
insert into users values(6,'David','david69@leetcode.com');
insert into users values(7,'Shapiro','.shapo@leetcode.com');

select * from users
where REGEXP_LIKE (mail, '^[a-zA-Z][a-bA-Z0-9\.\_\-]*.@leetcode.com');


#==========================================================================================================
/* 28.Write an SQL query to report the customer_id and customer_name of customers who have spent at
least $100 in each month of June and July 2020.*/

create table customers(
					customer_id int,
                    name varchar(20),
                    country varchar(20),
                    primary key(customer_id));
                    
 create table product(
					product_id int,
                    description varchar(20),
                    price int,
                    primary key(product_id));  
                    
  create table orders28(
					order_id int,
                    customer_id int,
                    product_id int,
                    order_date date,
                    quantity int,
                    primary key(order_id));         
                    
insert into customers values(1,'Winston','USA');
insert into customers values(2,'Jonathan','Peru');
insert into customers values(3,'Moustafa','Egypt');

insert into product values(10,'LC Phone',300);
insert into product values(20,'LC T-Shirt',10);
insert into product values(30,'LC Book',45);
insert into product values(40,'LC Keychain',2);

insert into orders28 values(1,1,10,'2020-06-10',1);
insert into orders28 values(2,1,20,'2020-07-01',1);
insert into orders28 values(3,1,30,'2020-07-08',2);
insert into orders28 values(4,2,10,'2020-06-15',2);
insert into orders28 values(5,2,40,'2020-07-01',10);
insert into orders28 values(6,3,20,'2020-06-24',2);
insert into orders28 values(7,3,30,'2020-06-25',2);
insert into orders28 values(9,3,30,'2020-05-08',3);

select customer_id,name,amount
from (select o.customer_id as customer_id,c.name as name, year(o.order_date) as year_of_order,month(o.order_date) as month_of_order, (o.quantity*p.price) as amount
from orders28 o join customers c on
o.customer_id = c.customer_id join product p on o.product_id = p.product_id
group by c.name,year_of_order,month_of_order)abc
where amount >=100  ;

select c.customer_id,c.name
from orders28 o, product p,customers c
where o.customer_id = c.customer_id and o.product_id = p.product_id
group by o.customer_id
having 
(
	sum(case when order_date like '2020-06%' THEN p.price * o.quantity end) >= 100
			and
	sum(case when order_date like '2020-07%' THEN p.price * o.quantity end) >=100
            );
            
#==========================================================================================================
/* 29.Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020.*/

create table TVProgram
( program_date date,
content_id int,
channel varchar(15),
primary key(program_date,content_id)
);

create table content
( content_id varchar(20),
title varchar(20),
Kids_content enum('Y','N'),
content_type varchar(15),
primary key(content_id)
);

insert into TVProgram values('2020-06-10 08:00',1,'LC-Channel');
insert into TVProgram values('2020-05-11 12:00',2,'LC-Channel');
insert into TVProgram values('2020-05-12 12:00',3,'LC-Channel');
insert into TVProgram values('2020-05-13 14:00',4,'Disney Ch');
insert into TVProgram values('2020-06-18 14:00',4,'Disney Ch');
insert into TVProgram values('2020-07-15 16:00',5,'Disney Ch');


insert into content values(1,'Leetcode Movie','N','Movies');
insert into content values(2,'Alg. for Kids','Y','Series');
insert into content values(3,'Database Sols','N','Series');
insert into content values(4,'Aladdin','Y','Movies');
insert into content values(5,'Cinderella','Y','Movies');

select c.content_id, c.title
from content c, TVProgram p
where c.content_id = p.content_id and month(p.program_date) = 6 and content_type = 'Movies' and Kids_content = 'Y';

#==========================================================================================================
/* 30.Write an SQL query to find the npv of each query of the Queries table.*/

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