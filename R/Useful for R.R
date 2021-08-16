





#### TABLE 2 PAIRWISE
multico <- data.frame(log(price)
~log(sqft_living)
+bedrooms
+bathrooms
+log(sqft_lot)
+floors
+waterfront
+condition
+age)
cor(multico, use="complete.obs")


#### TABLE 3 REGRESSION RESULTS
model2 <- lm(log(price)
~log(sqft_living)
+bedrooms
+bathrooms
+log(sqft_lot)
+floors
+waterfront
+condition
+age, data = housedata)
model2

coef <- coef(model2)
res <- residuals(model2)
fitted <- fitted(model2)


####### MODEL SIGNIFICANCE TEST
modeltest <- confint(model2,level=0.95)
modeltest

lm(formula = log(price) 
   ~log(sqft_living)
   +bedrooms
   +bathrooms
   +log(sqft_lot)
   +floors
   +waterfront
   +condition
   +age
   ,data = housedata)


model2ftest <- lm(log(price)
~log(sqft_living)
+bedrooms
+bathrooms
+log(sqft_lot)
+floors
+waterfront
+condition
+age
,data=housedata)
abline(model2ftest,lwd=1)
summary(model2ftest)

#### TABLE 4 VIF
library(car)
vif(model2)

#### TABLE 5 RAMSEY
###Joint hypothesis test, I took out bedrooms and bathrooms here
model3ftest <- lm(log(price)
~log(sqft_living)
+log(sqft_lot)
+floors
+waterfront
+condition
+age
,data=housedata)
summary(model3ftest)

anova(model3ftest,model2ftest)


###Ramsay RESET test
lincoefs <- coef(multimodel)
linresids <- residuals(multimodel)
linfitted <- fitted(multimodel)

aux1.multimodel <- lm(price~
bedrooms+ 
bathrooms+ 
sqft_living+ 
sqft_lot+
floors+
waterfront+
condition+
yr_built+
I(linfitted^2)+I(linfitted^3),
data=housedata)
summary(aux1.multimodel)
anova(multimodel,aux1.multimodel)

#### TABLE 6 BREUSCH
aux2.multimodel <- lm(I(linfitted^2)~
                        housedata$bedrooms+ 
                        housedata$bathrooms+ 
                        housedata$sqft_living+ 
                        housedata$sqft_lot+
                        housedata$floors+
                        housedata$waterfront+
                        housedata$condition+
                        housedata$yr_built,
                      data=housedata)
summary(aux2.multimodel)

#### FIGURE 1 SCATTER PLOTS
dev.new(1)
par(mfrow=c(1,2))
plot(housedata$sqft_living,
     housedata$price,
     type="p",
     main="Sq Ft vs Price of House",
     xlab="Square Feet",
     ylab="Price")

#### FIGURE 2 RESIDUALS VS FITTED, QQPLOT, COOKS
dev.new(width=8, height=4)
par(mfrow=c(1,3))
plot(model2,which=1, main="Log model: Residuals vs Fitted Values") 
plot(model2,which=2, main="Log model: Q‐Q Plot") # residual Q‐Q plot 
plot(model2,which=4, main="Log model: Cook's Distance") # Cook's distance
plot(multimodel,which=1, main="Linear model: Residuals vs Fitted Values") 
































































####summary
summary(housedata$price)
pricevariance <- var(housedata$price)
pricestandarddeviation <- sqrt(pricevariance)
pricevariance
pricestandarddeviation


#### multi regression model with log - log
model2 <- lm(log(price)
             ~log(sqft_living)
             +bedrooms
             +bathrooms
             +log(sqft_lot)
             +floors
             +waterfront
             +condition
             +age, data = housedata)
model2

coef <- coef(model2)
res <- residuals(model2)
fitted <- fitted(model2)

library(car)
vif(model2)

multico <- data.frame(log(price)
                      ~log(sqft_living)
                      +bedrooms
                      +bathrooms
                      +log(sqft_lot)
                      +floors
                      +waterfront
                      +condition
                      +age)
cor(multico, use="complete.obs")


##linear and log residual plots
dev.new(width=8, height=4)
par(mfrow=c(1,3))
plot(model2,which=1, main="Log model: Residuals vs Fitted Values") 
plot(model2,which=2, main="Log model: Q‐Q Plot") # residual Q‐Q plot 
plot(model2,which=4, main="Log model: Cook's Distance") # Cook's distance
plot(multimodel,which=1, main="Linear model: Residuals vs Fitted Values") 

modeltest <- confint(model2,level=0.95)
modeltest

