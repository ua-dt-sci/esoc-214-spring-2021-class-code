# load library
library(tidyverse)


# print current working directory
getwd()

# list contents in data
dir("data")

# read data in
spotify_data <- read_csv("data/spotify_songs.csv")
spotify_data <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-21/spotify_songs.csv")

# HISTOGRAM: plot one numeric variable
spotify_data %>%
  ggplot(aes(x = track_popularity)) +
  geom_histogram()

# Plot a couple of histograms with different numeric variable
spotify_data %>%
  ggplot(aes(x = duration_ms)) +
  geom_histogram()

spotify_data %>%
  ggplot(aes(x = speechiness)) +
  geom_histogram()

# SCATTERPLOTS: plot two numeric variables
spotify_data %>%
  ggplot(aes(x = duration_ms,
             y = danceability)) +
  geom_point(alpha = .2)

# what other two numeric variables can you map to x and y to draw a scatterplot?
spotify_data %>%
  ggplot(aes(x = loudness,
             y = speechiness)) +
  geom_point(alpha = .2) +
  geom_smooth()
