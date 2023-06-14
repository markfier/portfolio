--SQL script example
SELECT * FROM emails LIMIT 2;

SELECT * FROM customers LIMIT 2;

SELECT * FROM dealerships LIMIT 2;

select * from sales limit 2;

SELECT version()

select first_name
from  customers
where state = 'AZ'
order by first_name;

select * 
from products;

--model names of products in 2014

select model
from products 
where year = 2014
order by model;

--model names of products in 2014 with msrp < 1000

select model, year , base_msrp
from products 
where year = 2014 and base_msrp < 1000
order by model;

--model names of products in 2014 or product type is automobile
select model, year , product_type, base_msrp
from products 
where year = 2014 or product_type = 'automobile'
order by model;

--using 'in' function
select model
from products 
where year in (2014,2016,2019)
order by model;

--using 'not in' function
select model
from products 
where year not in (2015,2017)
order by model;

--'order by' keyword and various options
--list products ordered by production date (earliest to latest)
select *
from products
order by production_start_date;

--same thing except ordering by column number
select *
from products
order by 1;
--first column is product_id
--you can use this for all the columns, it's just hard to remember what number referes to what column

--Ex 6 from book
--get online usernames, first 10 female salespeople hired, order from first hire to latest hire

select username
from salespeople
where gender = 'Female'
	and termination_date is NULL
order by hire_date asc
limit 10;

--create table
create table state_populations(
	state varchar(2) primary key,
	population numeric
);

select * from state_populations;

--create table using select()
create table products_2014 as (
select *
from products
where year = 2014

);

--adding columns to existing table 
alter table products
add column weight int;

select * from products 

--drop column from table
alter table products
drop column weight;

select * from products;

--insert new product into products table

insert into products (product_id, model,year,product_type,base_msrp,production_start_date, production_end_date)
values (13,'Nimbus 5000',2019,'scooter',500.00,'2019-03-03','2020-03-03');

select * from products;

--insert rows using select
insert into products (product_id, model,year,product_type,base_msrp,production_start_date, production_end_date)
select *
from products 
where year = 2014;

select * from products;

--update existing rows in a table
update products
set base_msrp = 299.99
where year < 2018 and product_type = 'scooter';

select * from products;

--delete entry from table
update customers
set email = NULL
where customer_id = 3;

select * 
from customers 
where customer_id = 3;

--delete rows from table
delete from customers
where email = 'bjordan2@geocities.com';

--deleting all info from a table 
--delete from customers

--deleting a table
--drop table customers

select * from salespeople limit 10;

select *
from salespeople
where dealership_id is null

--Figure out which salespeople work in CA
--Issue: state is not listed in salesperson table
--Solution: find relationship between dealership ID and state, use where clause to pull salespeople with corresponding ID

select * from dealerships where state = 'CA'

select * 
from salespeople 
where dealership_id in (2,5)

--This isn't efficient, hence use join clause

--Join salespeople and dealership table
select *
from salespeople
join dealerships
on salespeople.dealership_id = dealerships.dealership_id
order by salesperson_id

--now use where clause to subset rows
select *
from salespeople
inner join dealerships
on salespeople.dealership_id = dealerships.dealership_id
where state = 'CA'
order by salesperson_id

--aliasing to make code shorter
select *
from salespeople as s --left table
inner join dealerships as d -- right table
on s.dealership_id = d.dealership_id
where d.state = 'CA'
order by salesperson_id

--using left join
select * 
from customers as c
left join emails as e 
on e.customer_id = c.customer_id
order by c.customer_id
limit 100;

--right join would flip the order of customers and emails

--select customers who bought a car
select c.customer_id, c.first_name, c.last_name, c.phone
from customers as c
join sales as s on c.customer_id = s.customer_id
join products as p on s.product_id = p.product_id
where p.product_type = 'automobile'
order by c.customer_id
limit 50;

--subquery
--salespeople in CA

select *
from salespeople as s
join(select * from dealerships where state = 'CA') as d
on s.dealership_id = d.dealership_id

--salespeople in CA version 2
select *
from salespeople
where dealership_id in
(select dealership_id
from dealerships
where state = 'CA');

--union function
--create list of addresses for customers and dealerships 

(select street_address, city, state, postal_code
from customers
where street_address is not null)
union 
(select street_address, city, state, postal_code
from dealerships
where street_address is not null);

--common table expression
with d as(
select dealership_id
from dealerships
where state = 'CA')
select *
from salespeople as s
join d on s.dealership_id = d.dealership_id; 

