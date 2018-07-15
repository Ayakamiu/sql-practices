/*https://www.w3resource.com/sql-exercises/subqueries/index.php */
/* 1. Write a query to display all the orders from the orders table issued by the salesman 'Paul Adam'. */

select * 
from orders
where salesman_id = (select salesman_id from salesman where name = 'Paul Adam');

/*2. Write a query to display all the orders for the salesman who belongs to the city London. */

select * 
from orders
where salesman_id = (select salesman_id from salesman where city = 'London');

/*3. Write a query to find all the orders issued against the salesman who works for customer whose id is 3007. */

select * 
from orders
where salesman_id in (select distinct salesman_id from salesman where customer_id = 3007); 

/*4. Write a query to display all the orders which values are greater than the average order value for 10th October 2012 */

select * 
from orders
where purch_amt > (select avg(purch_amt) as purch_amt 
	from orders 
	where ord_date = '2012-10-10' 
	group by ord_date);

/*5. Write a query to find all orders attributed to a salesman in New york*/

select * 
from orders
where salesman_id = (select salesman_id from salesman where city = 'New York');

/*6. Write a query to display the commission of all the salesmen servicing customers in Paris*/

select commission
from salesman
where salesman_id = (select salesman_id 
	from orders
	where city = 'Paris')；

/*7. Write a query to display all the customers whose id is 2001 bellow the salesman ID of Mc Lyon. */

select *
from customer
where customer_id = 2001 
and salesman_id = (select salesman_id
	from salesman 
	where name = 'Mc Lyon');

-- if do not use subqueries
-- join  where name = 'Mc Lyon'


/*8. Write a query to count the customers with grades above New York's average.*/

-- why use having? since grade is in group by?
select grade, count(*)
from customer 
group by grade
having grade > (select avg(grade) 
	from customer
	where city = 'New York'
	group by city);
-- also works
-- why use count distinct customer_id?
-- just the number of rows could have missing customer_id
SELECT grade, COUNT (DISTINCT customer_id) 
FROM customer  
where grade > (select AVG(grade) 
	FROM customer 
	WHERE city = 'New York') 
Group by grade;

/*9. Write a query to display all customers with orders on October 5, 2012.*/

select * 
from customer
where customer_id in (select distinct customer_id 
	from orders 
	where ord_date = '2012-10-05');
-- solution:
SELECT *
FROM customer a, orders b 
WHERE a.customer_id = b.customer_id 
AND b.ord_date = '2012-10-05';
-- by "all customers" inplicated all fields in both tables, thus an implicit join

/*10. Write a query to display all the customers with orders issued on date 17th August, 2012.*/

select *
from customer a, orders b
where a.customer_id = b.customer_id
and b.ord_date = '2012-08-17';

/*11. Write a query to find the name and numbers of all salesmen who had more than one customer. 
*/

select s.salesman_id, s.name
from salesman as s
where s.salesman_id in (select salesman_id
	from customer
	group by salesman_id
	having count(distinct customer_id) > 1); 
-- solution:
SELECT salesman_id, name 
FROM salesman a 
WHERE 1 < 
    (SELECT COUNT(*) 
     FROM customer 
     WHERE salesman_id=a.salesman_id);
-- use subquery to replace group by
-- for each salesman_id in table a count the rows in customer table on the condition salesman_id = a.salesman_id

/*12. Write a query to find all orders with order amounts which are above-average amounts for their customers.
*/

select *
from orders 
where purch_amt > (select avg(purch_amt)  from orders);     
-- solution:
SELECT * 
FROM orders a
WHERE purch_amt >
    (SELECT AVG(purch_amt) FROM orders b 
     WHERE b.customer_id = a.customer_id);
-- the average purch_amt for each customer
-- don't need group by

/*13. Write a queries to find all orders with order amounts which are on 
or above-average amounts for their customers.
*/

select * 
from orders as o1
where purch_amt >= (select avg(purch_amt)
					from orders as o2
					where o2.customer_id = o1.customer_id);

/*14. Write a query to find the sums of the amounts from the orders table, grouped by date, 
eliminating all those dates where the sum was not at least 1000.00 above the maximum order
amount for that date. 
*/

select sum(purch_amt) 
from orders as o1
where 

/*15. Write a query to extract the data from the customer table if and only if one or
more of the customers in the customer table are located in London
*/
-- if and only if?
-- use the "exists" keywords
-- exists checks rows; if returns one or more records
select *
from customer 
where exists
(select * 
from customer
where city = "London");

