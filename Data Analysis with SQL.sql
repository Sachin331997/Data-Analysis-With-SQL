-- 1. Print the entire data of all the customers.

select * from cust_dimen;

-- 2. List the names of all the customers.

select Customer_Name from cust_dimen;

-- 3. Print the name of all customers along with their city and state.

select Customer_Name,City,State from cust_dimen;

-- 4. Print the total number of customers.

select count(Cust_Id) as Total_Customers from cust_dimen;

-- 5. How many customers are from West Bengal?

select count(Cust_Id) as Bengal_customers 
from cust_dimen 
where State="West Bengal";

-- 6. Print the names of all customers who belong to West Bengal.

select Customer_Name 
from cust_dimen 
where state="West Bengal";

-- 7. Print the names of all customers who are either corporate or belong to Mumbai.

select Customer_Name,City,Customer_Segment 
from cust_dimen 
where City="Mumbai" or Customer_Segment="CORPORATE";

-- 8. Print the names of all corporate customers from Mumbai.

select Customer_Name,City,Customer_Segment 
from cust_dimen 
where City="Mumbai" and Customer_Segment="CORPORATE";

-- 9. List the details of all the customers from southern India: namely Tamil Nadu, Karnataka, Telangana and Kerala.

select * from cust_dimen where State in("Tamil Nadu", "Karnataka", "Telangana" ,"Kerala");

-- 10. Print the details of all non-small-business customers.

select * from cust_dimen where Customer_Segment !="SMALL BUSINESS";

-- 11. List the order ids of all those orders which caused losses.

select Ord_id,Profit from market_fact_full where Profit<0;


-- 12. List the orders with '_5' in their order ids and shipping costs between 10 and 15.

select Ord_id,Shipping_Cost from market_fact_full where Ord_id LIKE "%_5%" and Shipping_Cost between 10 and 15;

-- 13. Find the total number of sales made.

select count(Sales) as No_of_Sales from market_fact_full;

-- 14. What are the total numbers of customers from each city?

select City,count(Cust_id) as City_wise_cust_count from cust_dimen group by City;

-- 15. What are the total numbers of customers by each city and customer segment?

select Customer_Segment ,City,count(Cust_id) as City_wise_cust_count from cust_dimen 
group by Customer_Segment,City
order by Customer_Segment,City_wise_cust_count desc;

-- 16. Find the number of orders which have been sold at a loss.

select count(Ord_id) as loss_count from market_fact_full where Profit<0;

-- 17. Find the total number of customers from Bihar in each segment.

select Customer_Segment,count(Cust_id) as Cust_count 
from cust_dimen where State="Bihar" 
group by Customer_Segment;

-- 18. Find the customers who incurred a shipping cost of more than 50.

select Cust_id from market_fact_full 
where Shipping_Cost>50;

-- 19. List the customer names in alphabetical order.

select distinct Customer_Name from cust_dimen order by Customer_Name;

-- 20. Print the three most ordered products.

select Prod_id,sum(Order_Quantity) as Order_Quantity
from market_fact_full 
group by Prod_id  
order by sum(Order_Quantity) desc 
limit 3;

-- 21. Print the three least ordered products.

select Prod_id,sum(Order_Quantity) 
from market_fact_full 
group by Prod_id 
order by sum(Order_Quantity) 
limit 3;

-- 22. Find the sales made by the five most profitable products.

select Prod_id,Profit,round(sales,2) as Sales 
from market_fact_full sales 
order by Profit desc 
limit 5;

-- 23. Arrange the order ids in the order of their recency.

select Ord_id,Order_Date 
from orders_dimen 
order by order_Date desc;

-- 24. Arrange all consumers from Coimbatore in alphabetical order.

select Customer_Name,City 
from cust_dimen 
where City ="Coimbatore" 
order by Customer_Name;

-- 25. Print the product names in the following format: Category_Subcategory.

select Product_Category,Product_Sub_Category,concat(Product_Category,"_",Product_Sub_Category) as Product_Name 
from prod_dimen;

-- 26. In which month were the most orders shipped?

