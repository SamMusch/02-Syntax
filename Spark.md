Resources

- [Quick Start Doc](http://spark.apache.org/docs/latest/quick-start.html)
- [Spark Datasets (SQL) Guide](http://spark.apache.org/docs/latest/sql-getting-started.html)
- [Pyspark Built in Functions](https://spark.apache.org/docs/latest/api/python/pyspark.sql.html)
- [Spark 3.0](https://spark.apache.org/releases/spark-release-3-0-0.html)

*Python to Spark conversion types on page 59*





## Ch 1 - What is Apache Spark?

"Apache Spark is a unified computing engine and a set of libraries for parallel data processing on computer clusters."

- **Unified** - Load data, SQL, ML, etc. Spark is able to combine multiple steps into 1 scan.
- **Computing engine** - Spark doesn't store data long term, it just provides computations on data that sits somewhere else
  - Storage: Azure Storage, S3, Apache Hadoop, Apache Cassandra
- **Libraries** - Build on unified system
  - SQL, Spark SQL, MLlib, Spark Streaming



Around 2005, instead of improving processor speed, devs started adding parallel CPU cores all running at the same speed. As a result, applications had to do the same. At the same time, it is becoming cheaper and easier to store more data. 

Issue of MapReduce - Have to make many passes over the data. Spark lets the steps share data in memory with each other.

Written in Scala, runs on Java Virtual Machine

**Benefits**: Linear scalable, fault tolerance, data locality base computations

---

**Deployment models** 
Local mode - `JVM` (Java virtual machine) 
Cluster mode - `yarn`, `Standalone`, `Mesos`

**Spark Clusters**  
Driver program uses SparkContext to communicate with cluster manager. Cluster manager splits RDDs by nodes.  
Driver program = who we write our commands to.  
SparkConext = stores info about location of cluster or APIs. creates RDDs. specifies which cluster resource to use. 

**Partitions** ~128/partition  
RDD will be split into partitions  
Each node can work on one partition per time

**Opening jupyter** 
Run `pyspark` 
Copy and paste url 
Change to `localhost`





<img src=https://i.imgur.com/LwinGqp.png width="350" height="270" align="left">

<img src=https://i.imgur.com/w7bve7C.png width="350" height="270" align="left">





## Ch 2 - API Overview

**Cluster** - pools the resources of many machines together, giving us the ability to use all the cumulative resources as if they were a single computer. Spark is the way that we coordinate work across the cluster.

**Cluster manager** - managers cluster of machines. YARN, Mesos, or Spark's standalone cluster manager



**Spark Applications**

- Driver  -  maintains all relevant information during the lifetime of the application
  - maintains info about the Spark Application 
  - responds to a user’s program or input
  - analyze, distribute, and schedules work across the executors
- Executor - carries out the work
  - Execute code
  - Reports state of the computation back to driver



**Spark APIs**

- Unstructured (low-level)
- Structured
  - DataFrame - table of data, just like spreadsheet
    - Partitions - collection of rows that sits on a machine in the cluster
      - Transformations
        - Narrow - 1 input partition = 1 output partition
        - Wide - a "shuffle", Spark will need to write to disk
          - Default is 200 output partitions
      - Actions

---

## Ch 4 - More API

The majority of the Structured APIs apply to both *batch* and *streaming* computation. Spark uses an internal engine called *Catalyst*. There is a lookup table that Spark uses to convert our Python / R / Java to *Catalyst*.

**Schemas** - defines column names, column types

**Row** type - Spark’s optimized in-memory format. Avoids garbage-collection and object instantiation costs. Each record in a DataFrame is of type *Row*. A *Row* internally represents an array of bytes 

**Column** types - think of as columns in a table

- Simple type - integer, string, etc
- Complex type - array, map, etc
- Null values



**DataFrames vs datasets**

- Both are structured collections. Both are (distributed) table-like collections with well-defined rows and columns. Both are immutable and lazily executed.

- (As of 2018) Datasets are only available to JVM languages (Scala and Java). Can have types besides just *Row*.

- DataFrames are simply Datasets of Type *Row*. DataFrames take advantage of Spark’s optimized internal format. 

- Typed vs untyped

  - Datasets are *typed*. Spark checks these at *compile time*. 

  - DataFrames are close to *untyped*. They have types, but Spark doesn't check these until *runtime*.

    

### API Execution

1. User writes code
2. Spark converts to *Logical Plan*
3. Spark converts to *Physical Plan* and checks for optimization
   1. Uses a cost model to compare different strategies
4. Spark executes RDD manipulations on the cluster
   1. Spark performs further optimization here - generates native Java bytecode to remove entire tasks if possible

---

## Ch 5 - Basic Structured Operations

*Schema-on-read* can be slower than defining it ourselves on csv and json formats. You should define it yourself when performing production ETL.

**Expressions** - set of transformations on 1+ values in a record in a DataFrame. This value can include complex types like array or map

`StructType` - type of our schema. Made up of our fields.

`StructFields` - Provides us with - name of column, column type, whether we can have nulls. PAGE 59 FOR COLUMN TYPES.

### DataFrames

JSON manual schema example (page 67)

Creating DataFrames

```python
from pyspark.sql import Row
from pyspark.sql.types import StructField, StructType, StringType, LongType

myManualSchema = StructType([
  StructField("DEST_COUNTRY_NAME", StringType(), True),
  StructField("ORIGIN_COUNTRY_NAME", StringType(), True),
  StructField("count", LongType(), False, 
              metadata={"hello":"world"})])


# Manual schema
df = spark.read.format("json")\
	.schema(myManualSchema)\
	.load("/data/flight-data/json/2015-summary.json")
  
  
# Schema on read
df = spark.read.format("json")\
	.load("/data/flight-data/json/2015-summary.json")
  
  
df.printSchema
df.columns
```



Columns and expressions (page 68)

```python
# Referring to a column
from pyspark.sql.functions import col
col("someColumnName")


# These 3 are the same thing
expr("myCol - 5")
expr("myCol") - 5
col("myCol") - 5
```



Creating Rows (page 71)

```python
from pyspark.sql import Row
myRow = Row("Hello", None, 1, False)

# 1st value
myRow[0]
```

---

### DataFrame Transformations

We can..

- Add rows or columns
- Remove rows or columns
- Transform a row into a column (or vice versa)
- Sort data by values in rows



Manually creating DataFrame (page 73)

```python
myManualSchema = StructType([
	StructField("some", StringType(), True),
	StructField("col", StringType(), True),
	StructField("names", LongType(), False)])

myRow = Row("Hello", None, 1)
myDf = spark.createDataFrame([myRow], myManualSchema)
myDf.show()
```



Selecting column, renaming (page 76)

```python
# Multiple columns
df.select(
  "DEST_COUNTRY_NAME", 
  "ORIGIN_COUNTRY_NAME").show(2)


# Rename column
df.select(
  expr("DEST_COUNTRY_NAME as destination").alias("DEST_COUNTRY_NAME"))\.show(2)


# Rename column - old, new
df.withColumnRenamed(
  "DEST_COUNTRY_NAME", # old
  "dest")              # new


# Rename column with extra characters
# Need to use `` so Spark knows its a column name
dfWithLongColName.selectExpr(
  "`This Long Column-Name`",
  "`This Long Column-Name` as `new col`")\
.show(2)


# Shortcut - selectExpr
df.selectExpr(
  "DEST_COUNTRY_NAME as newColumnName",
  "DEST_COUNTRY_NAME").show(2)
```



New columns, aggregate functions, literals (page 76)

```python
# Drop columns
df.drop("ORIGIN_COUNTRY_NAME", "DEST_COUNTRY_NAME")


# Create a new column
# withinCountry will be a boolean of T / F
df.selectExpr(
  "*",
  "(DEST_COUNTRY_NAME = ORIGIN_COUNTRY_NAME) as withinCountry")\.show(2)


# Aggregate functions
df.selectExpr(
  "avg(count)",
  "count(distinct(DEST_COUNTRY_NAME))").show(2)


# Literal
# Creates column called "One"
# Each value will just be the number "1"
from pyspark.sql.functions import lit
df.select(
  expr("*"), 
  lit(1).alias("One")).show(2)


# Filter with boolean flag
df.withColumn(
  "withinCountry", 
  expr("ORIGIN_COUNTRY_NAME == DEST_COUNTRY_NAME"))\
.show(2)
```



Casting, filtering (page 80)

```python
# Cast - convert column that was called "count"
df.withColumn(
  "count2", 
  col("count").cast("long"))


# Filtering - can do with filter() or where()
df.where("col1 < 2").show(2)


# Multiple filters
df\
.where(col("count") < 2)\
.where(col("ORIGIN_COUNTRY_NAME") != "Croatia")\
.show(2)


# Unique rows
df.select(
  "ORIGIN_COUNTRY_NAME",
  "DEST_COUNTRY_NAME").distinct().count()
```



Random samples and splits (page 83)

```python
# Random sample
seed = 5
withReplacement = False
fraction = 0.5
df.sample(withReplacement, fraction, seed)


# Random split
seed = 5
dataFrames = df.randomSplit([0.25, 0.75], seed)
```





Union (page 83)

```python
# Creates the new table
from pyspark.sql import Row
schema = df.schema
newRows = [
  Row("New Country", "Other Country", 5L),
  Row("New Country 2", "Other Country 3", 1L)]

parallelizedRows = spark.sparkContext.parallelize(newRows)
newDF = spark.createDataFrame(parallelizedRows, schema)


# Union with the old table
df.union(newDF)\
.where("count = 1")\
.where(col("ORIGIN_COUNTRY_NAME") != "United States")\
.show()
```





Order by, limit, repartition (page 85)

 asc_nulls_first, desc_nulls_first, asc_nulls_last, desc_nulls_last

```python
from pyspark.sql.functions import desc, asc

# Ordering by
df.orderBy("count desc", "DEST_COUNTRY_NAME").show(5)


# Using limit
df.orderBy(expr("count desc")).limit(6).show()


# Repartition - can do according to frequently filtered columns
# Note that the "5" is optional
df.repartition(5, col("DEST_COUNTRY_NAME"))


# Coalesce - will try to combine partitions without performing full shuffle
df.repartition(5, col("DEST_COUNTRY_NAME")).coalesce(2)
```





Collecting rows to driver (page 87)

- Collect - gets all data from entire DataFrame
- Take - only gets first N rows
- Show - prints out N rows nicely

```python
collectDF = df.limit(10)
collectDF.take(5)
collectDF.show()
collectDF.show(5, False)
collectDF.collect()  # could crash driver


# Iterates over whole dataset partition by partition
# Could crash driver if large partitions
collectDF.toLocalIterator() 
```





## Spark SQL

Better than using RDD to handle complex manipulation, prep for ML

- Built on top of core Spark
- Provides dataframe API
- Uses Catalyst Optimizer


Entry point = SparkSession (created in Spark Shell)

- Can write queries in Hive and use Hive UDF's without needing Hive
- Able to turn RDD into dataframe

```python
from pyspark import SparkConf
from pyspark import SparkContext
from pyspark.sql.types import *
```



```python
bids = spark.read.option("inferSchema","true")\
.csv(data_file)
bids = bids.toDF(*cols)

df = spark.read.json("file:/databricks/driver/yelp.json")
df.printSchema()
df.take(5)


data = spark.read.option("header", "true") \
.option("delimiter", "\\t") \
.csv("/databricks-...") \
.cache()
```



```python
# Write dataframe into file
maxprices.write.csv("maxprices")

# Verify - there are multiple files, parallel processing (each partition of your data may write its own output)
!ls -l maxprices/

# Take all data into one file
! cat maxprices/* > maxprices.csv

# Head of the file
! head maxprices.csv
```



## Machine Learning

[ML Lib](https://spark.apache.org/docs/latest/ml-features.html)

**Data Types**: vectors

- Label

- Feature column - vector of the observation

 - Dense - regular array

 - Sparse - only the non-zeros, has the index and the value

   - less storage, faster

   

**Abstractions**

- DataFrame: Dataset with feature vector
- Transformer: (does not require training) Transforms df into another
- Estimator: (requires training) Runs an algorithm on a data set to fit a model
- Pipeline: Chains multiple steps to define a machine learning workflow
