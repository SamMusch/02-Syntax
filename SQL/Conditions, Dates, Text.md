# Querying



## Conditions

```mysql
# Partial matching
LIKE '%Minnesota%'

# Exact matching
NOT IN ('CA', 'NV', 'OR')

# If its null, show this
IFNULL(payment_date, "no payment yet")
```



## Dates

https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html

```mysql
# Year month day
BETWEEN '2014-05-01' AND '2014-05-31';

# Days
DATEDIFF(CURRENT_DATE, '2001-09-11');

# Years
TIMESTAMPDIFF(YEAR,  '2001-09-11', CURRENT_DATE);

DATE_ADD('2014-04-01', INTERVAL 60 DAY)

# Weekends
WHERE DAYOFWEEK(invoice_date) IN (1,7);
WHERE WEEKDAY(invoice_date) IN (5,6);
```



## Case

Simple is preferred but doesn't handle nulls, complex works sequentially

```mysql
# Simplex
select ..,
	CASE col + col2
	WHEN 0 THEN 'Not Paid'
	WHEN invoice_total THEN 'Paid In Full'
	ELSE 'Partial Paid' END as pmt_status


# Searched / complex
select ..,
	CASE 
    WHEN col + col2 = col_name THEN 'Paid In Full'
	WHEN col + col2 = 0 THEN 'Not Paid'
    ELSE 'Partial Paid' END as pmt_status


# With dates
CASE 
WHEN DATEDIFF(return_date, rental_date) > rental_duration THEN 'Late'
WHEN return_date IS NULL THEN 'Never'
ELSE 'Ontime' END AS 'returned?'
```



## Numbers

https://dev.mysql.com/doc/refman/8.0/en/mathematical-functions.html

```mysql
# Math
min( )   |   max( )   |   count()   |   abs()
avg( ) as average_score

CEILING() # round up
FLOOR()   # round down
mod()     # get remainder
```



## Text

```mysql
# Change data type
CAST(RetailPrice AS CHARACTER(8))

concat(first, ', ', second) AS vendor_address

SUBSTR(vendor_contact_last_name, 1, 1) # start, length
SUBSTR(vendor_phone, 7)                # last 7?
LOWER('word')


# End with one of the following
.. where vendor_name REGEXP "(Inc|Corporation|Co)$";

# Include "of" (between)
.. where vendor_name REGEXP "  [[:<:]]  of  [[:>:]]  ";

# ends with 5 digit number
.. where REGEXP '[[:<:]]  [[:digit:]]{5}  $';



# Regex
-- ^  begin        
-- $ end      
-- | or

-- [[:<:]]  match begin        
-- [[:>:]]  match end
-- [abc]    match one
-- [^xyz]   many any not here

# Characters
-- [:digit:] 
-- [:alpha:] 
-- [:space:] 
-- [:punct:] 
-- [:upper:] 
-- [:alnum:]

# Matching
-- {3}      match 3 times
-- {3,5}    match 3 - 5 times
-- {3,}     match 3+ times
-- . match any       
-- ?  match 0 or 1         
-- * match 0+          
-- +  match 1+
```



## General

**SQL Select**
<img src="https://i.imgur.com/Ldt6m6Q.png" width="400px" />



<img src="https://i.imgur.com/btRY6tQ.png" width="400px" height="300px" />

<img src="https://i.imgur.com/QP5KbDE.png" width="400px" height="300px" />

