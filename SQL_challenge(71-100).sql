create database sql_challange71to100;
use sql_challange71to100;

#=====================================================================================================
/* Q.71 Write an SQL query to find employee_id of all employees that directly or indirectly report their work to
the head of the company.
The indirect relation between managers will not exceed three managers as the company is small.
Return the result table in any order*/

create table Employees71(employee_id int,employee_name varchar(20),manager_id int,primary key(employee_id));
insert into Employees71 values(1,'Boss',1),(3,'Alice',3),(2,'Bob',1),(4,'Daniel',2),(7,'Luis',4),(8,'Jhon',3),(9,'Angela',8),(77,'Robert',1);

select employee_id from Employees71 where manager_id in
(select employee_id from Employees71 where manager_id in
 (select employee_id from Employees71 where manager_id = 1)) and employee_id != 1;
 
 #=====================================================================================================
/* Q.72 Write an SQL query to find for each month and country, the number of transactions and their total
amount, the number of approved transactions and their total amount.*/

create table Transactions72(id int,country varchar(20),state enum('approved','declined'),amount int,trans_date date,primary key(id));
insert into Transactions72 values(121,'US','approved',1000,'2018-12-18'),(122,'US','declined',2000,'2018-12-19'),
									(123,'US','approved',2000,'2019-01-01'),(124,'DE','approved',2000,'2019-01-07');
                                    			
select date_format(trans_date,"%Y-%m") as trns_month,country,
		count(id) as total_transactions,
        sum(case when state = 'approved' then 1 else 0 end) as approved_transaction,
        sum(amount) as total_amount ,
        sum(case when state = 'approved' then amount else 0 end) as approved_amount
from Transactions72
group by trns_month,country;
		

#=====================================================================================================
/* Q.73 Write an SQL query to find the average daily percentage of posts that got removed after being
reported as spam, rounded to 2 decimal places.*/

create table Actions73(user_id int,post_id int,action_date date,
action enum('view', 'like', 'reaction', 'comment', 'report', 'share'),extra varchar(50));
create table Removals73(post_id int,remove_date date,primary key(post_id));

insert into Actions73 values(1,1,'2019-07-01','view',null),(1,1,'2019-07-01','like',null),
							(1,1,'2019-07-01','share',null),(2,2,'2019-07-04 ','view',null),
                            (2,2,'2019-07-04 ','report','spare'),(3,4,'2019-07-04','view',null),
                            (3,4,'2019-07-04','report','spam'),(4,3,'2019-07-02','view',null),
                            (4,3,'2019-07-02','report','spam'),(5,2,'2019-07-03','view',null),
                            (5,2,'2019-07-03','report','racism'),(5,5,'2019-07-03','view',null),
                            (5,5,'2019-07-03','report',null);
                            
insert into Removals73 values(2,'2019-07-20'),(3,'2019-07-18');

select round(avg(daily_avg),2) as avg_daily
from (select count(distinct b.post_id)/count(distinct a.post_id)*100 as daily_avg
from Actions73 a left join Removals73 b on 
	a.post_id = b.post_id
    where extra = 'spam'
    group by action_date) c ;


#=====================================================================================================
/* Q.74 Write an SQL query to report the fraction of players that logged in again on the day after the day they
first logged in, rounded to 2 decimal places. In other words, you need to count the number of players
that logged in for at least two consecutive days starting from their first login date, then divide that
number by the total number of players*/                          

create table Activity74 (player_id int,device_id int,event_date date,games_played int,primary key(player_id, event_date));
insert into Activity74 values(1,2,'2016-03-01',5),(1,2,'2016-03-02',6),(2,3,'2017-06-25',1),
							(3,1,'2016-03-02',0),(3,4,'2018-07-03',5);

with cte as (select player_id,min(event_date) as start_date
from Activity74
group by player_id)

select round(count(distinct c.player_id) / (select count(distinct player_id) from Activity74),2) as fraction
from cte c join Activity74 a
on c.player_id = a.player_id and datediff(c.start_date,a.event_date) = -1;


#=====================================================================================================
/* Q.75 Write an SQL query to report the fraction of players that logged in again on the day after the day they
first logged in, rounded to 2 decimal places. In other words, you need to count the number of players
that logged in for at least two consecutive days starting from their first login date, then divide that
number by the total number of players*/


create table Activity75 (player_id int,device_id int,event_date date,games_played int,primary key(player_id, event_date));

