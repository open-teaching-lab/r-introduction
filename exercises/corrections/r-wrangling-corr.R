################ Importing and manipulating data with R ########################

install.packages(c("readr","dplyr", "tidyr", "ggplot2", "remotes"))
remotes::install_github('inseefrlab/DoReMIFaSol')

library(dplyr)
library(tidyr)
library(stringr)

# Exercise 1 -------------------------------------------------------------------
url <- "https://koumoul.com/s/data-fair/api/v1/datasets/igt-pouvoir-de-rechauffement-global/convert"

# Question 1
library(readr)
emissions <- read_csv(url)

# Question 2
df <- data.frame(
  var1 = 1:10,
  var2 = letters[1:10],
  var3 = rep(c(TRUE, FALSE), times = 5)
)

head(emissions)
head(df)

# Question 3
class(emissions)

# The data imported with readr is a more complete dataframe (data.frame) with 
# tibble ameliorations (tbl/tbl_df) and readr metadata (spec_tbl_df)

# Question 4

