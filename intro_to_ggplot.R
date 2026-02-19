# Open the package
library(ggplot2)

# Basic call to create a plot (don't run)
ggplot(data = my_data, aes(x = var1, y = var2)) +
  geom_point()

######## Aesthetics — what do your variables represent visually? ###############
# Aesthetics map a column in your data to a visual property. 
# Common ones are x, y, color, fill, size, shape, and alpha.

# Using the built-in 'mtcars' dataset ------------------------------------------
head(mtcars) # mtcars is data part of base R

# mpg:	Miles/(US) gallon
# cyl: Number of cylinders
# disp: Displacement (cu.in.)
# hp: Gross horsepower
# drat: Rear axle ratio
# wt: Weight (1000 lbs)
# qsec: 1/4 mile time
# vs: Engine (0 = V-shaped, 1 = straight)
# am: Transmission (0 = automatic, 1 = manual)
# gear: Number of forward gears
# carb: Number of carburetors

# Basic scatterplot
ggplot(mtcars, aes(x = hp, y = mpg)) +
  geom_point()

# Adding colors
# color is mapped to a variable (don't run)
aes(color = cyl)

# color is fixed for all points (don't run)
geom_point(color = "steelblue")

ggplot(mtcars, aes(x = hp, y = mpg, color = factor(cyl))) +
  geom_point()

ggplot(mtcars, aes(x = hp, y = mpg)) +
  geom_point(color = "blue")

############# Geoms — how should your data be drawn? ###########################
# Geoms are the geometric shapes that actually render your data.

# Same aes, different geoms ----------------------------------------------------
# Both plots use the same mapping
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_boxplot()   # boxplot

ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_jitter()    # scatter plot

# You can stack multiple geoms on the same plot
ggplot(mtcars, aes(x = hp, y = mpg)) +
  geom_point(color = "steelblue") +
  geom_smooth(method = "lm", se = FALSE, color = "tomato")
# This adds a scatter plot and a linear regression line on top of it.

######################## Facets — small multiples ##############################
# Facets split your plot into subplots based on a variable
ggplot(mtcars, aes(x = hp, y = mpg)) +
  geom_point() +
  facet_wrap(~ cyl)   # one panel per number of cylinders

############################# Labels and themes ################################
# labs() controls titles and axis labels. Themes control the overall appearance.
ggplot(mtcars, aes(x = hp, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(
    title = "Fuel Efficiency vs Horsepower",
    x = "Horsepower",
    y = "Miles per Gallon",
    color = "Cylinders"
  )

ggplot(mtcars, aes(x = hp, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(
    title = "Fuel Efficiency vs Horsepower",
    x = "Horsepower",
    y = "Miles per Gallon",
    color = "Cylinders"
  ) +
  theme_dark()

################################# Wrap-up ######################################
ggplot(data, aes(...))   ← data + mapping
+ geom_*()             ← how to draw it
+ facet_*()            ← split into panels
+ labs()               ← titles & labels
+ theme_*()            ← overall appearance