insert into Activity75 values(1,2,'2016-03-01',5),(1,2,'2016-03-02',6),(2,3,'2017-06-25',1),(3,1,'2016-03-02',0),(3,4,'2018-07-03',5);


with cte as(select player_id,min(event_date) as start_date
from Activity75
group by player_id)

select (count(distinct c.player_id) / (select count(distinct player_id) from Activity75 )) as fraction
from cte c join Activity75 a on
c.player_id = a.player_id and
datediff(c.start_date,a.event_date) = -1;



#=====================================================================================================
/* Q.76 Write an SQL query to find the salaries of the employees after applying taxes. Round the salary to the
nearest integer.
The tax rate is calculated for each company based on the following criteria:
● 0% If the max salary of any employee in the company is less than $1000.
● 24% If the max salary of any employee in the company is in the range [1000, 10000] inclusive.
● 49% If the max salary of any employee in the company is greater than $10000.*/

create table Salaries76(company_id int,employee_id int,employee_name varchar(20),salary int,primary key(company_id, employee_id));
insert into Salaries76 values(1,1,'Tony',2000),(1,2,'Pronub',21300),(1,3,'Tyrrox',10800),(2,1,'Pam',300),
								(2,7,'Bassem',450),(2,9,'Hermione',700),(3,7,'Bocaben',100),(3,2,'Ognjen',2200),
                                (3,13,'Nyan Cat',3300),(3,15,'Morning Cat',7777);
                                
with cte as (select company_id,employee_id,max(salary) as max_salary
from Salaries76
group by company_id)

select s.company_id,s.employee_id,
	round((case when max_salary < 1000 then salary
		  when max_salary between 1000 and 10000 then salary-salary*0.24
          else salary-salary*0.49 end),0) as salary_after_tax
from cte c left join Salaries76 s on 
s.company_id = c.company_id;

#=====================================================================================================
/* Q.77 Write an SQL query to evaluate the boolean expressions in Expressions table.*/
 
create table Variables77(name varchar(20),value int,primary key(name));
create table Expressions(left_operand varchar(20),operator enum('<', '>', '='),right_operand varchar(20));

insert into Variables77 values('x',66),('y',77);
insert into Expressions values('x','>','y'),('x','<','y'),('x','=','y'),('y','>','x'),('y','<','x'),('x','=','x');

select left_operand,operator,right_operand,
		case when operator = '<' then if(a.value < b.value,'true','false')
			when operator = '>' then if(a.value > b.value,'true','false')
            else if(a.value = b.value,'true','false') end as evaluation
from Expressions e
left join Variables77 a on e.left_operand = a.name
left join Variables77 b on e.right_operand = b.name;

#=====================================================================================================
/* Q.78 A telecommunications company wants to invest in new countries. The company intends to invest in
the countries where the average call duration of the calls in this country is strictly greater than the
global average call duration.
Write an SQL query to find the countries where this company can invest.*/

create table Person78 (id int,name varchar(20),phone_number varchar(20),primary key(id));
create table Country78(name varchar(20),country_code varchar(20),primary key(country_code));
create table calls78(caller_id int,callee_id int,duration int);

insert into Person78 values(3,'Jonathan','051-1234567'),(12,'Elvis','051-7654321'),(1,'Moncef','212-1234567'),
					(2,'Maroua','212-6523651'),(7,'Meir','972-1234567'),(9,'Rachel','972-0011100');
insert into Country78 values('Peru',51),('Israel',972),('Morocco',212),('Germany',49),('Ethiopia',251);
insert into calls78 values(1,9,33),(2,9,4),(1,2,59),(3,12,102),(3,12,330),(12,3,5),(7,9,13),(7,1,3),(9,7,1),(1,7,7);


select c.name as country
from Person78 p
inner join Country78 c 
on left (p.phone_number,3) = c.country_code
inner join (select caller_id as id, duration 
            from Calls78 
            
            union all 
            
            select callee_id as id, duration 
            from Calls78) a1
on p.id = a1.id
group by country
having avg(duration) > (select avg(duration) from calls78);

#=====================================================================================================
/* Q.79 Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in
alphabetical order.
Level - Easy
Hint - Use ORDER BY*/

create table Employee79(employee_id int,name varchar(20),months int,salary int);
insert into Employee79 values(12228,'Rose',15,1968),(33645,'Angela',1,3443),(45692,'Frank',17,1608),
						(56118,'Patrick',7,1345),(59725,'Lisa',11,2330),(74197,'Kimberly',16,4372),
						(78454,'Bonnie',8,1771),(83565,'Micheal',6,2017),(98607,'Todd',5,3396),(99989,'Joe',9,3573);

