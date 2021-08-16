#good summary stats package
#install.packages(c('Hmisc', 'dplyr', 'VIM', 'mice'))
library(Hmisc)
library(dplyr)
library(mice)

dir = ""
setwd(dir)
file_name = "mobileApps.csv"
mobile_apps <- tbl_df(read.csv(file_name))
View(mobile_apps)

#detecting missing values
describe(mobile_apps)
help(md.pattern)
md.pattern(mobile_apps)
filter(mobile_apps, is.na(app_age_current_version))

#visually detecting missing values
library(VIM)
help(aggr)
aggr(mobile_apps, prop=FALSE, numbers=TRUE)
matrixplot(mobile_apps)
describe(mobile_apps$app_age_current_version)

#calculate median, omit rows with missing values
median(mobile_apps$app_age_current_version)
median(mobile_apps$app_age_current_version,  na.rm=TRUE)

#replace missing values with median
imp.median <- function (a){
  missing <- is.na(a)
  imputed <- a
  imputed[missing] <- median(a,  na.rm=TRUE)
  return (imputed)
}

mobile_apps_2 <- tbl_df(read.csv(file_name))
describe(mobile_apps_2$app_age_current_version)

mobile_apps_2$app_age_current_version <- imp.median(mobile_apps_2$app_age_current_version)
describe(mobile_apps_2$app_age_current_version)


#impute missing values via simple random resampling
random.imp <- function (a){
  missing <- is.na(a) #this isolates the rows of the vector that has missing values
  n.missing <- sum(missing) #gives the number of missing values
  a.obs <- a[!missing] #this gets the empirical distribution 
  imputed <- a #temp placeholder to get the imputed values
  imputed[missing] <- sample (a.obs, n.missing, replace=TRUE) #impute using empirical dist.
  # make sure its with replacement
  return (imputed)
}  

mobile_apps_2 <- tbl_df(read.csv(file_name))
describe(mobile_apps_2$app_age_current_version)
mobile_apps_2$app_age_current_version <- random.imp(mobile_apps_2$app_age_current_version)
describe(mobile_apps_2$app_age_current_version)

#impute missing values using MICE and missForrest
mobile_apps_2 <- tbl_df(read.csv(file_name))

#Note that I run this with a small sample for demonstrative purposes. 
#Running the imputation with the full dataset will take considerably more time.
mobile_apps_sample = sample_n(mobile_apps_2, size=300)
help(mice)

# m is how many datasets with attempted imputations, maxit is how many iterations per dataset
# you can set the method parameter to mice to pick what kind of algorithm you want to use to impute
imputed_mobile_data_total <- mice(mobile_apps_sample, m=5, maxit = 2)
summary(imputed_mobile_data_total)
describe(imputed_mobile_data_total$imp$region)

# first of the 5 (i.e., m) datasets with attempted imputations
imputed_mobile_data_1 <- complete(imputed_mobile_data_total,1)
imputed_mobile_data_1

#build predictive linear model over all the datasets with attempted imputations
model <- with(data = imputed_mobile_data_total, expr = lm(app_age_current_version ~ average_rating + rating_count))

#combine all 5 predictive model results
combined_model <- pool(model)
summary(combined_model)

#install.packages('missForrest')
library(missForest)
help("missForest")
# remove features that have too many factors for randomforest
forest_data <- mobile_apps_sample %>%
  select(-one_of('developer', 'release_date')) %>% 
  as.data.frame
imputed_mobile_data <- missForest(forest_data)

#check imputed values
imputed_mobile_data$ximp

#check imputation error
#NRMSE is normalized mean squared error, capturing error derived from imputing continuous values 
#PFC is proportion of falsely classified, capturing error derived from imputing categorical values.
imputed_mobile_data$OOBerror