select month(Ship_date) as ship_month,count(Ship_id) as ship_count 
from shipping_dimen 
group by ship_month 
order by ship_count desc limit 1;

-- 27. Which month and year combination saw the most number of critical orders?

select year(Order_Date) as Year,month(Order_Date) as Month,count(Ord_id)  as Order_Count
from orders_dimen
where Order_Priority="CRITICAL" 
group by year(Order_Date),month(Order_Date) 
order by count(Ord_id) DESC 
LIMIT 1;

-- 28. Find the most commonly used mode of shipment in 2011.

select Ship_Mode,count(Ship_id) as ship_count 
from shipping_dimen 
where year(Ship_Date)=2011 
group by Ship_Mode 
order by count(Ship_id) desc;

-- 29. Find the names of all customers having the substring 'car'.

select customer_name 
from cust_dimen 
where customer_name regexp "car";

-- 30. Print customer names starting with A, B, C or D and ending with 'er'.

select customer_name from cust_dimen where customer_name regexp "^[ABCD].*er$";

-- 31. Print the order number of the most valuable order by sales.

select Ord_id,round(Sales,2) as Sales 
from market_fact_full 
where Sales = (select max(Sales) from market_fact_full);

-- 32. Return the product categories and subcategories of all the products which don’t have details about the product
-- base margin.

select Prod_id,Product_Category,Product_Sub_Category
from prod_dimen 
where Prod_id in 
(select Prod_id from market_fact_full where Product_Base_Margin is null);

-- 33. Print the name of the most frequent customer.

select Cust_id,Customer_Name 
from cust_dimen 
where Cust_id =
(select cust_id 
from market_fact_full 
group by cust_id 
order by count(Cust_id) desc 
limit 1);

-- 34. Print the three most common products.

select Product_Category 
from prod_dimen 
where Prod_id in
(select Prod_id 
from market_fact_full 
group by Prod_id 
order by count(Prod_id) desc 
limit 3);

-- 35. Find the 5 products which resulted in the least losses. Which product had the highest product base
-- margin among these?

with least_losses as 
(select Prod_id,Profit,Product_base_margin 
from market_fact_full 
where Profit<0 
order by Profit desc 
limit 5)
Select * from least_losses 
where Product_base_margin=(select max(Product_base_margin) 
from least_losses);

-- 36. Find all low-priority orders made in the month of April. Out of them, how many were made in the first half of
-- the month?

With low_priority_orders_summary as
(select Ord_id,Order_Date,Order_Priority 
from orders_dimen 
where month(Order_Date)=04 and Order_Priority="LOW")
Select count(Ord_id) as orders_count
from low_priority_orders_summary 
where day(Order_Date) between 1 and 15;

-- 37. Create a view to display the sales amounts, the number of orders, profits made and the shipping costs of all
-- orders. Query it to return all orders which have a profit of greater than 1000.

create view Order_summary as
(Select Ord_id,Sales,Order_Quantity,Profit,Shipping_Cost 
from market_fact_full);
select Ord_id,Profit 
from Order_summary 
where Profit>1000;

-- 38. Print the product categories and subcategories along with the profits made for each order.

Select p.Prod_id,p.Product_Category,p.Product_Sub_Category,m.Profit 
from prod_dimen p 
inner join market_fact_full m
on p.Prod_id=m.Prod_id;

# --------------------------or------------

Select Prod_id,Product_Category,Product_Sub_Category,Profit
from prod_dimen
inner join market_fact_full using(Prod_id);

-- 38. Find the shipment date, mode and profit made for every single order.

select Order_ID,Ship_Mode,Ship_Date,Profit 
from shipping_dimen 
inner join market_fact_full 
using(Ship_id);

-- 39. Print the shipment mode, profit made and product category for each product.

Select Prod_id,Ship_Mode,Profit,Product_Category 
from shipping_dimen
inner join market_fact_full using(Ship_id)
inner join prod_dimen using(Prod_id);

-- 40. Which customer ordered the most number of products?