select name from Employee79
order by name ASC;

                        
#=====================================================================================================
/* Q.80 Assume you are given the table below containing information on user transactions for particular
products. Write a query to obtain the year-on-year growth rate for the total spend of each product for
each year.
Output the year (in ascending order) partitioned by product id, current year's spend, previous year's
spend and year-on-year growth rate (percentage rounded to 2 decimal places).
Level - Hard
Hint - Use extract function*/

create table user_transactions (transaction_id int,product_id int,spend float,transaction_date varchar(80));
insert into user_transactions values(1341,123424,1500.60,'12/31/2019 12:00:00'),(1423,123424,1000.20,'12/31/2020 12:00:00'),
									(1623,123424,1246.44,'12/31/2021 12:00:00'),(1322,123424,2145.32,'12/31/2022 12:00:00');

with cte1 as(select EXTRACT(YEAR FROM date_format(str_to_date(transaction_date,'%m/%d/%Y %H:%i:%s'),'%Y-%m-%d %H-%m-%s')) as transaction_year,
	product_id,round(sum(spend),2) as cur_year_spend
from user_transactions
group by transaction_year),

cte2 as (select *, ifnull(lag(cur_year_spend,1) over(partition by product_id order by product_id,transaction_year ),0) as prev_year_spend
from cte1)

select transaction_year,product_id,cur_year_spend,prev_year_spend,
		ifnull(round(((cur_year_spend - prev_year_spend)/prev_year_spend)*100,2),0) as y_o_y_growth
from cte2;

#=====================================================================================================
/* Q.81 Write a SQL query to find the number of prime and non-prime items that can be stored in the 500,000
square feet warehouse. Output the item type and number of items to be stocked.
Hint - create a table containing a summary of the necessary fields such as item type ('prime_eligible',
'not_prime'), SUM of square footage, and COUNT of items grouped by the item type.*/

create table inventory81(item_id int,item_type varchar(20),item_category varchar(20),square_footage float);
insert into inventory81 values (1374,'prime_eligible','mini refrigerator',68.00),(4245,'not_prime','standing lamp',26.40),
								(2452,'prime_eligible','television',85.00),(3255,'not_prime','side table',22.60),(1672,'prime_eligible','laptop',8.50);
                                
with summary as (select item_type,sum(square_footage) as total_sqrft,count(*) as item_count from inventory81
group by item_type),

prime_items1 as (select DISTINCT item_type,total_sqrft, 
		truncate(500000/total_sqrft,0) as prime_combo,
		truncate((500000/total_sqrft)*item_count,0) as prime_items
from summary
where item_type = 'prime_eligible'),

non_prime_table as (select DISTINCT item_type,total_sqrft, 
		truncate((500000 - (select prime_combo*total_sqrft from prime_items1))/total_sqrft,0)*item_count as non_prime_combo
       from summary
where item_type = 'not_prime')

select item_type,prime_items
from prime_items1
union all
select item_type,non_prime_combo
from non_prime_table;

#=====================================================================================================
/* Q.82 . Write a query to
obtain the active user retention in July 2022. Output the month (in numerical format 1, 2, 3) and the
number of monthly active users (MAUs).
Hint: An active user is a user who has user action ("sign-in", "like", or "comment") in the current month
and last month.*/

create table user_actions82(user_id int,event_id int,event_type enum("sign-in", "like", "comment"),event_date varchar(50));
insert into user_actions82 values(445,7765,'sign-in','05/31/2022 12:00:00'),(742,6458,'sign-in','06/03/2022 12:00:00'),
	(445,3634,'like','06/05/2022 12:00:00'),(742,1374,'comment','06/05/2022 12:00:00'),(648,3124,'like','06/18/2022 12:00:00');
    
SELECT 
  EXTRACT(MONTH FROM date_format(str_to_date(curr_month.event_date,'%m/%d/%Y %H:%i:%s'),'%Y-%m-%d %H-%m-%s')) AS mth, 
  COUNT(DISTINCT curr_month.user_id) AS monthly_active_users 