lm(formula = log(price) 
   ~log(sqft_living)
   +bedrooms
   +bathrooms
   +log(sqft_lot)
   +floors
   +waterfront
   +condition
   +age
   ,data = housedata)


model2ftest <- lm(log(price)
                  ~log(sqft_living)
                  +bedrooms
                  +bathrooms
                  +log(sqft_lot)
                  +floors
                  +waterfront
                  +condition
                  +age
                  ,data=housedata)
abline(model2ftest,lwd=1)
summary(model2ftest)


###Joint hypothesis test, I took out bedrooms and bathrooms here
model3ftest <- lm(log(price)
                  ~log(sqft_living)
                  +log(sqft_lot)
                  +floors
                  +waterfront
                  +condition
                  +age
                  ,data=housedata)
summary(model3ftest)

anova(model3ftest,model2ftest)


###Ramsay RESET test
lincoefs <- coef(multimodel)
linresids <- residuals(multimodel)
linfitted <- fitted(multimodel)

aux1.multimodel <- lm(price~
                        bedrooms+ 
                        bathrooms+ 
                        sqft_living+ 
                        sqft_lot+
                        floors+
                        waterfront+
                        condition+
                        yr_built+
                        I(linfitted^2)+I(linfitted^3),
                      data=housedata)
summary(aux1.multimodel)
anova(multimodel,aux1.multimodel)


####Breusch Pagan Test
aux2.multimodel <- lm(I(linfitted^2)~
                        housedata$bedrooms+ 
                        housedata$bathrooms+ 
                        housedata$sqft_living+ 
                        housedata$sqft_lot+
                        housedata$floors+
                        housedata$waterfront+
                        housedata$condition+
                        housedata$yr_built,
                      data=housedata)
summary(aux2.multimodel)












































































































####Mean and st dev of price
summary(housedata$price)
pricevariance <- var(housedata$price)
pricestandarddeviation <- sqrt(pricevariance)
pricevariance
pricestandarddeviation

######test relationship between price and square feet
cor.test(housedata$sqft_living, housedata$price, use="complete.obs")

##### Scatter plot with price and sqft_living
dev.new(1)
par(mfrow=c(1,2))
plot(housedata$sqft_living,
     housedata$price,
     type="p",
     main="Sq Ft vs Price of House",
     xlab="Square Feet",
     ylab="Price")

####linear model
model1 <- lm(price~sqft_living, data=housedata)
abline(model1,lwd=1)
summary(model1)

#######coefficients, fitted values, residuals
betahats <- coef(model1)
betahats
residuals <- residuals(model1)
fittedvalues <- fitted(model1)

#####Calculating the predicted house price given the median square footage (1873)
pricefit <- betahats[1] + (betahats[2]*1873)
pricefit

######Confidence interval of slope with 95% interval
cislope <- confint(model1)
cislope

#####Calculating the predicted house price given 3200 sq ft
secondassignmentprice <- betahats[1] + (betahats[2]*3200)
secondassignmentprice

######Confidence interval of slope with 99% interval
cislope99 <- confint(model1, level=0.99)
cislope99

#######confidence interval for mean y
xvals <- data.frame(sqft_living=c(390,8000))
cimeany <- predict(model1, data.frame(sqft_living=3800), interval="confidence", level=0.95)
cimeany

#####prediction interval for the mean of a home w living area 3800 sq ft
pi <- predict(model1, data.frame(sqft_living=3800), interval="prediction", level=0.95)
pi

##dev.new(width=8,height=4)
##par(mfrow=c(1,2))
##plot(housedata$sqft_living,residuals,type="p",main="Residuals against Sq ft Living Area",xlab="Sq ft",ylab="residuals")
##plot(model1,which=1)

###calculating age of homes
housedata$age = 2015 - housedata$yr_built
summary(housedata$age)
sd(housedata$age)
var(housedata$age)

summary(housedata$waterfront)

pairwise <- data.frame(bedrooms, bathrooms, sqft_living, sqft_lot, floors,waterfront, condition,yr_built)
cor(pairwise, use="complete.obs")









############# IGNORE #############

######multiple regression model with lin-lin
multimodel <- lm(price~bedrooms+bathrooms+sqft_living+sqft_lot+floors+waterfront+ condition+yr_built+ data=housedata)
summary(multimodel)

####scatter plot of residuals
####qq plot of residuals
####cooks plot of residuals
dev.new(width=8, height=4)
par(mfrow=c(1,3))
plot(multimodel,which=1, main="Linear model: Residuals vs Fitted Values") 
plot(multimodel,which=2, main="Linear model: Q‐Q Plot") # residual Q‐Q plot 
plot(multimodel,which=4, main="Linear model: Cook's Distance") # Cook's distance