select Customer_Name,sum(Order_Quantity) as total_orders 
from market_fact_full 
inner join cust_dimen using(cust_id)
group by Customer_Name 
order by total_orders desc;

-- 41. Selling office supplies was more profitable in Delhi as compared to Patna. True or false?

select City,Product_Category,sum(Profit) as Total_Profit
from prod_dimen
inner join market_fact_full using (Prod_id)
inner join cust_dimen using(Cust_id)
where City in ("Delhi","Patna") and Product_Category="OFFICE SUPPLIES"
group by City,Product_Category
order by Total_Profit desc;


-- 42. Print the name of the customer with the maximum number of orders.

Select Customer_Name,sum(Order_Quantity) as Orders_Count 
from cust_dimen
inner join market_fact_full using (Cust_id)
group by Customer_Name 
order by Orders_Count desc;

-- 43. Print the three most common products.

select Prod_id,Product_Category,Product_Sub_Category,sum(Order_Quantity) as Order_Quantity 
from market_fact_full
inner join prod_dimen using(Prod_id)
group by Prod_id,Product_Category,Product_Sub_Category 
order by Order_Quantity desc 
limit 3;

-- 44. Create a view to display the customer names, segments, sales, product categories and subcategories of all orders. 
-- Use it to print the names and segments of those customers who ordered more than 20 pens and art supplies products.

create view Order_details as
(select Ord_id,Customer_Name,Customer_Segment,Sales,Order_Quantity,Product_Category,Product_Sub_Category 
from Cust_dimen 
inner join Market_fact_full using (Cust_id)
inner join orders_dimen using(Ord_id)
inner join prod_dimen using(Prod_id));
select Customer_Name,Customer_Segment,Order_Quantity,Product_Sub_Category 
from Order_details 
where Order_Quantity>20 and Product_Sub_Category="PENS & ART SUPPLIES"
group by Customer_Name,Customer_Segment,Order_Quantity,Product_Sub_Category ;

-- 45. What are the two most and the two least profitable products?

(select Prod_id,sum(Profit) from market_fact_full
group by Prod_id order by sum(Profit) desc limit 2)
union
(select Prod_id,sum(Profit) from market_fact_full
group by Prod_id order by sum(Profit)  limit 2);

-- 46. Rank the orders made by Aaron Smayling in the decreasing order of the resulting sales.

select Ord_id,Customer_Name,round(Sales)  as Rounded_Sales,
rank() over(order by round(Sales) desc) as sales_rank
from cust_dimen
inner join market_fact_full using(Cust_id)
where Customer_Name="Aaron Smayling";

-- 47. For the above customer, rank the orders in the increasing order of the discounts provided. 
-- Also display the dense ranks.

select Ord_id,Customer_Name,Discount,
rank() over(order by Discount ) as sales_rank,dense_rank() over(order by Discount) as sales_dense_rank
from cust_dimen
inner join market_fact_full using(Cust_id)
where Customer_Name="Aaron Smayling";

-- 48. Rank the customers in the decreasing order of the number of orders placed.

select Customer_Name,sum(Order_Quantity) as Order_Quantity,
row_number() over (order by count(Cust_id) desc) as Order_row_no,
rank() over (order by count(Cust_id) desc) as Order_rank,
dense_rank() over (order by count(Cust_id) desc) as Order_dense_rank
from cust_dimen
inner join market_fact_full using(Cust_id)
group by Customer_Name;

-- 49. Create a ranking of the number of orders for each mode of shipment based on the months in which they were
-- shipped. 

With Shipping_Summary as 
(select Ship_Mode,month(Ship_Date) as Ship_Month,count(Ship_id) as Ship_count
from shipping_dimen 
group by Ship_Mode,Ship_Month)
select *,
dense_rank() over (partition by Ship_Mode order by Ship_count desc) as shipping_dense_rank,
row_number() over (partition by Ship_Mode order by Ship_count desc ) as shipping_row_number
from Shipping_Summary;

-- 50. Rank the orders in the increasing order of the shipping costs for all orders placed by Aaron Smayling. Also
-- display the row number for each order.