/*16. Write a query to find the salesmen who have multiple customers.
*/
select *
from salesman as s
where salesman_id in (select salesman_id
					 from customer
					 group by salesman_id
					 having count(*) > 1);
-- solution:
SELECT * 
FROM salesman 
WHERE salesman_id IN (
   SELECT DISTINCT salesman_id 
   FROM customer a 
   WHERE EXISTS (
      SELECT * 
      FROM customer b 
      WHERE b.salesman_id=a.salesman_id 
      AND b.cust_name<>a.cust_name));
-- do not use group by

/*17. Write a query to find all the salesmen who worked for only one customer. 
*/
-- use group by
select *
from salesman
where salesman_id in (select salesman_id 
	from customer 
	group by salesman_id 
	having count(*) = 1);
-- do not use group by
select * 
from salesman
where salesman_id in (select * 
from customer as c1
where not exists (select * from customer as c2
				where c1.customer_id = c2.customer_id
				and c1.salesman_id <> c2.salesman_id));

/*18. Write a query that extract the rows of all salesmen who have customers with more than one orders.
*/

select * 
from salesman
where salesman_id in (select distinct o.salesman_id
					from orders as o, (select customer_id
					from orders 
					group by customer_id
					having count(*) > 1) as t
					where t.customer_id = o.customer_id)
order by salesman_id;
-- when do I have to give alias to a table?
-- Like all subqueries, those used in the FROM clause to create a derived table are enclosed by parenthesis.  
-- Unlike other subqueries though, a derived table must be aliased so that you can reference its results.
-- in short, subqueries in from clause must have alias
-- solution:
SELECT * 
FROM salesman a 
WHERE EXISTS     
   (SELECT * FROM customer b     
    WHERE a.salesman_id=b.salesman_id     
	 AND 1<             
	     (SELECT COUNT (*)              
		  FROM orders             
		  WHERE orders.customer_id =            
		  b.customer_id));
-- exists faster than in?

/*19. Write a query to find salesmen with all information 
who lives in the city where any of the customers lives.
*/
-- wrong:
select * 
from salesman
where city in (select city 
				from customer
				where customer.salesman_id = salesman.salesman_id);
-- this are the salesman who lives in his/her customer's city

-- solution:
-- use any operator
select * 
from salesman 
where city = any(select city from customer);

/*20. Write a query to find all the salesmen for whom there are customers that follow them.
*/
select *
from salesman 
where city in
    (select city
     from customer);
-- what's the difference?
-- "Using IN with a subquery is functionally equivalent to using ANY,
-- and returns TRUE if a match is found in the set returned by the subquery."
-- "We think you will agree that IN is more intuitive than ANY, which is
-- why IN is almost always used in such situations."


/*21. Write a query to display the salesmen which name are alphabetically
lower than the name of the customers
*/
select * 
from salesman as s
where exists
(select * 
from customer as c
where s.name < c.cust_name);

/*22. Write a query to display the customers who have a greater gradation than
any customer who belongs to the alphabetically lower than the city New York.
*/
-- ???
select * 
from customer
where grade > any(select grade 
				from customer
				where city < 'New York');

/*23. Write a query to display all the orders that had amounts 
that were greater than at least one of the orders on September 10th 2012.
*/

select * 
from orders
where purch_amt > any(select purch_amt 
						from orders
						where ord_date = "2012-09-10");



-- SQL Query:
SELECT DISTINCT t1.customer_id -- get unique customer IDs
FROM 
(SELECT ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS rownum, * 
FROM orders) AS t1 
-- use the row_number() window function to add a “row number” column to identify the number of orders from a certain customer.
JOIN 
(SELECT ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS rownum, * 
FROM orders) AS t2 
-- the same table as “t1”; will be used in self join later.
ON t2.rownum = t1.rownum + 1 AND t2.customer_id = t1.customer_id -- self join the two tables to get the “previous order” on the same row as the certain order
WHERE t2.quantity < t1.quantity AND -- set the condition that the quantity of the previous order is greater than the certain order
t1.rownum >= (SELECT MAX(t3.rownum) - 2 
                   FROM 
(SELECT ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS rownum, * FROM orders) AS t3 
WHERE t3.customer_id = t1.customer_id 
GROUP BY t3.customer_id)
GROUP BY t1.customer_id
HAVING count(*) = 2;