FROM user_actions82 AS curr_month
WHERE EXISTS (
  SELECT last_month.user_id 
  FROM user_actions82 AS last_month
  WHERE last_month.user_id = curr_month.user_id
    AND EXTRACT(MONTH FROM date_format(str_to_date(last_month.event_date,'%m/%d/%Y %H:%i:%s'),'%Y-%m-%d %H-%m-%s')) =
    EXTRACT(MONTH FROM date_format(str_to_date(curr_month.event_date,'%m/%d/%Y %H:%i:%s'),'%Y-%m-%d %H-%m-%s') - interval 1 month)
)
  AND EXTRACT(MONTH FROM date_format(str_to_date(curr_month.event_date,'%m/%d/%Y %H:%i:%s'),'%Y-%m-%d %H-%m-%s')) = 7
  AND EXTRACT(YEAR FROM date_format(str_to_date(curr_month.event_date,'%m/%d/%Y %H:%i:%s'),'%Y-%m-%d %H-%m-%s')) = 2022
GROUP BY EXTRACT(MONTH FROM date_format(str_to_date(curr_month.event_date,'%m/%d/%Y %H:%i:%s'),'%Y-%m-%d %H-%m-%s'));    


#=====================================================================================================
/* Q.83 . Write a query to report the median of searches made by a user. Round the median to one decimal
point.
Hint- Write a subquery or common table expression (CTE) to generate a series of data (that's keyword
for column) starting at the first search and ending at some point with an optional incremental value.*/    

create table search_frequency(searches int,num_users int);
insert into search_frequency values(1,2),(2,2),(3,3),(4,1);


SELECT AVG(dd.searches) as median_val
FROM (
SELECT d.searches, @rownum:=@rownum+1 as `row_number`, @total_rows:=@rownum
  FROM search_frequency d, (SELECT @rownum:=0) r
  WHERE d.searches is NOT NULL
  ORDER BY d.searches
) as dd
WHERE dd.row_number IN ( FLOOR((@total_rows+1)/2), FLOOR((@total_rows+2)/2) );

#=====================================================================================================
/*Q.84. Write a query to update the Facebook advertiser's status using the daily_pay table. Advertiser is a
two-column table containing the user id and their payment status based on the last payment and
daily_pay table has current information about their payment. Only advertisers who paid will show up in
this table.
Output the user id and current payment status sorted by the user id.
Hint- Query the daily_pay table and check through the advertisers in this table. .*/

create table advertiser(user_id varchar(20),status varchar(20));
create table daily_pay(user_id varchar(20),paid float);

insert into advertiser values('bing','NEW'),('yahoo','NEW'),('alibaba','Existing');
insert into daily_pay values('yahoo',45.00),('alibaba',100.00),('target',13.00);

WITH payment_status AS (
SELECT
  advertiser.user_id,
  advertiser.status,
  payment.paid
FROM advertiser
LEFT JOIN daily_pay AS payment
  ON advertiser.user_id = payment.user_id

UNION

SELECT
  payment.user_id,
  advertiser.status,
  payment.paid
FROM daily_pay AS payment
LEFT JOIN advertiser
  ON advertiser.user_id = payment.user_id
)

SELECT
  user_id,
  CASE WHEN paid IS NULL THEN 'CHURN'
  	WHEN status != 'CHURN' AND paid IS NOT NULL THEN 'EXISTING'
  	WHEN status = 'CHURN' AND paid IS NOT NULL THEN 'RESURRECT'
  	WHEN status IS NULL THEN 'NEW'
  END AS new_status
FROM payment_status
ORDER BY user_id;
#=====================================================================================================
/*Q.85. Write a query that calculates the total time that the fleet of servers was running. The output should be
in units of full days.
Level - Hard
Hint1. Calculate individual uptimes
2. Sum those up to obtain the uptime of the whole fleet, keeping in mind that the result must be
output in units of full days
Assumptions:
● Each server might start and stop several times.
● The total time in which the server fleet is running can be calculated as the sum of each
server's uptime. */

create table server_utilization (server_id int,status_time varchar(50),session_status varchar(20));
insert into server_utilization values(1,'08/02/2022 10:00:00','start'),(1,'08/04/2022 10:00:00','stop'),(2,'08/17/2022 10:00:00','start')
		,(2,'08/24/2022 10:00:00','stop');
            
 with su as(select   server_id, date_format(str_to_date(status_time,'%d/%m/%Y %H:%m:%s'),'%Y-%m-%d %H:%m:%s') as status_time,session_status
 from server_utilization),
 running_time   as (          
SELECT
  server_id,
  session_status,
  status_time AS start_time,
  LEAD(status_time) OVER (
    PARTITION BY server_id
    ORDER BY status_time) AS stop_time
FROM su)

