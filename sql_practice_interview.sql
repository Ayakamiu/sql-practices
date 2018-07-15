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
select 
isnull(


)

-- SQL coalesce() function
-- http://www.itprotoday.com/software-development/coalesce-vs-isnull