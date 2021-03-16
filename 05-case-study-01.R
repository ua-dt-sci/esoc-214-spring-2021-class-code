# load libraries
library(tidyverse)

# read both datasets in
olympic_events <- read_csv("data/olympic_history_athlete_events.csv")
noc_regions <- read_csv("data/olympic_history_noc_regions.csv")

# plot the relationship between height and weight
olympic_events %>%
  ggplot(aes(x = Height,
             y = Weight)) +
  geom_point(alpha = .5) +
  geom_smooth(method = "lm")

# Question: has athlete height changed overtime?
# group_by year and then summarize mean of height
# check in at 2:59pm (if you have these three lines of code, copy and paste them
# to the zoom chat)
# and if you are done with these three line, try to plot it (map mean_height to y
# Year to x, add geom point or line)
olympic_events %>%
  group_by(Year) %>%
  summarize(mean_height = mean(Height, na.rm = TRUE)) %>%
  ggplot(aes(x = Year,
             y = mean_height)) +
  geom_point() +
  geom_line()

# same thing, but lets add Season
olympic_events %>%
  filter(Year > 1950) %>%
  group_by(Year, Season, Sex) %>%
  summarize(mean_height = mean(Height, na.rm = TRUE)) %>%
  ggplot(aes(x = Year,
             y = mean_height,
             color = Season)) +
  geom_point() +
  geom_line() + 
  facet_wrap(~Sex)

# count how many athletes we have across years
olympic_events %>%
  count(Year, Season, Sex) %>%
  view()

####### March 16 2021 #####################
# count medals
olympic_events %>%
  filter(!is.na(Medal)) %>%
  count(Team, Medal, sort = TRUE)

# join noc_regions and olympic
olympic_events <- left_join(olympic_events,
                            noc_regions)


# count medals using region instead of team
olympic_events %>%
  filter(!is.na(Medal)) %>%
  count(region, Medal, sort = TRUE)

# get top 5 countries with the most medals
top_5_regions <- olympic_events %>%
  filter(!is.na(Medal)) %>%
  count(region) %>%
  top_n(5)

top_5_regions$region

# filter to keep 5 top countries
data_from_top5 <- olympic_events %>%
  filter(region %in% top_5_regions$region)

data_from_top5 %>%
  count(region)

# using data_from_top5
# filter data to keep Summer Olympics only
# summarize mean height by Year and region and Sex
# plot it! check at 2:51pm
data_from_top5 %>%
  filter(Season == "Summer") %>%
  group_by(Year, region, Sex) %>%
  summarize(mean_height = mean(Height, na.rm = TRUE)) %>%
  ggplot(aes(x = Year,
             y = mean_height,
             color = Sex)) +
  geom_point() +
  geom_line() +
  facet_wrap(~region)

# add Season to the plot mapping it shape
data_from_top5 %>%
  group_by(Year, Season, region, Sex) %>%
  summarize(mean_height = mean(Height, na.rm = TRUE)) %>%
  ggplot(aes(x = Year,
             y = mean_height,
             color = Sex,
             shape = Season,
             linetype = Season)) +
  geom_point() +
  geom_line() +
  facet_wrap(~region+Season)

# count Medal (Gold, Silver, Bronze) by country
# use data_from_top5 (for the top5 countries only)
# check in at 3:12pm
data_from_top5 %>%
  filter(!is.na(Medal)) %>%
  count(region, Medal) %>%
  ggplot(aes(x = Medal,
             y = n,
             fill = region)) +
  geom_col(position = "dodge")