SELECT
  timestampdiff(DAY ,stop_time,start_time) AS total_uptime_days
FROM running_time
WHERE session_status = 'start'
  AND stop_time IS NOT NULL;

#=====================================================================================================
/*Q.86. Using the transactions table, identify any payments made at the same merchant with the same credit
card for the same amount within 10 minutes of each other. Count such repeated payments.
Level - Hard
Hint- Use Partition and order by
Assumptions:
● The first transaction of such payments should not be counted as a repeated payment. This
means, if there are two transactions performed by a merchant with the same credit card and
for the same amount within 10 minutes, there will only be 1 repeated payment. */

create table transactions86(transaction_id int,merchant_id int,credit_card_id int,amount int,transaction_timestamp varchar(50));
insert into transactions86 values (1,101,1,100,'09/25/2022 12:00:00'),(2,101,1,100,'09/25/2022 12:08:00'),
								(3,101,1,100,'09/25/2022 12:18:00'),(4,102,2,300,'09/25/2022 12:00:00'),(6,102,2,400,'09/25/2022 14:00:00');
                                    

with cte1 as
(select transaction_id,merchant_id,credit_card_id,amount,    
date_format(str_to_date
(transaction_timestamp,'%m/%d/%Y %H:%i:%s'),'%Y-%m-%d %H:%i:%s') as transaction_timestamp
from transactions86)
,
payment as(
select merchant_id, (transaction_timestamp - 
   lag(transaction_timestamp) over (partition by merchant_id,credit_card_id,amount order by transaction_timestamp)) as timee
from cte1)

select count(merchant_id) as count
from payment
where timee <= 10;

                
                                                               
 #=====================================================================================================
/*Q.87. Write a query to find the bad experience rate in the first 14 days for new users who signed up in June
2022. Output the percentage of bad experience rounded to 2 decimal places. */    


create table orders87(order_id int,customer_id int,trip_id int,
status enum('completed successfully', 'completed incorrectly', 'never received'),order_timestamp varchar(50));
create table trips87(dasher_id int,trip_id int,estimated_delivery_timestamp varchar(50),actual_delivery_timestamp varchar(50));
create table customers87 (customer_id int,signup_timestamp varchar(50));

insert into  orders87 values(727424,8472,100463,'completed successfully','06/05/2022 09:12:00'),
							(242513,2341,100482,'completed incorrectly','06/05/2022 14:40:00'),
                            (141367,1314,100362,'completed incorrectly','06/07/2022 15:03:00'),
                            (582193,5421,100657,'never received','07/07/2022 15:22:00'),
                            (253613,1314,100213,'completed successfully','06/12/2022 13:43:00');
                            
insert into  trips87 values(101,100463,'06/05/2022 09:42:00','06/05/2022 09:38:00'),
							(102,100482,'06/05/2022 15:10:00','06/05/2022 15:46:00'),
                            (101,100362,'06/07/2022 15:33:00','06/07/2022 16:45:00'),
                            (102,100657,'07/07/2022 15:52:00',null),
                            (103,100213,'06/12/2022 14:13:00','06/12/2022 14:10:00');
                            
insert into customers87 values(8472,'05/30/2022 00:00:00'),(2341,'06/01/2022 00:00:00'),(1314,'06/03/2022 00:00:00'),
								(1435,'06/05/2022 00:00:00'),(5421,'06/07/2022 00:00:00');

with data as(select o.order_id,o.customer_id,t.trip_id as trip_id,o.status,o.order_timestamp,pp.delivery_timediff
from orders87 o join trips87 t on o.trip_id = t.trip_id
join (select dasher_id,trip_id,(
extract(minute from date_format(str_to_date(estimated_delivery_timestamp,'%m/%d/%Y %H:%i:%s'),'%Y-%m-%d %H:%i:%s')) - 
extract(minute from date_format(str_to_date(actual_delivery_timestamp,'%m/%d/%Y %H:%i:%s'),'%Y-%m-%d %H:%i:%s'))) as delivery_timediff
from trips87) pp
on pp.delivery_timediff <= 0
where o.status in ('completed incorrectly','never received'))

select (count(distinct trip_id)/(select count(distinct trip_id) from trips87))*100 as per_of_badexp
from data;



#=====================================================================================================
/*Q.88. Write an SQL query to find the total score for each gender on each day.
Return the result table ordered by gender and day in ascending order.
The query result format is in the following examp */            