with Orders_summary as (
select Ord_id,Customer_Name,Shipping_Cost,
rank() over (order by Shipping_Cost) as order_rank
from market_fact_full
inner join cust_dimen using(Cust_id)
where Customer_Name="Aaron Smayling")
select *,
row_number() over (partition by Ord_id) as row_order_number
from Orders_summary
order by Shipping_Cost;

-- 51. Calculate the month-wise moving average shipping costs of all orders shipped in the year 2011.

with shipping_summary as (
select month(Ship_Date) as ship_month,sum(Shipping_Cost) as total_shipping_cost
from market_fact_full
inner join shipping_dimen using (Ship_id)
where year(Ship_Date)="2011"
group by month(Ship_Date))
select *,
avg(total_shipping_cost) over (order by ship_month) as shipping_moving_average
from shipping_summary;

-- 52. Using SQL's lead and lag functions find out the time gap between consecutive orders made by "RICK WILSON"?

with cust_order as (
select Customer_Name,Ord_id,Order_Date
from cust_dimen
left join market_fact_full using(Cust_id)
left join orders_dimen using(Ord_id)
where Customer_Name="RICK WILSON"
group by Customer_Name,Ord_id,Order_Date
order by Order_Date),
next_date_summary as 
(select *,
lead(Order_Date,1) over (order by Order_Date) as next_order_date,
lag(Order_Date,1) over (order by Order_Date) as previous_order_date
from cust_order)
Select *,datediff(next_order_date,Order_Date) as days_diff
from next_date_summary;

-- 53. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

select Market_fact_id,Profit,
CASE
    WHEN Profit < -500 THEN "Huge Loss"
    WHEN Profit between -500 and 0 THEN "Huge Loss"
    WHEN Profit between 0 and 500 THEN "Decent Loss"
    ELSE "Profit"
END as Profit_type
from market_fact_full;
    
-- 54. Classify the customers on the following criteria : 
--    Top 20% of customers: Gold
--    Next 35% of customers: Silver
--    Next 45% of customers: Bronze

with cust_summary as
( Select cust_id,Customer_Name,round(sum(Sales)) as Rounded_Sales,
percent_rank() over ( order by round(sum(sales)) desc) as perc_rank
from cust_dimen
inner join market_fact_full using(cust_id)
group by Cust_id)
select *,
Case
     When perc_rank<=0.2 then "Gold"
     When perc_rank<=0.35 then "Silver"
     When perc_rank<=0.45 then "Bronze"
     Else "Other"
End as Customer_category
from cust_summary;

 -- 55. Create a stored procedure that effectively extracts sales data associated with provided customer IDs

DELIMITER $$
CREATE PROCEDURE get_sales_customer (sales_input INT)
BEGIN
SELECT distinct Cust_id,round(Sales) AS sales_amount 
from market_fact_full 
where round(Sales) > sales_input;
END 
$$
CALL get_sales_customer(1000);

-- 56. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit
-- The market facts with ids '1234', '5678' and '90' belong to which categories of profits?

CREATE VIEW Profit_summary as (
select Market_fact_id,Profit as Profit_Amount,
CASE
    WHEN Profit<-500 THEN "Huge loss"
    WHEN Profit Between -500 and 0 then "Bearable loss"
    when profit Between 0 and 500 then "Decent profit"
    when profit>500 then "Great profit"
END As Profit_type
from market_fact_full);

DELIMITER $$
CREATE PROCEDURE get_profit_type (Market_fact_id_input int)
BEGIN 
   SELECT * FROM Profit_summary WHERE Market_fact_id=Market_fact_id_input;
END
$$

CALL get_profit_type(1234);
CALL get_profit_type(5678);
CALL get_profit_type(90);

/* Problem statement: Identify the sustainable (profitable) product categories 
	so that the growth team can capitalise on them to increase sales.

 Metrics: Some of the metrics that can be used for performing the profitability analysis are as follows:
-- Profits per product category
-- Profits per product subcategory
-- Average profit per order
-- Average profit percentage per order
*/ 

