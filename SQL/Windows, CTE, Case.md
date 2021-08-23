[All Data Types](https://www.w3schools.com/sql/sql_datatypes.asp)



# Views

A view is just a saved query, could be slower because we lose the index





```mysql
-- List the vendor id, name, and state of all vendors that DID NOT HAVE INVOICE MAY 2014.

-- Vendors in invoice in May 2014
DROP VIEW IF EXISTS v_vendors_with_invoices_may2014;
CREATE VIEW v_vendors_with_invoices_may2014 AS
SELECT vendor_id
  FROM invoices
 WHERE invoice_date BETWEEN '2014-05-01' AND '2014-05-31';
 
-- All vendors except these
SELECT vendor_id, vendor_name, vendor_state
  FROM vendors AS V
 WHERE vendor_id NOT IN (SELECT vendor_id FROM v_vendors_with_invoices_may2014);
```



```mysql
# Filter out line items from an invoice that are less than the acct's avg

-- Step 1: Find acct's avg
CREATE VIEW v_general_ledger_acct_avgs AS
SELECT account_number,
	   AVG(line_item_amt) AS avg_amt
  FROM invoice_line_items
GROUP BY account_number;

-- Step 2: Filter out low line items
SELECT invoice_number, L.account_number, account_description, SUM(line_item_amt) AS total, T.avg_amt
  FROM invoices AS I
  JOIN invoice_line_items AS L USING (invoice_id)
  JOIN general_ledger_accounts AS A USING (account_number)
  JOIN v_general_ledger_acct_avgs AS T USING (account_number)
GROUP BY invoice_number, account_number
HAVING total > T.avg_amt;
```







# Ch 19 - Case Statements

Simple - simply an "equals" test, can not handle nulls. Can only be done on one column.

Searched - anything we can specify in a "join", "where", or "having"





If the column contains null values, you must use a `searched` case statement

```mysql
-- Include a column indicating whether the invoice was paid in full, 
-- partially paid, or not paid at all.

-- Simple 
-- cannot handle NULL values
SELECT invoice_number, vendor_name, invoice_total,
       (CASE payment_total + credit_total
         WHEN 0 THEN 'Not paid'
         WHEN invoice_total THEN 'Paid in Full'
         ELSE 'Partially Paid'
	   END) AS pmt_status
  FROM invoices AS I
  JOIN vendors AS V USING (vendor_id);
  
  
  -- w/ a searched case statement
SELECT invoice_number, vendor_name, 
invoice_total,
       (CASE 
       WHEN payment_total + credit_total = 
       invoice_total 
       		THEN 'Paid in Full'
       WHEN payment_total + credit_total = 0 
       		THEN 'Not Paid'
            ELSE 'Partially Paid'
	   END) AS pmt_status
  FROM invoices AS I
  JOIN vendors AS V USING (vendor_id);
```



```mysql
-- Show invoices, whether or not they have been paid.
-- Use a searched case when the column contains NULLs
SELECT invoice_number, vendor_name, invoice_total, payment_date, invoice_due_date,
       (CASE 
         WHEN payment_date IS NULL THEN 'Not Paid'
         ELSE 'Paid'
	   END) AS paid
  FROM invoices AS I
  JOIN vendors AS V USING (vendor_id);
```



## Flag variable example

List the invoice_number for all invoices with a term of 60 days. Include an
additional column named 'multiline' that indicates (with a 'yes' or 'no)
whether that invoice contains more than 1 line item.

```mysql
-- With a group by 
SELECT invoice_number,
	   CASE COUNT(*)
         WHEN 1 THEN 'No'
         ELSE 'Yes'
	   END AS multiline
  FROM invoices AS I
  JOIN terms AS T USING (terms_id) JOIN invoice_line_items AS L USING (invoice_id)
 WHERE terms_due_days = 60
 GROUP BY invoice_number;
 
 
 -- Using a subquery
SELECT invoice_number,
       CASE (SELECT COUNT(*) FROM invoice_line_items AS L 
             WHERE L.invoice_id = I.invoice_id)
         WHEN 1 THEN 'No'
         ELSE 'Yes'
	   END AS multiline
  FROM invoices AS I
  JOIN terms AS T USING (terms_id)
 WHERE terms_due_days = 60;


-- Using a searched case
SELECT invoice_number,
       CASE WHEN (SELECT COUNT(*) 
                  FROM invoice_line_items AS L 
                  WHERE L.invoice_id = I.invoice_id) 
                  	= 1 THEN 'No'
         ELSE 'Yes'
	   END AS multiline
  FROM invoices AS I
  JOIN terms AS T USING (terms_id)
 WHERE terms_due_days = 60;
```



## Datediff example

CASE: List the rental date, title, and return_date for all rentals by
customer_id 236. Include an additional column that indicates whether the 
rental was returned 'Late', 'Ontime', or 'Never'. (42 rows)

```mysql
SELECT rental_date, title, return_date,
       CASE WHEN DATEDIFF(return_date, rental_date) > rental_duration THEN 'Late'
            WHEN return_date IS NULL THEN 'Never'
            ELSE 'Ontime'
       END AS 'returned?'
  FROM rental AS R 
  JOIN inventory AS I USING (inventory_id)
  JOIN film AS F USING (film_id)
 WHERE customer_id = 236;
```





# Ch 21 - Multiple Aggregations

#### Rollup - pg 753

Lets you do the normal "group by" and then also gives you the "group by" results from right to left of columns we give.

The below will give a count of col1, col2, col3 as well as the from right to left

Number of subtotal groups = $n+1$

```mysql
select col1, col2, col3, count(*)
from tbl
group by ROLLUP
	(col1, col2, col3);
```



#### Cube - pg 765

Number of subtotal groups = $2^n$

This is the same thing as rollup except that it gives you all of the combinations of the columns we provide

```mysql
select col1, col2, col3, count(*)
from tbl
group by CUBE
	(col1, col2, col3);
```



#### Grouping sets - pg 773

This is the same thing as rollup except that it lets you select with aggregations you would like to see

```mysql
select col1, col2, col3, count(*)
from tbl
group by GROUPING SETS
	(col1, 
   (col2, col3),
   (col1, col3));
```

---





# Ch 22 - Windows

OVER() vs group by - group by reduces rows, over() does not

Example - doing the count(*) operation in over()

- Partition by - gives count per person
- Order by - gives running total of counts per person
- ROWS (or RANGE)
  - rows between current row and 1 following
    - This takes the previous value and adds the current value
  - rows between unbounded preceding and current row
    - This is the true running total

```
select ...
count(*) over 
	(partition by ___) as tab1
```

Example on page 812

```mysql
select 
C.CustCity, C.Name, 
count(*) as Preferences,
sum(count(*))       # notice that sum stands alone 
		OVER (
		order by C.CustCity
		   rows between unbounded preceding and current row) 					as TotalUsingRows
from customers as c
group by C.CustCity, C.Name;
```

---

Row_number() - no ties

Rank() - handles ties, works like golf scores

Dense_rank() - a tie for 4th would give the 6th place person a value of "5"

Percent_rank() - 0 for first, 1 for last

```
select row_number() over (...)
```











### Materialized table

Helps with performance. SQL is able to use the "inside" part as its own table and index that

```mysql
SELECT * FROM
(
SELECT RANK() OVER (PARTITION BY vendor_state ORDER BY SUM(line_item_amt) DESC) AS vendor_rank,
       vendor_name, vendor_state,
       SUM(line_item_amt) AS raw_total,
       CASE WHEN SUM(line_item_amt) IS NULL THEN 0
            ELSE SUM(line_item_amt)
	   END AS total_business
  FROM vendors AS V 
  LEFT JOIN invoices AS I USING (vendor_id)
  LEFT JOIN invoice_line_items AS L USING (invoice_id)
GROUP BY vendor_name) AS T
 WHERE vendor_rank = 1 AND total_business > 0
ORDER BY vendor_name;
```



### View

```mysql
-- Using a view
DROP VIEW IF EXISTS v_vendor_rank_by_sate;
CREATE VIEW v_vendor_rank_by_state AS
SELECT RANK() OVER (PARTITION BY vendor_state ORDER BY SUM(line_item_amt) DESC) AS vendor_rank,
       vendor_name,
       vendor_state,
       SUM(line_item_amt) AS raw_total,
       CASE WHEN SUM(line_item_amt) IS NULL THEN 0
            ELSE SUM(line_item_amt)
	   END AS total_business
  FROM vendors AS V 
  LEFT JOIN invoices AS I USING (vendor_id)
  LEFT JOIN invoice_line_items AS L USING (invoice_id)
GROUP BY vendor_name;

SELECT * 
  FROM v_vendor_rank_by_state
 WHERE vendor_rank = 1 AND total_business > 0
ORDER BY vendor_state;
```





### CTE

Used to simplify complex joins and subqueries, and to provide a means to query hierarchical data such as an organizational chart

```mysql
WITH cte_rank AS
(
SELECT RANK() OVER (PARTITION BY vendor_state ORDER BY SUM(line_item_amt) DESC) AS vendor_rank,
       vendor_name, vendor_state,
       SUM(line_item_amt) AS raw_total,
       CASE WHEN SUM(line_item_amt) IS NULL THEN 0
            ELSE SUM(line_item_amt)
	   END AS total_business
  FROM vendors AS V 
  LEFT JOIN invoices AS I USING (vendor_id)
  LEFT JOIN invoice_line_items AS L USING (invoice_id)
GROUP BY vendor_name
)
SELECT *
  FROM cte_rank
 WHERE vendor_rank = 1 AND total_business > 0
ORDER BY vendor_name;
```



### Cumulative Sums

```mysql
-- Cumulative sums
SELECT RANK() OVER (PARTITION BY vendor_state ORDER BY SUM(line_item_amt) DESC) AS vendor_rank,
       vendor_name,
       vendor_state,
       SUM(line_item_amt) AS raw_total,
       CASE WHEN SUM(line_item_amt) IS NULL THEN 0
            ELSE SUM(line_item_amt)
	   END AS total_business,
       SUM(SUM(line_item_amt)) OVER (PARTITION BY vendor_state 
                                     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_business
  FROM vendors AS V 
  LEFT JOIN invoices AS I USING (vendor_id)
  LEFT JOIN invoice_line_items AS L USING (invoice_id)
GROUP BY vendor_name;
```



## Frequent people + frequent purchase
```mysql
WITH T AS
(
SELECT customer_id, email, title,
       COUNT(DISTINCT rental_id) AS num_rentals,
       RANK() OVER (PARTITION BY email ORDER BY COUNT(DISTINCT rental_id) DESC) AS rented_rank
  FROM rental AS R
  JOIN customer AS C USING (customer_id) 
    JOIN inventory AS I USING (inventory_id) JOIN film AS F USING (film_id)
GROUP BY email, title 
HAVING num_rentals > 1
)
SELECT * FROM T
 WHERE (SELECT COUNT(customer_id)  
          FROM T AS T2 WHERE T2.customer_id = T.customer_id) > 1
   AND rented_rank < 3;
```



## Running total

```mysql
# Orders the person has made, how much they owe
WITH T AS 
(SELECT 'Order' AS trans_type, customerNumber, orderNumber AS trans_num, 
 orderDate AS trans_date, ROUND(SUM(priceEach * quantityOrdered),2) AS total
  FROM orders AS O JOIN orderdetails USING (ordernumber)
GROUP BY orderNumber

UNION ALL

# Payments the person has made, how much they owe
SELECT 'Payment', customerNumber, checkNumber, paymentDate, -amount
FROM payments)
SELECT *, 
ROUND(SUM(total) OVER (ORDER BY trans_date, trans_type ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS balance
FROM T WHERE customerNumber IN (198, 381) ORDER BY trans_date;
```





## Windows



```mysql
-- Add an "index" number to each row
SELECT ROW_NUMBER() OVER (ORDER BY vendor_name) AS vendor_num,
       vendor_id, vendor_name, vendor_city, vendor_state
  FROM vendors
ORDER BY vendor_city, vendor_state;
```



```mysql
-- Per city, state - add an "index" number to each row
SELECT ROW_NUMBER() OVER (PARTITION BY vendor_city, vendor_state ORDER BY vendor_name) AS vendor_num,
       vendor_id, vendor_name, vendor_city, vendor_state
  FROM vendors
ORDER BY vendor_state, vendor_name;
```



## Top customers per store

Window: We are looking for our best customers. List the store_id, customer_id,
first_name, last_name, and number of rentals by that customer at each
store. Include a column for the rank of that particular customer at that
particular store such that the customer with the most rentals at store 1
earns rank 1 and the customer with the most rentals at store 2 also earns 
rank 1. Include only customers with 15 rentals or more. (429 rows)

```mysql
SELECT I.store_id, customer_id, first_name, last_name,
       COUNT(*) as rentals,
       RANK() OVER (PARTITION BY I.store_id ORDER BY COUNT(*) DESC) AS cust_rank
  FROM rental AS R
  JOIN customer AS C USING (customer_id)
  JOIN inventory AS I USING (inventory_id)
GROUP BY I.store_id, customer_id, first_name, last_name
HAVING rentals >= 15
ORDER BY cust_rank, store_id;
```

