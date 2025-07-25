create database sql_project_p1;
show databases;
use sql_project_p1;

create table retail_sales
					(
					transactions_id int primary key,
					sale_date date,
					sale_time time,
					customer_id int,
					gender varchar(20),
					age int,
					category varchar(20),
					quantiy int,
					price_per_unit float,
					cogs int,
					total_sale float
					);
                    
                    
select * from retail_sales;
select count(*) from retail_sales;
select * from retail_sales
where total_sale is null;

alter table retail_sales
rename column quantiy to quantity;

select * from retail_sales
		where transactions_id is null
		or
		sale_date is null
		or 
		sale_time is null
		or
		customer_id is null
		or
		gender is null
		or
		age is null
		or
		category is null
		or
		quantity is null
		or
		price_per_unit
		or
		cogs is null
		or
		total_sale is null;
delete from retail_sales
where transactions_id is null
		or
		sale_date is null
		or 
		sale_time is null
		or
		customer_id is null
		or
		gender is null
		or
		age is null
		or
		category is null
		or
		quantity is null
		or
		price_per_unit
		or
		cogs is null
		or
		total_sale is null;

set sql_safe_updates = 1;

# data exploration
-- how many sales we have?
select count(*) as total_sales from retail_sales ;
select * from retail_sales;
-- how many customers we have?
select count( customer_id) from retail_sales;

-- how many unique customers we have?
select count(distinct customer_id) from retail_sales;

-- how many category we have?
select count(distinct category) as total_category from retail_sales;

-- data analysis and business key problems:
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q1 write a query to fetch all the columns sales made on '2022-11-05'
select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
select  * from retail_sales
where category = 'Clothing'
and sale_date = '2022-11';

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND MONTH(sale_date) = 11
  AND YEAR(sale_date) = 2022
  and quantity >= 4;

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
 and quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as total_sales,count(*) as total_orders from retail_sales
group by category;

-- -- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2)  as avg_age from retail_sales
where category = 'Beauty';
-- -- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select transactions_id from retail_sales where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(transactions_id) as total_transaction from retail_sales
group by
category, gender;
-- -- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from (
select year(sale_date) as year,month(sale_date) as month, round(avg(total_sale),2) as avg_sales,
rank() over(partition by year(sale_date) order by round(avg(total_sale),2) desc) as rankk
 from retail_sales
group by year,month) as t1
where rankk = 1;
-- order by year, avg_sales desc;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from (
select year(sale_date) as year,month(sale_date) as month, round(avg(total_sale),2) as avg_sales,
rank() over(partition by year(sale_date) order by round(avg(total_sale),2) desc) as rankk
 from retail_sales 
group by year,month) as t1
where rankk = 1;
-- order by year,avg_sales desc;
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,sum(total_sale) as max_sales from retail_sales
group by customer_id
order by max_sales desc
limit 5;
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) as distinct_customer from retail_sales
group by category;
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sales as (

select *, case
 when hour(sale_time) < 12 then 'Morning'
 when hour(sale_time) between 12 and 17 then 'Afternoon'
 else 'evening'
 end as shift
 from retail_sales
 )
select shift,count(*) total_orders from hourly_sales
group by shift;

-- end of projects;

