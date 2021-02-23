# load library
library(tidyverse)


# print current working directory
getwd()

# list contents in data
dir("data")

# read data in
spotify_data <- read_csv("data/spotify_songs.csv")
#spotify_data <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-21/spotify_songs.csv")

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

##### Summarization of the Data -- collapse data points ###
# start with our raw data and then
# group by release_year, playlist_genre, playlist_subgenre and then
# summarize the mean of track_popularity
summarized_popularity <- spotify_data %>%
  group_by(track_album_release_date, playlist_genre, playlist_subgenre) %>%
  summarize(mean_popularity = mean(track_popularity, na.rm = TRUE))

# extra first 4 characters in track_album_release_date[0:3]
substr(summarized_popularity$track_album_release_date, 1, 4)

summarized_popularity <- summarized_popularity %>%
  mutate(year = substr(track_album_release_date, 1, 4)) %>% 
  mutate(year = as.numeric(year))

# scatterplot of new summarized data
summarized_popularity %>%
  ggplot(aes(x = year,
             y = mean_popularity,
             color = playlist_genre)) +
  geom_point(alpha = .5) +
  facet_wrap(~playlist_subgenre)

##### Bar plots ###
# start with raw data (spotify_data) and then
# group by playlist_genre and then
# summarize the mean of popularity
spotify_data %>%
  group_by(playlist_genre) %>%
  summarize(mean_popularity = mean(track_popularity, na.rm = TRUE)) %>%
  ggplot(aes(x = reorder(playlist_genre, -mean_popularity),
             y = mean_popularity,
             fill = playlist_genre)) +
  geom_col()

# add subgenre
spotify_data %>%
  group_by(playlist_genre, playlist_subgenre) %>%
  summarize(mean_popularity = mean(track_popularity, na.rm = TRUE)) %>%
  ggplot(aes(y = reorder(playlist_subgenre, mean_popularity),
             x = mean_popularity,
             fill = playlist_genre)) +
  geom_col()





