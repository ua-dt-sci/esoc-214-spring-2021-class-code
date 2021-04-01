# load libraries
library(tidyverse)
library(usmap)
#install.packages("usmap")

# read data in
beer_awards <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-10-20/beer_awards.csv")

# inspect statepop data
statepop
view(statepop)

# fix state abbreviation so every letter is upper case
beer_awards %>%
  distinct(state)

beer_awards <- beer_awards %>%
  mutate(state = toupper(state))

beer_awards %>%
  distinct(state)

# add statepop to beer_awards
beer_awards_w_pop <- left_join(beer_awards,
                         statepop,
                         by = c("state" = "abbr"))

# count medals
beer_awards_w_pop %>%
  count(medal)

# count medals and state
beer_awards_w_pop %>%
  count(state, medal)

# count state and plot a bar plot
beer_awards_w_pop %>%
  count(state) %>%
  ggplot(aes(x = reorder(state, n),
             y = n)) +
  geom_col() +
  theme_linedraw() +
  labs(title = "Distribution of Beer Awards in the US",
       caption = "data from the Great American Beer Festival",
       x = "")

# count state and plot a map plot
beer_awards_w_pop %>%
  count(state) %>%
  plot_usmap(data = .,
             values = "n",
             labels = TRUE) +
  theme(legend.position = "right") +
  labs(fill = "Award Count",
       title = "Distribution of Beer Awards in the US",
       caption = "data from the Great American Beer Festival") +
  scale_fill_continuous(low = "orange",
                        high = "orange4")


######### look at relationship between number of awards and population ###
beer_awards_w_pop %>%
  count(full, pop_2015) %>%
  ggplot(aes(x = pop_2015,
             y = n,
             label = full)) +
  geom_text(size = 3)

# calculate number of awards per state
beer_awards_w_pop %>%
  count(state, pop_2015) %>%
  mutate(awards_per_100k = (n/pop_2015)*100000) %>%
  plot_usmap(data = .,
             values = "awards_per_100k",
             labels = TRUE) +
  theme(legend.position = "right") +
  scale_fill_continuous(low = "orange",
                        high = "orange4",
                        name = "Awards per 100k people")

# get counts
award_count <- beer_awards %>%
  count(state)

award_count_w_pop <- left_join(statepop,
                               award_count,
                               by = c("abbr" = "state"))

award_count_w_pop <- award_count_w_pop %>%
  mutate(n = replace_na(n, 0))

award_count_w_pop %>%
  plot_usmap(data = .,
             values = "n")  +
  theme(legend.position = "right") +
  scale_fill_continuous(low = "orange",
                        high = "orange4",
                        name = "Awards per 100k people")
