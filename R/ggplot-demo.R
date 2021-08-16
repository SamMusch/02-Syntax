library(ggplot2)
library(gridExtra) #useful for placing multiple ggplot2 graphs in a single plot

d <- data.frame(x = c(1:10, 1:10),
                y = runif(20),
                group1 = rep(gl(2, 5, labels = c("a", "b")), 2),
                group2 = gl(2, 10))

View(d)
head(d)

#quick example of shwoing entire data
ggplot(d) + geom_point(aes(x, y, colour = group1)) +
  facet_grid(.~group2)

ggplot(d) + geom_point(aes(x, y, colour = group1)) +
  facet_grid(group2~.)


#visualizing one dimension
ggplot(d) + geom_bar(aes(y))
ggplot(d) + geom_bar(aes(y), stat = "bin")
ggplot(d) + geom_area(aes(y), stat = "bin")

g1 <-ggplot(d) + geom_histogram(aes(y))
g2 <-ggplot(d) + geom_histogram(aes(y))+ geom_density(aes(y))

#multiple graphs on one panel
grid.arrange( g1, g2, ncol=2)

#playing around with bin size of histogram
head(diamonds)

gd1 <-ggplot(diamonds) + geom_histogram(aes(carat), binwidth=0.1)
gd2 <-ggplot(diamonds) + geom_histogram(aes(carat), binwidth=0.01)
grid.arrange( gd1, gd2, ncol=2)

gd3 <- ggplot(diamonds) + stat_density(aes(carat))
gd3a <- ggplot(diamonds) + geom_density(aes(carat))
gd3ab <- ggplot(diamonds) + geom_density(aes(carat), fill = "red")

#multiple graphs on one panel
grid.arrange( gd3, gd3a, gd3ab, ncol=2, nrow=2)

#box plot needs two dimensions -- good for comparisons
ggplot(diamonds) + stat_boxplot(aes(x=clarity, y=carat))                                 


#discrete data
str(mtcars)
gc1 <- ggplot(mtcars) + geom_bar(aes(cyl))
gc1a <- ggplot(mtcars) + geom_bar(aes(factor(cyl)))
grid.arrange( gc1, gc1a, ncol=2)

gc1b <- ggplot(mtcars, aes(factor(cyl)))

grid.arrange( gc1b + geom_bar(width =0.5), 
              gc1b + geom_bar(fill="white", colour="darkgreen"), ncol=2)

#visualizing two dimensions
gc2 <- ggplot(mtcars, aes(wt, mpg))

#draw scatter plot
gc2 + geom_point()

#loess fitting -- polynomial local fitting
gc2 + geom_smooth()

#fitting a linear model
gc2 + geom_smooth(method = "lm", color ="red")

#labels
gc2 <- gc2 + labs(title="Automobile Data", x="Weight", y="Miles Per Gallon")

#changing point and line type
gc2 <- gc2 + geom_point(pch=9)
gc2 + geom_smooth(linetype = 5)


#one command
ggplot(data=mtcars, aes(x=wt, y=mpg)) +
  geom_point(pch=15, color="blue", size=4) +
  geom_smooth(method="lm", color="red", linetype=3) +
  labs(title="Automobile Data", x="Weight", y="Miles Per Gallon")

                            

#discrete x continuous  y
#box plot needs two dimensions -- good or comparisons
ggplot(diamonds) + stat_boxplot(aes(x=clarity, y=carat))                                 

#convert some suitable variables into factors
mtcars$am <- factor(mtcars$am, levels=c(0,1),
                    labels=c("Automatic", "Manual"))
mtcars$vs <- factor(mtcars$vs, levels=c(0,1),
                    labels=c("V-Engine", "Straight Engine"))
mtcars$cyl <- factor(mtcars$cyl)

#comparing gas consumption for automatic vs manual
gc3 <- ggplot(mtcars, aes(am, mpg))
gc3 <- gc3 +  stat_boxplot()
gc3

#adding a third dimension (two discrete, one continous)
gc3 + facet_grid(~vs)

#three continuous  dimensions
gc2 + geom_point(aes(size=qsec), pch=1)

#try color instead and also use alpha to reduce shading
gc2 + geom_point(aes(color=qsec), pch=19, size = 4)
gc2 + geom_point(aes(alpha=qsec), pch=19, size = 3)

#two continous and one discrete
gc4 <- ggplot(mtcars, aes(wt, mpg))
gc4 + geom_point((aes(shape=cyl, color=cyl)), size =5)

#five dimensions!
gc5 <- ggplot(mtcars, aes(wt, mpg))
gc5 <- gc5 + geom_point((aes(shape=cyl, color=cyl)), size =5)
gc5 + facet_grid(am~vs)


#6 -- 3 continous and three categorical
gc6 <- ggplot(mtcars, aes(wt, mpg))
gc6 <- gc6 + geom_point((aes(size=qsec, color=cyl)))
gc6<- gc6 + facet_grid(am~vs)
gc6

#include the name of the car on ever point (kind of messy)
gc6+geom_text(label=rownames(mtcars))

#Extra using area plot in stacks
library(gcookbook)
head(uspopage)
tail(uspopage)
ggplot(uspopage, aes(x=Year, y=Thousands, fill=AgeGroup)) + geom_area()

ggplot(uspopage, aes(x=Year, y=Thousands, fill=AgeGroup)) +
  geom_area(colour="black", size=.2, alpha=.4) +
  scale_fill_brewer(palette="Blues", breaks=rev(levels(uspopage$AgeGroup)))