############# IGNORE #############











############# THIS IS REALLY WHERE YOU ARE LOOKING #############

#### multi regression model with log - log
model2 <- lm(log(price)
~log(sqft_living)
+bedrooms
+bathrooms
+log(sqft_lot)
+floors
+waterfront
+condition
+age, data = housedata)
model2

coef <- coef(model2)
res <- residuals(model2)
fitted <- fitted(model2)

library(car)
vif(model2)

multico <- data.frame(log(price)
~log(sqft_living)
+bedrooms
+bathrooms
+log(sqft_lot)
+floors
+waterfront
+condition
+age)
cor(multico, use="complete.obs")


##linear and log residual plots
dev.new(width=8, height=4)
par(mfrow=c(1,3))
plot(model2,which=1, main="Log model: Residuals vs Fitted Values") 
plot(model2,which=2, main="Log model: Q‐Q Plot") # residual Q‐Q plot 
plot(model2,which=4, main="Log model: Cook's Distance") # Cook's distance
plot(multimodel,which=1, main="Linear model: Residuals vs Fitted Values") 

modeltest <- confint(model2,level=0.95)
modeltest

lm(formula = log(price) 
   ~log(sqft_living)
   +bedrooms
   +bathrooms
   +log(sqft_lot)
   +floors
   +waterfront
   +condition
   +age
   ,data = housedata)


model2ftest <- lm(log(price)
~log(sqft_living)
+bedrooms
+bathrooms
+log(sqft_lot)
+floors
+waterfront
+condition
+age
,data=housedata)
abline(model2ftest,lwd=1)
summary(model2ftest)


###Joint hypothesis test, I took out bedrooms and bathrooms here
model3ftest <- lm(log(price)
~log(sqft_living)
+log(sqft_lot)
+floors
+waterfront
+condition
+age
,data=housedata)
summary(model3ftest)

anova(model3ftest,model2ftest)


###Ramsay RESET test
lincoefs <- coef(multimodel)
linresids <- residuals(multimodel)
linfitted <- fitted(multimodel)

aux1.multimodel <- lm(price~
                        bedrooms+ 
                        bathrooms+ 
                        sqft_living+ 
                        sqft_lot+
                        floors+
                        waterfront+
                        condition+
                        yr_built+
                        I(linfitted^2)+I(linfitted^3),
                      data=housedata)
summary(aux1.multimodel)
anova(multimodel,aux1.multimodel)


####Breusch Pagan Test
aux2.multimodel <- lm(I(linfitted^2)~
                        housedata$bedrooms+ 
                        housedata$bathrooms+ 
                        housedata$sqft_living+ 
                        housedata$sqft_lot+
                        housedata$floors+
                        housedata$waterfront+
                        housedata$condition+
                        housedata$yr_built,
                      data=housedata)
summary(aux2.multimodel)























################## This is all the work I had done before we got into time-series. #######################




########################################################
library("stargazer")
#### TABLE 1 SUMMARY STATS
stargazer(agwage[,-1], type="text", title="Table 1. Descriptive Statistics", digits=2, align = TRUE,
          out="table1_N.txt")


#### TABLE 2 CORRELATION
cor.mat <- cor(agwage[, c(2,3,4,5,6,9,10)], use="complete.obs")
stargazer(cor.mat, type="text", title="Table 2. Correlation Matrix", 
          digits=3, align = TRUE,out="table2_N.txt")



############# TABLE 3 REGRESSION RESULTS #############
#### multi regression model with log - lin
modelloglin <- 
  lm(log(wages)~FY+wages+CPI,AGRI+gdpgrow+TREND+ FEMALE+ MALE+AGE+AGESQ+ HISPANIC+ 
       USBORN+ UNDOCUMENTED+ ENGL+EDUC+ FARMEXP+ FARMEXPSQ+ TENURE+ FRUITNUT+ 
       HORT+ VEGE+ OTHERCROP+ EAST+ SE+ MIDW+ SW+NW, data = agwage)
summary(modelloglin)


coef <- coef(modelloglin)
res <- residuals(modelloglin)
fitted <- fitted(modelloglin)

stargazer(modelloglin, type="text",title="Table 3. Regression Results", 
          digits=2, align = TRUE,
          dep.var.lables=c("log(wages)"),
          covariate.lables=c("FY","wages","CPI","AGRI","gdpgrow","TREND", "FEMALE", "MALE","AGE","AGESQ", "HISPANIC", 
                             "USBORN", "UNDOCUMENTED", "ENGL","EDUC", "FARMEXP", "FARMEXPSQ", "TENURE", "FRUITNUT", 
                             "HORT", "VEGE", "OTHERCROP", "EAST", "SE", "MIDW", "SW","NW"),out="table3_N.txt")


