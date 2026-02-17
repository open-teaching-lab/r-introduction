###################### Discovering basic R objects #############################

# Exercise 2 -------------------------------------------------------------------
typeof(3)
typeof("test")
typeof(3.5)

# Exercise 3 -------------------------------------------------------------------
x1 <- "a first string"
x2 <- "and a second"
x3 <- "never two without three"
nchar(paste(x1, x2, x3, sep = ""))

# Exercise 4 -------------------------------------------------------------------
# Question 1
dep <- substr(municipality_list, start = 1, stop = 2)
# Question 2
length(
  unique(dep)
)

# Exercise 5 -------------------------------------------------------------------
a <- "    A very badly formatted string.         "
trimws(a)

# Exercise 6 -------------------------------------------------------------------
X <- matrix(letters[1:20], nrow = 4, ncol = 5)

X[1,1]
X[1,]
X[,1]
X[2:3,c(1,3)]

# Exercise 7 -------------------------------------------------------------------
my_list <- list(
  1,
  "text",
  matrix(letters[1:20], nrow = 4, ncol = 5),
  c(2, 3, 4)
)

# Question 1: display the list
my_list
# Question 2: Access the second element of the list
my_list[[2]]
my_list[[4]][2]
# Question 3: update the list with a named element and access it
my_list[['municipalities']] <- c(
  '01363', '02644', '03137', '11311'
)
my_list[['municipalities']]  
# Question 4: perform an operation 
my_list[['departments']] <- substr(my_list[['municipalities']], start = 1, stop = 2)

# Exercise 8 -------------------------------------------------------------------
# Question 1
length(my_list[[1]])
# Question 2
list_length <- length(my_list)
# Question 3
as.numeric(
  lapply(my_list, function(l) typeof(l) == "double")
)

# Exercise 9 -------------------------------------------------------------------
# Creating the data.frame df
df <- data.frame(
  var1 = 1:10,
  var2 = letters[1:10],
  var3 = rep(c(TRUE, FALSE), times = 5)
)

dim(df)
nrow(df)
ncol(df)
length(df) #like a list
df[3, c("var1","var2")]

# Exercise 10 ------------------------------------------------------------------
# Create a var4 column in our dataset equal to the square of var1
df$var4 <- (df$var1)^2

# Create a var5 column in our dataset concatenating the first two variables 
# generalizing the schema 1=a.
df$var5 <- paste(df$var1,df$var2,sep = "=")

# Create a df_small1 dataframe for rows where the logical condition var3 is verified
df_small <- df[df$var3,]
  
# Create a df_small2 dataframe for rows where var1 is even
# (see above the example on Euclidean division for the model)
df_small2 <- df[df$var1 %% 2 == 0,]
