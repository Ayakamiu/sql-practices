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
whhere salesman_id in (select salesman_id from salesman where customer_id = 3007); 
