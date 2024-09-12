select*from df_order
-- finding top 10 products by sales revenue
SELECT product_id, SUM(selling_price) AS sales
FROM df_order
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;

-- finding highest selling products in eacg region
SELECT region,product_id,sum(selling_price) AS sales FROM df_order
GROUP BY region,product_id
ORDER BY region,sales DESC;


SELECT DISTINCT region FROM df_order;

-- comparision of sales month wise over the years
SELECT year(order_date) as order_year,month(order_date) as order_month,
sum(selling_price) as sales
FROM df_order
group by order_year,order_month
order by order_year,order_month DESC;

-- finding highest sale for a cateogary based on year and month
WITH cte AS (
    SELECT 
        category, 
        DATE_FORMAT(order_date, '%Y %m') as y_m,
        SUM(selling_price) as sales
    FROM df_order
    GROUP BY category, DATE_FORMAT(order_date, '%Y %m')
)
SELECT * 
FROM (
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY category ORDER BY sales) as rn
    FROM cte
) a
WHERE rn <= 2;

-- finding which subcategory had the better growth by profit in 2023 compared to 2022
with cte as (
select category,sub_category,date_format(order_date,'%Y') as yr, sum(selling_price) as sale
from df_order
group by category,sub_category, yr
order by category )
select * from (select *,
row_number() over(partition by category,sub_category order by sale ) as rn
from cte) where yr(2023,sale) >yr(2022,sale)