-- 57. Profits per product category--

SELECT 
    Product_Category, SUM(Profit) AS Total_Profit
FROM
market_fact_full
INNER JOIN
prod_dimen USING (Prod_id)
GROUP BY Product_Category
ORDER BY Total_Profit DESC;

-- 58. Profits per product sub-category--

SELECT 
    Product_Category,Product_Sub_Category,SUM(Profit) AS Total_Profit
FROM
market_fact_full
INNER JOIN
prod_dimen USING (Prod_id)
GROUP BY Product_Category,Product_Sub_Category
ORDER BY Product_Category,Total_Profit DESC;

-- 59. Which of the following subcategories reports the heaviest losses?

SELECT 
    Product_Sub_Category,SUM(Profit) AS Total_Profit
FROM
market_fact_full
INNER JOIN
prod_dimen USING (Prod_id)
GROUP BY Product_Sub_Category
ORDER BY Total_Profit;

-- 60. Average profit per order----

With Product_Category_summary as 
(Select Product_Category,Sum(Profit) as Profits,count(distinct Order_Number) as Order_Quantity
from market_fact_full
inner join prod_dimen using(Prod_id)
inner join orders_dimen using (Ord_id)
group by Product_Category)
Select *,round(SUM(Profits)/Order_Quantity,2) as Average_Profit_per_Order
from Product_Category_summary
group by Product_Category;


-- 61. Average Sales per order----

With Product_Category_summary as 
(Select Product_Category,Sum(Profit) as Profits,
round(sum(Sales),2) as Sales,
count(distinct Order_Number) as Order_Quantity
from market_fact_full
inner join prod_dimen using(Prod_id)
inner join orders_dimen using (Ord_id)
group by Product_Category)
Select *,
round(SUM(Profits)/Order_Quantity,2) as Average_Profit_per_Order,
round(SUM(Sales)/Order_Quantity,2) as Average_Sales_per_Order
from Product_Category_summary
group by Product_Category;

-- 62. Average profit percentage per order--
## Profit Percentage=(Sales/Profit)*100 ##

With Product_Category_summary as 
(Select Product_Category,Sum(Profit) as Profits,
round(sum(Sales),2) as Sales,
count(distinct Order_Number) as Order_Quantity
from market_fact_full
inner join prod_dimen using(Prod_id)
inner join orders_dimen using (Ord_id)
group by Product_Category)
Select *,
round(SUM(Profits)/Order_Quantity,2) as Average_Profit_per_Order,
round(SUM(Sales)/Order_Quantity,2) as Average_Sales_per_Order,
round(sum(Profits)/sum(Sales),4)*100 as profit_perc
from Product_Category_summary
group by Product_Category;

/* 
Calculating average profit per order helps figure out the most you should spend on handling each order. 
By knowing this limit, you can make sure you're not spending too much to deliver goods to customers, 
ensuring you make the most profit possible after covering all order-related costs.
*/

-- 63. Extract the details of the top ten customers ----

with cust_summary as(
Select cust_id,
rank() over (order by sum(profit) desc) as customer_rank,
customer_name,
sum(profit) as profit,
city as customer_city,state as customer_state,round(sum(sales),2) as sales
from market_fact_full
inner join cust_dimen using(Cust_id)
group by cust_id)
select * from cust_summary where customer_rank<=10;

-- 64.  A flag to indicate that there is another customer with the exact same name and city but a different customer ID.--

with cust_details as
(select c.*,count(distinct ord_id) as order_count
from market_fact_full
left join cust_dimen c using (Cust_id)
group by cust_id
having order_count <>1),
fraud_cust_list as 
(select Customer_Name,City,count(Cust_id) as cust_id_count
from cust_dimen 
group by Customer_Name,City
having cust_id_count>1)
select cd.*,
CASE
    WHEN fc.cust_id_count is not null then "FRAUD" 
    ELSE "NORMAL"
    END AS fraud_flag
from cust_details cd
left join fraud_cust_list fc
on cd.Customer_Name=fc.Customer_Name and
cd.city=fc.city;