create table Scores88(player_name varchar(20),gender varchar(10),day date,score_points int,primary key(gender,day));

insert into Scores88 values('Aron','F','2020-01-01',17),('Alice','F','2020-01-07',23),('Bajrang','M','2020-01-07',7),('Khali','M','2019-12-25',11),('Slaman','M','2019-12-30',13),('Joe','M','2019-12-31',3),('Jose','M','2019-12-18',2),('Priya','F','2019-12-31',23),
                            ('Priyanka','F','2019-12-30',17);
                            
select day,gender,sum(score_points) over (partition by gender order by day) as total_points
from Scores88;	
					
                            
#=====================================================================================================
/*Q.89. Write an SQL query to find the countries where this company can invest.
Return the result table in any order */

 						
create table Person88 (id int,name varchar(20),phone_number varchar(20),primary key(id));
create table Country88(name varchar(20),country_code varchar(20),primary key(country_code));
create table calls88(caller_id int,callee_id int,duration int);

insert into Person88 values(3,'Jonathan','051-1234567'),(12,'Elvis','051-7654321'),(1,'Moncef','212-1234567'),
					(2,'Maroua','212-6523651'),(7,'Meir','972-1234567'),(9,'Rachel','972-0011100');
insert into Country88 values('Peru',51),('Israel',972),('Morocco',212),('Germany',49),('Ethiopia',251);
insert into calls88 values(1,9,33),(2,9,4),(1,2,59),(3,12,102),(3,12,330),(12,3,5),(7,9,13),(7,1,3),(9,7,1),(1,7,7);                            

select c.name as country
from Country88 c inner join Person88 p on
left (p.phone_number,3) = c.country_code 
inner join (
select caller_id as caller,duration
from calls88
union all
select callee_id as caller,duration
from calls88) phn
on p.id = phn.caller
group by country
having avg(duration) > (select avg(duration) from calls88);

    
#=====================================================================================================
/*Q.90. Write an SQL query to report the median of all the numbers in the database after decompressing the
Numbers table. Round the median to one decimal point. */

create table Numbers90 (num int,frequency int,primary key(num));

insert into numbers90 values(0,7),(1,1),(2,3),(3,1);

with recursive cte as(select num,frequency,1 as cnt
from numbers90
union
select num,frequency,cnt+1 as cnt
from cte
where cnt < frequency),
med_cte as(
select num,frequency,cnt,
 row_number() over(order by num) as rownum,
 count(*) over() as total_count
from cte)
select case when mod(total_count,2)=0 then avg(num) else num end as median
from med_cte
where rownum between total_count/2 and total_count/2+1;

#=====================================================================================================
/*Q.91. Write an SQL query to report the comparison result (higher/lower/same) of the average salary of
employees in a department to the company's average salary. */

create table Employee91(employee_id int,department_id int,primary key(employee_id));
create table Salary91(id int,employee_id int,amount int,pay_date date,primary key(id),foreign key (employee_id) references Employee91(employee_id));

insert into Employee91 values(1,1),(2,2),(3,2);
insert into Salary91 values(1,1,9000,'2017/03/31'),(2,2,6000,'2017/03/31'),(3,3,10000,'2017/03/31'),(4,1,7000,'2017/02/28'),
							(5,2,6000,'2017/02/28'),(6,3,8000,'2017/02/28');

select pay_month,dept_id,
	case when dept_avg > comp_avg then 'higher'
		when dept_avg < comp_avg then 'lower'
        else 'same' end as comparison
from (select date_format(pay_date,'%Y-%m') as pay_month,e.department_id as dept_id,avg(amount) as dept_avg,d.comp_avg as comp_avg
from Salary91 s join Employee91 e on
s.employee_id = e.employee_id 
join (select date_format(ss.pay_date,'%Y-%m') as pay_month, avg(amount) as comp_avg
		from Salary91 ss
        group by date_format(ss.pay_date,'%Y-%m')) d on
        date_format(s.pay_date,'%Y-%m') = d.pay_month
group by date_format(pay_date,'%Y-%m'),e.department_id,d.comp_avg) final;
        

#=====================================================================================================
/*Q.92. Write an SQL query to report for each install date, the number of players that installed the game on
that day, and the day one retention. */

create table Activity92(player_id int,device_id int,event_date date,games_played int,primary key(player_id, event_date));
insert into Activity92 values(1,2,'2016-03-01',5),(1,2,'2016-03-02',6),(2,3,'2017-06-25',1),(3,1,'2016-03-01',0),(3,4,'2016-07-03',5);

