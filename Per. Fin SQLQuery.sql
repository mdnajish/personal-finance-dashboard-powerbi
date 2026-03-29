Create Database Personal_Finance;

use Personal_Finance



create table Planning(
type varchar(20),
component varchar(30),
value int,
Date Date,
Month Varchar(20),
Year varchar(20)
);

------
BULK INSERT Planning
FROM "C:\Users\NAJISH\Downloads\Finance Pf .csv"

WITH
(
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',    
    FIRSTROW = 2             
);


----- What is the total income vs total expenses over the entire time period?

select Year,type,sum(Value) Total_Amount from Planning
where type in  ('Expense','Income')
group by Year,Type; 

---- How does monthly income compare to monthly expenses?

select Month,type,sum(Value) as Total_Amount from Planning
where type in ('Expense','Income')
group by Month,type;


-----
With Monthly As
(
select Month,type,
sum(case when type='Expense' then Value else 0 end) as Total_Expense,
sum(case when type='Income' then value else 0 end ) as Total_Incomee
from Planning group by Month,Type
)
select MONTH,Total_Incomee,Total_Expense from Monthly
;

-----What is the trend of income and expenses over time (monthly/yearly
select Year,Month,sum(value) as Total_Amount from Planning
where type in ('Income','Expense')
group by Year,Month;


---- Are there any months with unusually high expenses or low income?

with Monthly AS 
(select Year,Month,

sum(case when type='Income' then value else 0 end) as Total_Income,
sum(case when type='Expense' then Value else 0 end) as Total_Expense

from Planning
where type in ('Income','Expense')
group by Year,Month
)
select * From Monthly 
where Total_Expense > Total_Income
;

---- Are there any months with unusually high savings or low expene?

with Expense AS 
(
select Month,
sum(case when type='Expense' then value else 0 end) as Total_Expense,
sum(Case when type='Savings' then value else 0 end) as Total_Savings
from Planning group by Month
)
select * from Expense 
where Total_Savings > Total_Expense
;

-----Which expense components (e.g., rent, food, travel) contribute the most to total spending?

select type,component,sum(value) as Total
from Planning where type='Expense'
group by type,component
order by sum(Value) desc
;

---- What percentage of income is spent on each expense category

with Different AS 
(
select type,component,sum(value) as Total_Expense 
from Planning where type='Expense'
group by type,component
)
select * ,
Total_Expense*100/sum(Total_Expense) over() as [% of Income] 
from Different;

-----What is the monthly savings (Income – Expenses), and how does it vary over time?

select month,type,sum(value) as Total_Savings
from Planning where type='Savings'
group by Month,type order by Total_Savings desc;

----Are there seasonal patterns in spending (e.g., higher expenses in certain months)

select Month,type,sum(value) as Total_Expense 
from Planning where type='Expense' 
group by Month,type
order by Total_Expense desc;


-----Is there any correlation between income changes and spending behavior?


