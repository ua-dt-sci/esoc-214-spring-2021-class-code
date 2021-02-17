# ESOC 214 intro to tidyverse
# install tidyverse (you need to install only once)
#install.packages("tidyverse")
# load tidyverse
library(tidyverse)

# check your working environment
# get working directory
getwd()
# list contents of the current directory
dir()
# list contents of a specific folder in my current directory
dir("data")

# read the data in
country_vaccinations <- read_csv("data/country_vaccinations.csv")

# inspect our data
country_vaccinations
summary(country_vaccinations)
glimpse(country_vaccinations)
colnames(country_vaccinations)

# retrieve country from my data
country_vaccinations$country
country_vaccinations[,1]

# apply functions to specific columns
unique(country_vaccinations$country)
unique(country_vaccinations$vaccines)

# THE PIPE ##### %>% ##### AND THEN (pipe for bash is |)
# it allows you to sequence your functions
country_vaccinations %>%
  summary()

# retrieve unique values in country from data
country_vaccinations %>%
  select(country) %>% # shortcut for pipe is ctrl/cmd + shift + m
  unique()

# count() on categorical data
# count how many vaccine types
country_vaccinations %>%
  count(vaccines)

# group_by() + count()
country_vaccinations %>%
  group_by(vaccines) %>%
  count()

# group_by() + summarize()
country_vaccinations %>%
  group_by(vaccines) %>%
  summarize(total = n())

# count observations of country and vaccines
country_vaccinations %>%
  group_by(vaccines, country) %>%
  summarize(total_days = n(),
            total_per_hundred = max(total_vaccinations_per_hundred,
                                    na.rm = TRUE)) 

############# February 09, 2021 ############
# The problem: too many countries
country_vaccinations %>%
  distinct(country)

# filter the data to keep just one country
# United States
us_vaccinations <- country_vaccinations %>%
  filter(country == "United States")

# filter data to keep more than one country
# United States, Israel + any other country of your choosing
us_israel_vaccinations <- country_vaccinations %>%
  filter(country == "United States" | country == "Israel")

# check data
us_israel_vaccinations %>%
  count(country)

# north america country
north_america_vaccinations <- country_vaccinations %>%
  filter(country == "United States" |
           country == "Mexico" |
           country == "Canada")

# check data
north_america_vaccinations %>%
  count(country)

# another way to do multiple comparisons (OR)
north_america_vaccinations <- country_vaccinations %>%
  filter(country %in% c("United States", "Mexico", "Canada"))

# check data
north_america_vaccinations %>%
  count(country)

# us_israel data
us_israel_vaccinations %>%
  group_by(country) %>%
  summarize(percent_vaccinated = max(total_vaccinations_per_hundred,
                na.rm = TRUE))

# get the lastest date per country
us_israel_vaccinations %>%
  group_by(country) %>%
  summarize(lastest_observation_date = max(date, na.rm = TRUE))

us_israel_vaccinations %>%
  filter(date == parse_date("2021-02-07")) %>%
  select(country, total_vaccinations_per_hundred)

# north america (do the summarization, but starting with north_america_vaccinations)
north_america_vaccinations %>%
  group_by(country) %>%
  summarize(percent_vaccinated = max(total_vaccinations_per_hundred,
                                     na.rm = TRUE))

#################### Visualization #################
us_israel_vaccinations %>%
  ggplot(aes(x = date,
             y = daily_vaccinations,
             color = country)) +
  geom_point()

north_america_vaccinations %>%
  filter(country != "United States") %>%
  ggplot(aes(x = date,
             y = daily_vaccinations,
             color = country)) +
  geom_point()