############# TABLE 4 VIF #############
library(car)
vif(modelloglin)


############# TABLE 5 RAMSEY #############
###Ramsay RESET test
lincoefs <- coef(modelloglin)
linresids <- residuals(modelloglin)
linfitted <- fitted(modelloglin)

aux1.multimodel <- lm(log(wages)~FY+wages+CPI,AGRI+gdpgrow+TREND+ FEMALE+ MALE+AGE+AGESQ+ HISPANIC+ 
                        USBORN+ UNDOCUMENTED+ ENGL+EDUC+ FARMEXP+ FARMEXPSQ+ TENURE+ FRUITNUT+ 
                        HORT+ VEGE+ OTHERCROP+ EAST+ SE+ MIDW+ SW+NW+
                        I(linfitted^2)+I(linfitted^3),
                      data=agwage)
summary(aux1.multimodel)
anova(modelloglin,aux1.multimodel)


############# TABLE 6 BREUSCH #############
####Breusch Pagan Test
aux2.multimodel <- lm(I(linfitted^2)~
                        FY+wages+CPI,AGRI+gdpgrow+TREND+ FEMALE+ MALE+AGE+AGESQ+ HISPANIC
                      +USBORN+ UNDOCUMENTED+ ENGL+EDUC+ FARMEXP+ FARMEXPSQ+ TENURE+ FRUITNUT
                      +HORT+ VEGE+ OTHERCROP+ EAST+ SE+ MIDW+ SW+NW,
                      data=agwage)
summary(aux2.multimodel)


































############ FIGURE 1 SCATTER PLOT




########### FIGURE 2 RESIDUAL PLOTS
##linear and log residual plots
dev.new(width=8, height=4)
par(mfrow=c(1,3))
plot(model2,which=1, main="Log model: Residuals vs Fitted Values") 
plot(model2,which=2, main="Log model: Q‐Q Plot") # residual Q‐Q plot 
plot(model2,which=4, main="Log model: Cook's Distance") # Cook's distance





avgwages <- ggplot(agwage, aes(x=FY, 
                               y=wages, main="Average Wage over time of Documented vs Undocumented",
                               group = UNDOCUMENTED, 
                               color = UNDOCUMENTED)) + stat_summary(fun.y="mean", geom="bar")
titles <- avgwages + ggtitle("Doc vs Undoc: Avg Wage by FY") +xlab("FY") + ylab("Avg Wage") 
titles + theme(
  plot.title = element_text(color="black", size=20, face="bold.italic"),
  axis.title.x = element_text(color="black", size=17, face="bold"),
  axis.title.y = element_text(color="black", size=17, face="bold")
)























######## TIME SERIES REDSIDUALS

## plot the residuals over time
dev.new(width=8, height=4)
par(mfrow=c(1,2))
plot(agwage$FY, agwage$res, type="l", main="Static Model: Residuals Over Time",
     xlab="Year", ylab="Residuals")
plot(agwage$FY[2:nrow(agwage)], modelloglinl$res, type="l", main="Static Model (First Differences): Residuals Over Time",
     xlab="Year", ylab="Residuals")

dev.new(width=8, height=4)
par(mfrow=c(1,2))
plot(agwage$FY, agwage$res, type="l", main="Static Model: Residuals Over Time",
     xlab="Year", ylab="Residuals")
plot(agwage$FY[2:nrow(agwage)], modelloglinl$res, type="l", main="Static Model (First Differences): Residuals Over Time",
     xlab="Year", ylab="Residuals")

########### The above are the residual plots over time. Next, I will do the Breusch-Godfrey to test for serial.















########## Scatter diagrams
dev.new(width=8, height=4)
par(mfrow=c(1,6))
plot(agwage$gdpgrow, agwage$wages, type="p", main="Agriculture Real Wages by US GDP Growth",
     xlab="US GDP Growth", ylab="Real Agriculture Wages")
plot(agwage$AGRI, agwage$wages, type="p", main="Agriculture Real Wages by Industry Addition to GDP",
     xlab="Agriculture added to US GDP", ylab="Real Agricultural Wages")
plot(agwage$gdpgrow, agwage$AGRI, type="p", main="Agriculture added to GDP by GDP Growth",
     xlab="GDP Growth", ylab="Agriculture Added to GDP")
