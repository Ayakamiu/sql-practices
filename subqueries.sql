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
-- join  where nam = 'Mc Lyon'


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