--exercise 12 using case when
select customer_id, state, 
case when state in ('MA', 'NH', 'VT', 'ME', 'CT') then 'New England'
	 when state in ('GA', 'FL', 'MS', 'AL', 'LA', 'KY', 'VA', 'NC','SC','TN','VI','WV','AR') then 'Southeast'
	 else 'Other' end as region
from customers
order by customer_id

--coalesce function 
select customer_id, coalesce(phone,'no phone') as phone
from customers
order by customer_id
--this is useful to replace null values, can also be used to replace nulls
--with another value from table if specified

--nullif function 
select customer_id,
nullif(title,'Honorable') as title2
from customers 
limit 10;

--least/greatest function look up on your own

--casting function
--convert year from int to text
select product_id, year::text, product_type
from products

--distinct function
select distinct year
from products 
order by year;

select distinct on (first_name) *
from salespeople
order by first_name, hire_date;

--aggregation

select count(customer_id)
from customers;

select count(distinct customer_id)
from customers;

select count(*)
from customers 
where state = 'CA';

select sum(base_msrp), avg(base_msrp), min(base_msrp), max(base_msrp), stddev(base_msrp)
from products;

--group by
-- count number of customers by state
select state, count(*)
from customers
group by state
order by state;

select state, count(*)
from customers
where gender ='M'
group by state
order by state;

select gender, state, count(*)
from customers
group by state, gender
order by state, gender

-- grouping sets allow for multiple levels of aggregation 
select state, gender, count(*)
from customers
group by grouping sets(
(state),
(gender),
(state,gender)
)
order by state, gender

--using having function, filters based on aggregate values unlike where function which filters by values in rows
select state, count(*)
from customers
group by state
having count(*)>=1000
order by state;

--window functions (will def be on midterm)

--get a ranking of customers in order of data_added
select *
from customers
order by date_added;

select  date_added, count(*)
from customers
group by date_added
order by date_added;

--these queries aren't efficient, use window function instead

select customer_id, title, first_name, last_name, gender,
count(*) over() as total_customers
from customers
order by customer_id;

--this just adds count(*) to its own column for each row

--two basic keywords for window specification: partition by and order by
select customer_id, title, first_name, last_name, gender,
count(*) over(partition by first_name) as total_customers
from customers
order by customer_id;

select customer_id, title, first_name, last_name, gender,
count(*) over(order by customer_id) as total_customers
from customers
order by customer_id;

--total_customers value is a count of the accumulating rows when ordering by customer_id

select customer_id, title, first_name, last_name, gender,
count(*) over(order by first_name) as total_customers
from customers
--order by first_name;

select customer_id, title, first_name, last_name, gender,
count(*) over(partition by gender order by customer_id) as total_customers
from customers
order by customer_id;

--partition by always comes before order by in window function 

--running total of customers with completed street address

select customer_id, date_added, street_address,
sum(case when street_address is not null then 1 else 0 end) over(order by date_added) 
as total_completed_street_address 
from customers
order by date_added, customer_id;

--same result using aliasing

select customer_id, date_added, street_address,
sum(case when street_address is not null then 1 else 0 end) over w
as total_completed_street_address 
from customers
window w as (order by date_added)
order by date_added, customer_id;

-- extra, how to get distinct dates using common table expression
with tpd as (select customer_id, date_added, street_address,
sum(case when street_address is not null then 1 else 0 end) over(order by date_added) 
as total_completed_street_address 
from customers
order by date_added, customer_id
)
select distinct date_added, total_completed_street_address
from tpd
order by date_added;

--order by is cummulative partition by is not
--midterm covers up to window functions

--7 day rolling avg sales
--step 1: aggregate sales at the daily level using cte

with daily_sales as (select sales_transaction_date::date as sales_dt, sum(sales_amount) as total_sales
from sales
group by sales_dt
order by sales_dt),
--step 2
moving_avg_calc_7 as (
select sales_dt, total_sales,
	avg(total_sales) over(order by sales_dt rows between 7 preceding and 1 preceding) 
	as sales_moving_avg_7,
	row_number() over(order by sales_dt) as row_number
from daily_sales
order by sales_dt
)
--step 3
select sales_dt,
case when row_number >= 8 then sales_moving_avg_7 else null end as sales_moving_avg_7
from moving_avg_calc_7;

with state_sales as (
select *
from sales as s
left join customers as c
on s.customer_id = c.customer_id)


select round(sum(sales_amount::decimal),2) as total_sales_amount, state 
from state_sales
where sales_transaction_date >= '2017-01-01' and state is not null
group by state 
order by total_sales_amount desc;

