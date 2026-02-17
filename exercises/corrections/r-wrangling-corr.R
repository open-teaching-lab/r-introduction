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
first_10 <- head(emissions, 10)
last_15 <- tail(emissions, 15)
random_sample <- sample_n(emissions,10)

# Exercise 2 -------------------------------------------------------------------
# Question 1
emissions_copy <- emissions %>%
  select(`INSEE commune`, `Commune`, `Autres transports`, `Autres transports international`)

# Question 2
emissions_copy <- emissions_copy %>%
  rename(
    code_insee = `INSEE commune`,
    transports = `Autres transports`,
    transports_international = `Autres transports international`
  )

# Question 3
emissions_copy <- emissions_copy %>%
  mutate(
    transports = replace_na(transports),
    transports_international = replace_na(transports_international)
  )

# Question 4
emissions_copy <- emissions_copy %>%
  mutate(
    dep = str_sub(code_insee, 1, 2),
    transports_total = transports + transports_international
  )

# Question 5
emissions_copy %>%
  arrange(desc(transports_total))

emissions_copy %>%
  arrange(dep, desc(transports_total))

# Question 6
emissions_copy %>%
  group_by(dep) %>%
  summarise(sum(transports_total))

# Importing Insee data ---------------------------------------------------------
library(doremifasol)
library(tibble)
filosofi <- as_tibble(
  telechargerDonnees("FILOSOFI_COM", date = 2016)
)
head(filosofi)

# Data cleaning ----------------------------------------------------------------
# Question 1
str(emissions)
intersect(colnames(filosofi), colnames(emissions))

# Question 2
str(filosofi)
str(emissions)

# Question 3
dim(filosofi)
dim(emissions)

# Question 4
emissions %>%
  select('INSEE commune', 'Commune') %>%
  summarize(Unique_Count = n_distinct(Commune))

filosofi %>%
  select('CODGEO', 'LIBGEO') %>%
  summarize(Unique_Count = n_distinct(LIBGEO))

# Question 5
duplicates <- filosofi %>%
  group_by(LIBGEO) %>%
  summarize(Count = n()) %>%
  select(LIBGEO, Count) %>%
  #arrange(desc(Count)) %>%
  filter(Count > 1)

# Question 6
filosofi %>%
  filter(LIBGEO %in% duplicates$LIBGEO) %>%
  arrange(LIBGEO)

# Question 7
filosofi %>%
  filter(LIBGEO %in% duplicates$LIBGEO) %>%
  summarize(Stats = mean(NBPERSMENFISC16, na.rm = TRUE))

# Calculate summary statistics for 'NBPERSMENFISC16' for rows where 'LIBGEO' 
# is not in 'x$LIBGEO'
filosofi %>%
  filter(!(LIBGEO %in% duplicates$LIBGEO)) %>%
  summarize(Stats = mean(NBPERSMENFISC16, na.rm = TRUE))

# Question 8
filosofi_big <- filosofi %>%
  filter(NBPERSMENFISC16 > 100000) %>%
  mutate(probleme = LIBGEO %in% duplicates$LIBGEO)

# Proportion of problematic cities
mean_probleme <- filosofi_big %>%
  summarize(mean(probleme))

# Filter rows where 'probleme' is TRUE
df_probleme <- filosofi_big %>%
  filter(probleme)

# Question 9
filosofi %>%
  filter(LIBGEO == 'Montreuil')

# Question 10
filosofi %>%
  filter(grepl('Saint-Denis', LIBGEO)) %>%
  head(10)

# Exercise 3 -------------------------------------------------------------------
# Question 1
library(stringr)

emissions <- emissions %>%
  rename('code_insee' = `INSEE commune`)

# Question 2
emissions <- emissions %>%
  mutate(dep = str_sub(code_insee, start = 1, end = 2))
filosofi <- filosofi %>%
  mutate(dep = str_sub(CODGEO, start = 1, end = 2))

# Question 3
emissions_log <- emissions %>%
  group_by(dep) %>%
  summarise(across(where(is.numeric), sum, na.rm = TRUE)) %>%
  mutate(across(where(is.numeric), log))

# Question 4
## Total emissions by department
emissions_dep <- emissions %>%
  mutate(total = rowSums(pick(where(is.numeric)), na.rm = TRUE)) %>%
  group_by(dep) %>%
  summarise(total = sum(total))
gros_emetteurs <- emissions_dep %>%
  arrange(desc(total)) %>%
  head(10)
petits_emetteurs <- emissions_dep %>%
  arrange(total) %>%
  head(5)

## Characteristics of these departments in filosofi
gros_emetteurs_filosofi <- filosofi %>%
  filter(dep %in% gros_emetteurs$dep) %>%
  group_by(dep) %>%
  summarise(across(c('NBPERSMENFISC16','MED16'), \(x) mean(x, na.rm = TRUE)))

head(gros_emetteurs_filosofi)

# Exercise 4 -------------------------------------------------------------------
# Question 1
library(tidyr)

df_long <- emissions %>%
  pivot_longer(cols = -c(code_insee, Commune, dep),
               names_to = "secteur",
               values_to = "emissions")

# Question 2
df_long_summary <- df_long %>%
  group_by(secteur) %>% summarise(emissions = sum(emissions, na.rm = TRUE))

# Question 3
df_long_dep <- df_long %>%
  group_by(secteur, dep) %>%
  summarise(emissions = sum(emissions, na.rm = TRUE)) %>%
  arrange(desc(dep), desc(emissions)) %>%
  group_by(dep) %>%
  slice_head(n = 1)


# Exercise 5 : long to wide ----------------------------------------------------
# TODO

# Exercise 6 -------------------------------------------------------------------
# Question 1
emissions <- emissions %>%
  mutate(total = rowSums(pick(where(is.numeric)), na.rm = TRUE))

# Question 2
emissions_merged <- emissions %>%
  left_join(filosofi, by = c("code_insee" = "CODGEO"))

# Question 3
emissions_merged <- emissions_merged %>%
  mutate(empreinte = total/NBPERSMENFISC16)

# Question 4
ggplot(emissions_merged) +
  geom_histogram(aes(x = empreinte, y = after_stat(density))) +
  scale_x_log10()

# Question 5
emissions_merged <- emissions_merged %>%
  rename(departement = dep.x) %>%
  group_by(departement) %>%
  mutate(empreinte_mediane = median(empreinte, na.rm = TRUE)) %>%
  mutate(empreinte_relative = empreinte/empreinte_mediane)

emissions_merged %>% arrange(empreinte_relative)

# Question 6
library(tibble)

correlations <- cor(
  emissions_merged %>% ungroup() %>% select(where(is.numeric)),
  use="complete.obs"
)[,'empreinte']

correlations <- enframe(correlations) %>%
  filter(name %in% colnames(filosofi)) %>%
  arrange(desc(abs(value)))
