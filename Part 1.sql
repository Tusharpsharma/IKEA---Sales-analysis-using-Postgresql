-- IKEA Project SCHEMA

DROP TABLE IF EXISTS inventory, sales, products, stores;

-- Product Table
CREATE TABLE products
(
	product_id VARCHAR(10) PRIMARY KEY,	
	product_name VARCHAR(35) ,
	category	VARCHAR(20),
	subcategory	VARCHAR(20),
	unit_pice FLOAT
);

-- Stores Table

CREATE TABLE stores
(
	store_id	VARCHAR(10) PRIMARY KEY,
	store_name	VARCHAR(25),
	city	VARCHAR(25),
	country VARCHAR(25)
);

-- Sales Table

CREATE TABLE sales
(
	order_id 	VARCHAR(10) PRIMARY KEY,
	order_date	DATE,
	product_id	VARCHAR(10) REFERENCES products(product_id), --FK
	qty	INT,
	discount_percentage	FLOAT,
	unit_price FLOAT,	
	store_id VARCHAR(10) REFERENCES stores(store_id) --FK
);


-- Inventory Table
CREATE TABLE inventory
(
	inventory_id SERIAL PRIMARY KEY,
	product_id	VARCHAR(10) REFERENCES products(product_id), --FK
	current_stock 	INT,
	reorder_level INT
);

SELECT 'All table created!';

--Question 1.	Find the total quantity sold for each product category across all stores.

select * from sales
select * from products
select * from stores
select * from inventory

select pr.category, st.store_name, round(sum(s.qty * s.unit_price ::numeric),2) as total_sales
from stores st 
join sales s
on st.store_id = s.store_id
join products pr
on pr.product_id = s.product_id
group by 1,2
order by 1,2

--Question 2. List each store's total sales revenue, including both discounted and non-discounted prices.

select st.store_name, 
	sum(s.qty * s.unit_price :: numeric) - 
	(sum(s.qty * s.unit_price * s.discount_percentage :: numeric)) as Total_sale_revenue
from stores st 
join sales s
on st.store_id = s.store_id
group by 1


--Question 3.	Identify the top three products with the highest sales quantity in each country.
select * from sales
select * from products
select * from stores

select *
FROM
(select st.country,pr.product_name, sum(s.qty * s.unit_price) as total_sale,
dense_rank() over (partition by st.country order by  sum(s.qty * s.unit_price) desc ) rk
from stores st 
join sales s
on st.store_id = s.store_id
join products pr
on pr.product_id = s.product_id
group by 1,2
order by sum(s.qty * s.unit_price) desc)
where rk<= 3


--Question 4.	Calculate the average discount given per product category across all stores.
select * from sales
select * from products
select * from stores


SELECT 
    pr.category AS prod_category,
    AVG(s.qty * s.unit_price * s.discount_percentage ) AS avg_discount_per_category
FROM 
    sales s
JOIN 
    products pr
ON 
    s.product_id = pr.product_id
GROUP BY 
    pr.category
ORDER BY 
    avg_discount_per_category DESC;


-- Question 5.	Find the number of unique products sold in each store within the "Furniture" category.

select * from sales
select * from products
select * from stores


select distinct pr.product_name as product_name, st.store_name as store_name, 
	            count(s.order_id) as total_sales_unit
from stores st 
join sales s
on st.store_id = s.store_id
join products pr
on pr.product_id = s.product_id
where pr.category = 'Furniture'
group by 1,2
order by total_sales_unit desc


---Case Statements
--Question 1.Categorize stores based on sales performance as "High," "Medium," or "Low" using the total sales revenue.
select * from sales
select * from products
select * from stores
	
select st.store_name, sum(s.qty * s.unit_price) as total_sale,
				CASE 
        		WHEN SUM(s.qty * s.unit_price) > 70000 THEN 'High_sale'
        		WHEN SUM(s.qty * s.unit_price) > 50000 THEN 'Medium_sale'
        		ELSE 'Low_sale'
	            END AS Sale_Performance