select t1.install_date as install_dt, count(t1.install_date) as installs,count(t2.event_date)/count(*) as day1_retention
from (select player_id,min(event_date) as install_date
from Activity92
group by 1) t1
left join Activity92 t2 on
date_add(t1.install_date, interval 1 day) = t2.event_date and
t1.player_id = t2.player_id
group by 1
order by 1;

#=====================================================================================================
/*Q.93. The winner in each group is the player who scored the maximum total points within the group. In the
case of a tie, the lowest player_id wins.Write an SQL query to find the winner in each group. */

create table players93(player_id int,group_id int,primary key(player_id));
create table Matches93(match_id int,first_player int,second_player int,first_score int,second_score int,primary key(match_id));
insert into players93 values(15,1),(25,1),(30,1),(45,1),(10,2),(35,2),(50,2),(20,3),(40,3);
insert into Matches93 values(1,15,45,3,0),(2,30,25,1,2),(3,30,15,2,0),(4,40,20,5,2),(5,35,50,1,1);


with cte1 as (select first_player as player ,first_score as score
from Matches93
union
select second_player as player ,second_score as score
from Matches93),
cte2 as (
		select p.group_id as group_id,player,sum(score) as score
        from cte1 c inner join players93 p on
        player = p.player_id
        group by p.group_id,player)

select group_id,player
from cte2
group by group_id;
        
#=====================================================================================================
/*Q.94 & 95 A quiet student is the one who took at least one exam and did not score the high or the low score.
Write an SQL query to report the students (student_id, student_name) being quiet in all exams. Do not
return the student who has never taken any exam. */

create table Student94(student_id int,student_name varchar(20),primary key(student_id));
create table Exam94(exam_id int,student_id int,score int,primary key(exam_id, student_id));

insert into Student94 values(1,'Daniel'),(2,'Jade'),(3,'Stella'),(4,'Jonathan'),(5,'Will');
insert into Exam94 values(10,1,70),(10,2,80),(10,3,90),(20,1,80),(30,1,70),(30,3,80),(30,4,90),(40,1,60),(40,2,70),(40,4,80);

select distinct s.student_id,s.student_name
from Student94 s join Exam94 e
on s.student_id = e.student_id
where s.student_id not in (
select e1.student_id
from Exam94 e1
inner join (select exam_id,min(score) as min_score,max(score) as max_score
from Exam94
group by exam_id)e2 on e1.exam_id = e2.exam_id
where e1.score = e2.min_score or e1.score = e2.max_score);

#=====================================================================================================
/*Q.96 Write a query to output the user id, song id, and cumulative count of song plays as of 4 August 2022
sorted in descending order */


create table songs_history96(history_id int,user_id int,song_id int,song_plays int);
insert into songs_history96 values(10011,777,1238,11),(12452,695,4520,1);

create table songs_weekly9116(user_id int,song_id int,listen_time varchar(50));
insert into songs_weekly9116 values(777,1238,'08/01/2022 12:00:00'),(695,4520,'08/04/2022 08:00:00'),
						(125,9630,'08/04/2022 16:00:00'),(695,9852,'08/07/2022 12:00:00');
                        
                        
select user_id,song_id,sum(song_plays)                        
from (select user_id,song_id,
	(date_format(str_to_date(listen_time,'%m/%d/%Y %H:%i:%s'),'%Y-%m-%d')) as day_date, count(*) as song_plays
from songs_weekly9116
group by song_id 
having day_date <= '2022-08-04'
union
select user_id,song_id,null,song_plays
from songs_history96)aa
group by  song_id;
                      
#=====================================================================================================
/*Q.97 New TikTok users sign up with their emails, so each signup requires a text confirmation to activate the
new user's account.
Write a query to find the confirmation rate of users who confirmed their signups with text messages.
Round the result to 2 decimal places. */

create table emails97(email_id int,user_id int,signup_date varchar(50));
create table texts97(text_id int,email_id int,signup_action varchar(20));

insert into emails97 values(125,7771,'06/14/2022 00:00:00'),(236,6950,'07/01/2022 00:00:00'),(433,1052,'07/09/2022 00:00:00');
insert into texts97 values(6878,125,'Confirmed'),(6920,236,'Not Confirmed'),(6994,236,'Confirmed');

with cte1 as (select e.email_id,user_id,case when t.email_id is not null then 1 else 0 end as activation_count
from emails97 e left join texts97 t
on e.email_id = t.email_id and signup_action = 'Confirmed')

