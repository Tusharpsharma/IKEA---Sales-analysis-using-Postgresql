
--Question 1.	Identify products that have never been sold in any store.
select * from sales 
select * from products
select * from stores
select * from inventory

select  pr.product_id,pr.product_name,st.store_name,s.order_id
from stores st 
join sales s
on st.store_id = s.store_id
left join products pr
on pr.product_id = s.product_id
where s.order_id is null


--Question 2.	Find stores where the total sales revenue is higher than the average revenue across all stores.

WITH cte1 AS (
    SELECT 
        st.store_name AS store_name,
        SUM(s.qty * s.unit_price) AS total_revenue
    FROM stores st
    JOIN sales s ON st.store_id = s.store_id
    GROUP BY st.store_name
),
cte2 AS (
    SELECT 
        AVG(total_revenue) AS average_revenue
    FROM cte1
)
SELECT 
    store_name
FROM cte1
WHERE total_revenue > (SELECT average_revenue FROM cte2);

--Question 3. Display products whose average unit price in sales transactions is lower than their listed price in the products table.
select * from sales 
select * from products
select * from stores
select * from inventory

WITH cte1 AS (
    SELECT 
        s.product_id AS product_id, 
        pr.product_name AS product_name, 
        SUM(s.qty * s.unit_price) AS total_revenue
    FROM sales s
    JOIN products pr ON pr.product_id = s.product_id
    GROUP BY s.product_id, pr.product_name
), 
cte2 AS (
    SELECT 
        cte1.product_name AS product_name, 
        AVG(cte1.total_revenue) AS average_unit_price
    FROM cte1
    GROUP BY cte1.product_name
)
SELECT 
    cte2.product_name, 
    cte2.average_unit_price
FROM cte2
WHERE average_unit_price < (
    SELECT SUM(pr.unit_pice)  -- Using SUM of unit_price as in your subquery
    FROM products pr
    WHERE pr.product_name = cte2.product_name
    GROUP BY pr.product_name
    
);

/*
4.	Use a correlated subquery to find products whose sales exceeded the average sales of their category. 
(Find Best Selling Products of Each Category)
*/
select * from sales 
select * from products
select * from stores
select * from inventory

/*ALTER TABLE sales
ADD COLUMN total_revenue DECIMAL(10, 2);  -- Adjust the data type based on your requirements
UPDATE sales
SET total_revenue = qty * unit_price;
*/

--Use a correlated subquery to find products whose sales exceeded the average sales of their category. 
(Find Best Selling Products of Each Category)

with cte1
as
(
select pr.product_id as product_id, pr.product_name as product_name,s.total_revenue as total_revenue
from products pr
join sales s
on pr.product_id = s.product_id
group by 1,2,3
)
select 	product_id,product_name,total_revenue
from cte1
where total_revenue >  
					(select avg(s.total_revenue) from sales s
   					where s.product_id = cte1.product_id)



---or----------------------------------- using correlated subquery-------------------
SELECT 
    pr.product_id, 
    pr.product_name, 
    SUM(s.qty * s.unit_price) AS total_revenue
FROM products pr
JOIN sales s ON pr.product_id = s.product_id
GROUP BY pr.product_id, pr.product_name
HAVING SUM(s.qty * s.unit_price) > (
    SELECT AVG(s2.qty * s2.unit_price)
    FROM sales s2
    WHERE s2.product_id = pr.product_id
);

--Question 5.List cities with total sales greater than the average sales for their country.
select * from sales 
-- select * from products
select * from stores
-- select * from inventory

select st.city, s.total_revenue
from stores st 
join sales s
on st.store_id = s.store_id
group by 1,2
having s.total_revenue > (select avg(s2.total_revenue) from sales s2
	                      join stores st2
						  on st2.store_id = s2.store_id
	                      group by st2.country
	                      limit 1)
	


