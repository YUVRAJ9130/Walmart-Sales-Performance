# Q1: Find different payment methods, number of transactions, and quantity sold by payment method
Select payment_method, count(*) No_of_Transactions, sum(quantity) Quanity_Sold
from Walmart
group by payment_method
order by Quanity_Sold desc;

# Q2: Identify the highest-rated category in each branch
Select branch, category, rating from (select branch, category, round(avg(rating),1) as rating,
rank() over(partition by branch order by avg(rating) desc) rnk
from walmart
group by branch, category) as ranked
where rnk = 1;

# Q3: Identify the busiest day for each branch based on the number of transactions
select branch, day_name, transactions from 
(select branch, DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name, count(*) as Transactions,
rank() over(partition by branch order by count(*) desc) as rnk
from walmart
group by 1,2) as ranked_Transactions
where rnk = 1;

# Q4: Determine the average, minimum, and maximum rating of categories for each city
select city, category,
	min(rating) as Min_Rating, max(rating) as Max_Rating, round(avg(rating),2) as Avg_Rating
from walmart
group by 1,2
order by 1,2;

# Q5: Calculate the total profit for each category
select category, round(sum(total * profit_margin),2) profit
from walmart
group by 1 
order by 2 desc;

# Q6: Determine the most common payment method for each branch
with cte as
(select branch, payment_method, count(*) no_transactions,
rank() over(partition by branch order by count(*) desc) as rnk
from walmart
group by 1,2)
Select branch, payment_method, no_transactions
from cte
where rnk = 1;

# Q7: Categorize sales into Morning, Afternoon, and Evening shifts find each the no of shifts and invoices
select branch,
case
when hour(time(time)) < 12 then 'Morning'
when hour(time(time)) > 17 then 'Evening'
else 'Afternoon'
end as shift,
count(*) as no_of_invoices
from walmart
group by 1,2
order by 1, 3 desc;

# Q8: Identify the top 5 branches with the highest revenue decrease ratio when comparing last year's revenue to the most recent year's revenue (e.g., 2022 to 2023)
with rev22 as
(select branch, sum(total) as revenue
from walmart
WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
group by 1),
rev23 as
(select branch, sum(total) as revenue
from walmart
WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
group by 1)
select r22.branch, r22.revenue as Last_Year_Revenue, r23.revenue as Current_Revenue,
round(((r22.revenue - r23.revenue)/r22.revenue*100),2) as revenue_decrease_ratio
from rev22 as r22
join rev23 as r23
on r22.branch = r23.branch
where r22.revenue > r23.revenue
order by 4 desc
limit 5;












