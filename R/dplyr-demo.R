#install.packages(c('dplyr', 'nycflights13'))
library(nycflights13)
library(dplyr)

#See the Data
flights
View(flights)

# Single Table Verbs

#Get only the flights (rows) with Twin-Cities as their destination
filter(flights, dest == 'MSP')

#Get only the variables (colmuns) that begin with 'arr'
select(flights, starts_with('arr'))

#Reorder the flights (rows) in descending order based on arrival delay
arrange(flights, desc(arr_delay))


#Create a new speed variable 
flights2 <- mutate(flights, speed = distance / air_time * 60)

#Get only the variable speed
select(flights2, speed)

#Alternatively can accomplish previous two steps in one function call to transmute
transmute(flights, speed = distance / air_time * 60)


#Group flights by year, month, and day (i.e., date)
by_day <- group_by(flights, year, month, day)
#Get the average delay on group (each unique date)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))


#Pipe operator x %>% f(y) -> f(x,y)
df1 <- data_frame(x = c(1, 1, 3, 4), y = 1:4)
df1
df2 <- data_frame(x = c(1, 1, 2), z = c("a", "b", "a"))
df2

#Compute number of rows in df1
nrow(df1)
#Alternatively use the pipe operator
df1 %>% nrow()


# Multi-table verbs

#inner_join(x, y) only includes observations that match in both x and y.
inner_join(df1,df2, by='x')

#Alternatively, use the pipe operator
df1 %>% inner_join(df2, by="x")

#Join and count number of rows
df1 %>% inner_join(df2, by="x") %>% nrow()

#How would semi_join differ?
#semi_join(x, y) keeps all observations in x that have a match in y.
df1 %>% semi_join(df2, by="x") %>% nrow()


#Mutating joins (adds columns)
flights2 <- flights %>% select(year:day, hour, origin, dest, tailnum, carrier)
airlines

#left_join(x, y) includes all observations in x, regardless of whether they match or not. 
flights2 %>% left_join(airlines)
#This is the most commonly used join because it ensures that you don't lose observations
#from your primary table.


#filtering joins (works with observations)
planes

#semi_join(x, y) keeps all observations in x that have a match in y.
semi_join(planes, flights)

#anti_join(x, y) drops all observations in x that have a match in y.
anti_join(planes, flights)

#how many flights dont have a matching tail number
filter(flights, tailnum == "")

flights %>% 
  anti_join(planes, by = "tailnum") %>% 
  count(tailnum, sort = TRUE) #count in dplyr also does group by variable name

##messy code
hourly_delay <- filter(
  summarise(
    group_by(
      filter(
        flights,
        !is.na(dep_delay)
      ),
      day, hour
    ),
    delay = mean(dep_delay),
    n = n()
  ),
  n > 10
)

#All the flights that did not leave on time, find the average departure delay
#by day of the month and hour of the day, only including those with more than 10 flights
hourly_delay <- flights %>%
  filter(!is.na(dep_delay)) %>%
  group_by(day, hour ) %>%
  summarise(delay = mean(dep_delay), n = n()  ) %>%
  filter(n > 10) 
#we can sort into ascending order as well
hourly_delay %>% arrange(delay)


