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