from stores st 
join sales s
on st.store_id = s.store_id
join products pr
on pr.product_id = s.product_id
group by 1

	/*
--Question 3.Display the reorder status for each product in inventory as "Low Stock" 
if current stock is below the reorder level, otherwise "Sufficient Stock."
*/
select * from sales
select * from products
select * from stores
select * from inventory

select *, case
		  when current_stock < reorder_level then 'Low Stock'
          else 'Sufficient Stock'
		  END as Stock_level
from inventory

/*
--Question 4.	
 Identify each store’s top-selling product and categorize it as “Top Performer” or “Underperformer” 
  based on a specified sales quantity threshold.
*/
select * from sales
select * from products
select * from stores
select * from inventory

with cte1
as
(select st.store_name as store_name, pr.category as category, sum(s.qty * s.unit_price) as Total_sales
from stores st 
join sales s
on st.store_id = s.store_id
join products pr
on pr.product_id = s.product_id
group by 1,2)

select store_name,category, 
		case  when Total_sales > 40000 then 'Top Performer'
		else 'Underperformer'
        end as performace_case
from cte1
order by 1,2
							
-- Window FUNCTIONS
--Question 1.List the top five products by sales quantity within each store.

select * from sales
select * from products
select * from stores
select * from inventory

select *
from
(
select st.store_name,
       pr.product_name,
       Dense_rank() over (partition by st.store_name order by sum(s.qty * s.unit_price) desc) as rk

from stores st 
join sales s
on st.store_id = s.store_id
join products pr
on pr.product_id = s.product_id
group by 1,2
)
where rk < 5

--Question 2.Rank each product by quantity sold in each store.


select * from sales
select * from products
select * from stores
select * from inventory



select pr.product_name, st.store_name, sum(s.qty) as qty_sold,
      dense_rank() over(partition by st.store_name order by sum(s.qty) desc) as rk
from stores st 
join sales s
on st.store_id = s.store_id
join products pr
on pr.product_id = s.product_id
group by 1,2
order by 3 desc

--- Question 3.	Retrieve the top-selling product in each category.
-- select * from sales
-- select * from products
-- select * from stores
-- select * from inventory

select  pr.category, pr.product_name,
      sum(s.qty) as total_quentity,
       Dense_rank() over (partition by pr.category order by sum(s.qty) desc)

from stores st 
join sales s
on st.store_id = s.store_id
join products pr
on pr.product_id = s.product_id
group by 1,2
order by 3 desc

-- Question 4.	Get RANK for each store based on total revenue.
select * from sales
select * from products
select * from stores
select * from inventory

select st.store_name, sum(s.qty * s.unit_price) as total_sale_revenue,
rank() over(order by sum(s.qty * s.unit_price) desc )

from stores st 
join sales s
on st.store_id = s.store_id
join products pr
on pr.product_id = s.product_id
group by 1
order by 2 desc

--Question 5.	Use ROW_NUMBER to find the first sale of each product in each store.
select * from sales
select * from products
select * from stores
select * from inventory



select pr.product_name,st.store_name, 
s.order_date,
sum(s.qty) as qty_sold,
row_number() over (partition by pr.product_name,st.store_name order by s.order_date) as sale_by_date
from stores st 
join sales s
on st.store_id = s.store_id
join products pr
on pr.product_id = s.product_id
group by 1,2,3
order by s.order_date

---Question 7.	Assign a unique ranking to each product based on its sales quantity, grouped by country.
select * from sales
select * from products
select * from stores
select * from inventory


select st.country, pr.product_name, sum(s.qty * s.unit_price) as total_sale_revenue
from stores st 
join sales s
on st.store_id = s.store_id
join products pr
on pr.product_id = s.product_id
group by 1,2
order by sum(s.qty * s.unit_price) desc

