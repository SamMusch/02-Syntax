## Overview

[Column types](https://imgur.com/a/rqbj1NG)

The data for Hive and the computations both run on the Hadoop cluster. 
Hive itself runs on the `client machine` - translates code into an execution plan for MapReduce (batch processing platform)

---


### Storage

**Managed tables** `Default` = fully under Hive, not shared with other tools 
**External tables** = shared between Hive and other apps

1. Metadata - Specifies structure, location of data 
-- Metadata is then stored in an RDBMS metastore (Derby or mySQL), not HDFS  

2. Data - typically in an HDFS directory 
-- eg `/user/../table_name`

<img src=https://i.imgur.com/ikZOUVJ.png width="300" height="220" align="left">

### Storage Formats

**Binary encoding**  
Stores data as key-value pairs

**Columnar**   
Data stored down the column, not across the rows ("stored by column")  
Pro: efficient when we only need a subset of table (doesn't have to store duplicates)

**Textfile (Default)**  
Pro: Read or written from pretty much and programming language  
Con: Not great at scale - numbers are stored as strings, hard to represent binary

**1. SequenceFiles (binary encoding)** store key-value pairs  
Pro: Much more efficient  
Con: Doesn't work well with other tools, Java specific

**2. Apache Avro (binary encoding)**  
Pro: efficient, supported thruout Hadoop, good for long term storage  

**3. Apache Parquet (columnar and binary encoding)**  
Pro: reduced storage performance and improved performance, best when adding many records at once

**4. RCFile (columnar and binary encoding)** stores different row groups into a columnar table  
Con: pretty poor performance

**5. ORCFile (columnar and binary encoding)** stores different row groups into a columnar table  
Pro: better performance than RCFile, works well with Hive and Spark

**Table format (default)** 
Plain text 
One record per line by `\n` 
Column split by `A^` 
$\quad$ `B^` if members of arrays or structs 
$\quad$ `C^` if key value pairs



## String Functions

**Essential points** 
`Split` creates an array from a string
`Explode` creates indy records from an array  
`Regex` to extract or sub strings  
`N-grams` is a sequence of words

(inclusive, exclusive)

Splitting converts to an array  
Use `SELECT EXPLODE(SPLIT(..)` instead
Insert image (splitting and combining) 

Create histogram with 10 bins (we could also use subq instead)  
`from products
select explode(histogram_numeric(price,10)) as bin`


``histogram_numeric(id, 5) from customers`  
returns one single row - an array of struct

---

<img src=https://i.imgur.com/0uRU4rR.png width="500" height="240" align="left">

<img src=https://i.imgur.com/n7gQtlS.png width="500" height="240" align="left">

<img src=https://i.imgur.com/Ptd8sxp.png width="450" height="240" align="left">



### Regular Expressions

**Regex classes** - character, white space, word 
Use `()` to capture something 
`\\` because 2 interpreters (Hive, then regex engine)

`[]` list of options 
`^` is negate 
`\\d` is digit 
`+` adds one or more 
`.` any character (unless we are inside [])

**Hive's reg expressions** 
`REGEXP` for comparison 
`REGEXP_EXTRACT` to return string matching a pattern
`REGEXP_REPLACE` to replace text 

<img src=https://i.imgur.com/D31V71F.png width="500" height="240" align="left">

<img src=https://i.imgur.com/7YZz4nh.png width="400" height="240" align="left">



## JSON

Use jsonserde when each line of the document is a JSON object 

Supports arrays and maps, nested structures  
Have to load JSON with a special Serde

---

### json file with 3 "topics"

Create a table and load in as 1 field  
`create table raw
(json string)
row format delimited;`

For each table:  
`insert into users
select * from raw
get_json_object(...)` 

Could also use **hadoop streaming** with python scripts to extract users, reviews, businesses.
This would be 3 separate mapreduce jobs.

---

### Querying json fields (non json tables)

#### Dictionary example 

Can use the "value" as a list of strings and use `get_json_object` to parse field. 
This is different than a complex field. 
`input` should be a string with a JSON format. 


$: root object 
`[ ]`: subscript operator for array 
`.` : child operator

`get_json_object(input,` $`.parent.child[index])`

---

### Use external script to transform data

`*` = fields to transform  
`hive> ADD FILE myscript.py;
hive> SELECT TRANSFORM(*) USING 'myscript.py' FROM employees;`

**Example with only 2 fields**  
`hive> SELECT TRANSFORM(product_name, price)
USING 'tax_calculator.py'
AS (item_name STRING, tax INT)
FROM products;`