select round(sum(activation_count)/count(user_id)*100,2) as rate
from cte1;



#=====================================================================================================
/*Q.98  Calculate the 3-day rolling average of tweets published by each user for each date that a tweet was posted. Output the
user id, tweet date, and rolling averages rounded to 2 decimal places.
Hint- Use Count and group by */


create table tweets98(tweet_id int,user_id int,tweet_date varchar(50));
insert into tweets98 values(214252,111,'06/01/2022 12:00:00'),(739252,111,'06/01/2022 12:00:00'),(846402,111,'06/02/2022 12:00:00'),
					(241425,254,'06/02/2022 12:00:00'),(137374,111,'06/04/2022 12:00:00');
    
with cte1 as(select user_id,date_format(str_to_date(tweet_date,'%d/%m/%Y %H:%i:%s'),'%d-%m-%Y') as tweetdate,count(distinct tweet_id) as tweet_num
from tweets98
group by user_id,tweet_date)

select user_id,tweetdate,tweet_num, avg(tweet_num) over (partition by user_id order by user_id,tweetdate rows between 2 preceding and current row) as roll_avg
from cte1;



                    

#=====================================================================================================
/*Q.99  Assume you are given the tables below containing information on Snapchat users, their ages, and
their time spent sending and opening snaps. Write a query to obtain a breakdown of the time spent
sending vs. opening snaps (as a percentage of total time spent on these activities) for each age
group.
Hint- Use join and case
Output the age bucket and percentage of sending and opening snaps. Round the percentage to 2
decimal places. */

create table activities99(activity_id int,user_id int,activity_type enum('send', 'open', 'chat'),time_spent float,activity_date varchar(50));
create table age_breakdown99(user_id int,age_bucket enum('21-25', '26-30', '31-25'));

insert into activities99 values(7274,123,'open',4.50,'06/22/2022 12:00:00'),(2425,123,'send',3.50,'06/22/2022 12:00:00'),
(1413,456,'send',5.67,'06/23/2022 12:00:00'),(1414,789,'chat',11.00,'06/25/2022 12:00:00'),(2536,456,'open',3.00,'06/25/2022 12:00:00');
insert into age_breakdown99 values(123,'31-25'),(456,'26-30'),(789,'21-25');


with cte1 as(select ab.age_bucket, sum(case when a.activity_type = 'open' then a.time_spent else 0 end ) as open_time,
	sum(case when a.activity_type = 'send' then a.time_spent else 0 end ) as sent_time
    from activities99 a join age_breakdown99 ab on
    a.user_id = ab.user_id
    group by ab.age_bucket)
    
select round((open_time/(open_time+sent_time)*100),2) as open_perc,round((sent_time/(open_time+sent_time)*100),2) as sent_perc
from cte1;


#=====================================================================================================
/*Q.100 The LinkedIn Creator team is looking for power creators who use their personal profile as a company
or influencer page. This means that if someone's Linkedin page has more followers than all the
companies they work for, we can safely assume that person is a Power Creator. Keep in mind that if a
person works at multiple companies, we should take into account the company with the most
followers.
Level - Medium
Hint- Use join and group by
Write a query to return the IDs of these LinkedIn power creators in ascending order */


create table personal_profiles(profile_id int,name varchar(20),followers int);
create table employee_company(personal_profile_id int,company_id int);
create table company_pages(company_id int,name varchar(50),followers int);

insert into personal_profiles values(1,'Nick Singh',92000),(2,'Zach Wilson',199000),(3,'Daliana Liu',171000),(4,'Ravit Jain',107000),
			(5,'Vin Vashishta',139000),(6,'Susan Wojcicki',39000);
            
insert into employee_company values(1,4),(1,9),(2,2),(3,1),(4,3),(5,6),(6,5);
insert into company_pages values(1,'The Data Science Podcast',8000),(2,'Airbnb',700000),(3,'The Ravit Show',6000),(4,'DataLemur',200),
			(5,'YouTube',16000000),(6,'DataScience.Vin',4500),(9,'Ace The Data Science Interview',4479);

with cte1 as(select personal_profile_id as pfid,p.followers as personal_fol,max(c.followers) as comp_follower
from employee_company e join company_pages c on
e.company_id = c.company_id join
personal_profiles p on e.personal_profile_id = p.profile_id 
group by personal_profile_id
order by personal_profile_id)

select pfid from cte1
where personal_fol > comp_follower;
