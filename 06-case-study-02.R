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




