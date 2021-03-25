# installation code
#install.packages("janitor")
#install.packages("lubridate")

# load libraries
library(countrycode)
library(janitor)
library(lubridate)
library(tidyverse)

# read data in
global_temperatures <- read_csv("https://raw.githubusercontent.com/esoc214/fall2020_002_class_scripts/main/data/GlobalLandTemperaturesByCountry.csv")

# standardize column names to snake case
global_temperatures <- global_temperatures %>%
  clean_names()

# manipulating date
class(global_temperatures$dt)
year(global_temperatures$dt)
month(global_temperatures$dt)
month(global_temperatures$dt, label = TRUE)
month(global_temperatures$dt, label = TRUE, abbr = FALSE)
week(global_temperatures$dt)
day(global_temperatures$dt)
wday(global_temperatures$dt)

# create two variables in our data
global_temperatures <- global_temperatures %>%
  mutate(year = year(dt),
         month = month(dt),
         decade = (year %/% 10) * 10)

# how many countries we have in the data
global_temperatures %>%
  distinct(country)

# add continent as a variable in dataframe
global_temperatures <- global_temperatures %>%
  mutate(continent = countrycode(sourcevar = country,
                                 origin = "country.name",
                                 destination = "continent"))

# remove rows where continent is NA
global_temperatures_countries <- global_temperatures %>%
  filter(!is.na(continent))

# start with global_temperatures_countries and then
# group by decade and continent and then
# summarize the mean of average_temperatures
# check in at 3:01pm
# add ggplot to it to plot the results
global_temperatures_countries %>%
  filter(decade > 1850) %>%
  group_by(decade, continent) %>%
  summarize(mean_temperature = mean(average_temperature, na.rm = TRUE)) %>%
  ggplot(aes(x = decade,
             y = mean_temperature,
             color = continent)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(breaks = c(1860, 1900, 1940, 1980, 2010))

# let's plot month instead of decade
global_temperatures_countries %>%
  filter(decade > 1850) %>%
  group_by(month, continent) %>%
  summarize(mean_temperature = mean(average_temperature, na.rm = TRUE)) %>%
  ggplot(aes(x = month,
             y = mean_temperature,
             color = continent)) +
  geom_point() +
  geom_line()

#################### March 25 2021 #################
# start with global_temperatures_countries and then
# filter to keep data only since 1850 and
# group by continent and year and then
# summarize mean of average_temperature
# check in at 2:25pm
# add ggplot to it, use geom_point() and map color to continent
global_temperatures_countries %>%
  filter(year > 1850) %>%
  group_by(continent, year) %>%
  summarize(mean_temperature = mean(average_temperature, na.rm = TRUE)) %>%
  ggplot(aes(x = year,
             y = mean_temperature,
             color = continent)) +
  geom_point()

# let's choose countries to filter our data by
countries_to_keep <- c("Poland", "United States", "China", "India", "Brazil")

filtered_temperatures <- global_temperatures_countries %>%
  filter(country %in% countries_to_keep)

filtered_temperatures %>%
  count(country)

# plot it!
filtered_temperatures %>%
  filter(year > 1899) %>%
  group_by(country, year) %>%
  summarize(mean_temperature = mean(average_temperature, na.rm = TRUE)) %>%
  ggplot(aes(x = year,
             y = mean_temperature,
             color = country)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~country, scales = "free") +
  labs(caption = "each plot is in a different scale")

library(ggthemes)
# plot it by month
filtered_temperatures %>%
  group_by(country, month) %>%
  summarize(mean_temperature = mean(average_temperature, na.rm = TRUE)) %>%
  ggplot(aes(x = month,
             y = mean_temperature,
             color = country)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(breaks = c(1:12)) +
  facet_wrap(~country, scales = "free") +
  theme_wsj() +
  labs(caption = "plots are in different scales")
