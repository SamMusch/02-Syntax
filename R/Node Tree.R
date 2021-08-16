library("googlesheet4")
library('collapsibleTree')
suppressPackageStartupMessages(library("dplyr"))
devtools::install_github("tidyverse/googlesheets4")
library(googlesheets4)



collapsibleTree(
  Geography,
  hierarchy = c("continent", "type", "country"),
  width = 800,
  zoomable = FALSE
)


org <- data.frame(
  Manager = c(
    NA, "Ana", "Ana", "Bill", "Bill", "Bill", "Claudette", "Claudette", "Danny",
    "Fred", "Fred", "Grace", "Larry", "Larry", "Nicholas", "Nicholas"
  ),
  Employee = c(
    "Ana", "Bill", "Larry", "Claudette", "Danny", "Erika", "Fred", "Grace",
    "Henri", "Ida", "Joaquin", "Kate", "Mindy", "Nicholas", "Odette", "Peter"
  ),
  Title = c(
    "President", "VP Operations", "VP Finance", "Director", "Director", "Scientist",
    "Manager", "Manager", "Jr Scientist", "Operator", "Operator", "Associate",
    "Analyst", "Director", "Accountant", "Accountant"
  )
)

collapsibleTree(org, c("Manager", "Employee"), collapsed = TRUE, width = 800, zoomable = FALSE, fill = 'Manager')
