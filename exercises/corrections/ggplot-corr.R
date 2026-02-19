################## Data visualization with ggplot2 #############################
library(scales)
library(readr)
library(dplyr)
library(forcats)
library(lubridate)
library(ggplot2)
library(plotly)

url <- "https://minio.lab.sspcloud.fr/projet-formation/diffusion/python-datascientist/bike.csv"
download.file(url, "bike.gz", mode = "wb")

# Exercise 1 -------------------------------------------------------------------
# Question 1 : Import the data and translate the column names
df <- readr::read_csv("bike.gz") %>% 
  dplyr::rename(
    `counter_id` = `Identifiant du compteur`,
    `Counter name` = `Nom du compteur`,
    `counting_site_id` = `Identifiant du site de comptage`,
    `counting_site_name` = `Nom du site de comptage`,
    `Hourly count` = `Comptage horaire`,
    `Counting date and time` = `Date et heure de comptage`,
    `counting_site_installation_date` = `Date d'installation du site de comptage`)


# Question 2
df1 <- df %>%
  group_by(`Counter name`) %>%
  summarise(`Hourly count` = mean(`Hourly count`, na.rm = TRUE)) %>%
  arrange(desc(`Hourly count`)) %>%
  head(10)

# Question 3
ggplot(df1, aes(y = `Counter name`, x = `Hourly count`)) +
  geom_bar(stat = "identity")

# Question 4
figure1 <- ggplot(df1,
                  aes(y = reorder(`Counter name`, `Hourly count`),
                      x = `Hourly count`)) +
  geom_bar(stat = "identity")
figure1

# Question 5
figure1 <- ggplot(df1,
                  aes(y = reorder(`Counter name`, `Hourly count`),
                      x = `Hourly count`)) +
  geom_bar(stat = "identity", fill = "red")
figure1

# Exercise 2 -------------------------------------------------------------------
# Question 1
figure1 <- figure1 + labs(
  title = "The 10 counters with the highest hourly average",
  x = "Counter name",
  y = "Hourly average"
)
figure1

# Question 2
figure1 <- figure1 +
  theme_minimal()
figure1

# Question 3
theme(
  axis.text.x = element_text(angle = 45, hjust = 1, color = "red"),
  axis.title.x = element_text(color = "red"),
  plot.title = element_text(hjust = 0.5),
  plot.margin = margin(1, 4, 1, 1, "cm")
)

# Exercise 3 -------------------------------------------------------------------
df2 <- df %>%
  group_by(`Counter name`) %>%
  summarise(`Hourly count` = sum(`Hourly count`, na.rm = TRUE)) %>%
  arrange(desc(`Hourly count`)) %>%
  head(10)

# Create a horizontal bar plot
figure2 <- ggplot(df2, aes(y = reorder(`Counter name`, `Hourly count`), x = `Hourly count`)) +
  geom_bar(stat = "identity", fill = "forestgreen") +
  labs(title = "The 10 counters that recorded the most bicycles",
       x = "Name of the counter",
       y = "The total number of bikes recorded during the selected period") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.x = element_text(color = "forestgreen"),
        plot.title = element_text(hjust = 0.5),
        plot.margin = margin(1, 4, 1, 1, "cm"))


df2_lollipop <- df2 %>%
  mutate(x =  fct_reorder(`Counter name`, `Hourly count` ), y = `Hourly count`)

figure2_lollipop <- ggplot(df2_lollipop, aes(x=x, y=y)) +
  geom_segment(aes(xend=x, yend=0), alpha = 0.4) +
  geom_point(size=5, color="forestgreen") +
  coord_flip() +
  labs(title = "The 10 counters that recorded the most bicycles",
       x = "Name of the counter",
       y = "The total number of bikes recorded during the selected period")  +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.x = element_text(color = "forestgreen"),
        plot.title = element_text(hjust = 0.5),
        plot.margin = margin(1, 4, 1, 1, "cm")) +
  scale_y_continuous(labels = unit_format(unit = "M", scale=1e-6))

# Exercise 4 -------------------------------------------------------------------
# Question 1
df <- df %>%
  mutate(month = format(`Counting date and time`, "%Y-%m"))

# Question 2
monthly_hourly_count <- df %>%
  group_by(month) %>%
  summarise(value = mean(`Hourly count`, na.rm = TRUE))

# Question 3
figure3 <- ggplot(monthly_hourly_count) +
  geom_bar(aes(x = month, y = value), fill = "#ffcd00", stat = "identity") +
  labs(x = "Date and time of count", y = "Average hourly count per month\nover the selected period",
       title = "Average monthly bicycle counts") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), # rotates crowded X labels
        axis.title.y = element_text(color = "#ffcd00", face = "bold"), # colors and bolds Y title
        plot.title = element_text(hjust = 0.5), # centers the main title
        plot.margin = margin(1, 4, 1, 1, "cm")) # adds extra space on the right side




