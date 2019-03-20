/* http://www.programmerinterview.com/index.php/database-sql/practice-interview-question-1 */

-- a. The names of all salespeople that have an order with Samsonic.
select s.name
from salesperson as s
inner join orders as o
on o.salesperson_id = s.ID
inner join customer as c
on c.id = o.cust_id
where c.name = 'Samsonic';

-- b. The names of all salespeople that do not have any order with Samsonic.
-- solution 1 not exists
select s.name
from salesperson as s
where not exists
(select * 
from orders as o, customer as c
where o.cust_id = c.id
and o.salesperson_id = s.id
and c.name = 'Samsonic');
-- solution 2 subquery
select s1.name
from salesperson as s1 
where s1.name not in (select s.name
					from salesperson as s
					inner join orders as o
					on o.salesperson_id = s.ID
					inner join customer as c
					on c.id = o.cust_id
					where c.name = 'Samsonic');

-- c. The names of salespeople that have 2 or more orders.
-- solution 1
select s.name
from salesperson as s
where s.id in (select salesperson_id
				from orders
				group by salesperson_id
				having count(*) >= 2);
-- solution 2
seelct s.name
from salesperson as s
where 1 < (select count(*) 
			from orders as o
			where o.salesperson_id = s.id);
-- solution 3
select name
from orders, salesperson
where orders.salesperson_id = salesperson.id
group by name, salesperson_id
having count( salesperson_id ) >1;
-- why use count(salesperson_id)?
-- the case where there is no salesperson for an order?

/* LeetCode 597 Friend request overall acceptance rate */
-- q1 what is the overall acceptance rate
-- overall rate, don't have to be from the same person 
-- solution 1
select 
round(isnull(
	select count(*) from (select distinct requester_id, accepter_id from request_accepted) as a /  
	select count(*) from (select distinct sender_id, send_to_id from friend_request) as b, 0)
, 2) as accept_rate;
-- solution 2
select coalesce(round(count(distinct requester_id, accepter_id) /
	count(distinct sender_id, send_to_id),2),0) as accept_rate
from friend_request, request_accepted
-- SQL coalesce() and isnull() function
-- http://www.itprotoday.com/software-development/coalesce-vs-isnull
-- coalesce(null, null) returns error; isnull(null, null) returns null

-- Can you write a query to return the accept rate but for every month?

-- How about the cumulative accept rate for every day?
-- To find cumulative sum first you need to self join on condition >=
-- select t1.*,t2.* from testsum t1 inner join testsum t2 on t1.ID>=t2.ID
-- http://www.sqlservercentral.com/blogs/querying-microsoft-sql-server/2013/10/19/cumulative-sum-in-sql-server-/
-- get the table of number of requests and accepts for each day first

select the_date, sum(t2.num_accept) as cum_accept, sum(t2.num_request) as cum_request
from
	((select count(distinct requester_id, accepter_id) as num_accept, accept_date as the_date
	from request_accepted
	group by accept_date) as a
	inner join
	(select count(distinct sender_id, send_to_id) as num_request, request_date as the_date
	from friend_request
	group by request_date) as b
	on a.accept_date = b.request_date) as t1
inner join 
	((select count(distinct requester_id, accepter_id) as num_accept, accept_date as the_date
	from request_accepted
	group by accept_date) as c
	inner join
	(select count(distinct sender_id, send_to_id) as num_request, request_date as the_date
	from friend_request
	group by request_date) as d
	on c.accept_date = d.request_date) as t2
on t1.the_date >= t2.the_date
group by the_date;

/*Friend Requests II: Who Has the Most Friends */
select ids as id, cnt as num
from
(
select ids, count(*) as cnt
   from
   (
        select requester_id as ids from request_accepted
        union all
        select accepter_id from request_accepted
    ) as tbl1
   group by ids
   ) as tbl2
order by cnt desc
limit 1
;

-- Follow-up: In the real world, multiple people could have the same most number of friends, 
-- can you find all these people in this case?
select ids as id, cnt as num
from
(
select count(*) as cnt
   from
   (
        select requester_id as ids from request_accepted
        union all
        select accepter_id from request_accepted
    ) as tbl1
  	group by ids
	order by cnt desc
	limit 1)  as tbl2;


2 tables related to online advertising:
●	Advertiser_Info: advertiser_id, ad_id, ad_spend
●	Ad_Info: ad_id, run_date, impressions, clicks, revenue      
A.	Calculate the following metrics for each advertiser: CTR, cost per click, ROI (revenue/spend)


1. CTR
select adv.advertiser_id, sum(clicks) / sum(impressions) as CTR, sum(ad_spend) / sum(clicks) as CPC, 
sum(revenue) / sum(spend) as ROI
from AD_Info 
inner join Advertiser_Info as adv
on AD_Info.ad_id = adv.ad_id
group by adv.advertiser_id;


best ad based on ROI

R: 
library(tidyverse)

advertiser_info %>% join(ad_info, on = ad_id ) %>% group_by(advertiser_id, ad_id) %>% summarize( max_ROI =max(sum(revenue) / sum(spend)) )

select row_number(over spartition by )









