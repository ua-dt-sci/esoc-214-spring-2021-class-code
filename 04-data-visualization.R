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

########################### MARCH 2 2021 #######################
# to plot a pie chart we need a variable that sums to 100
spotify_data %>%
  count(playlist_genre) %>%
  mutate(total = sum(n),
         percentage = n/total) %>%
  ggplot(aes(x = playlist_genre,
             y = percentage)) +
  geom_col()

spotify_data %>%
  count(playlist_genre) %>%
  mutate(total = sum(n),
         percentage = n/total) %>%
  ggplot(aes(x = "",
             fill = playlist_genre,
             y = percentage)) +
  geom_col() +
  coord_polar("y", start = 0)

# geom_bar() vs. geom_col()
# geom_bar() map only one axis the other is calculated for you (count)
spotify_data %>%
  ggplot(aes(x = playlist_genre)) +
  geom_bar()

spotify_data %>%
  count(playlist_genre)

# geom_col() map both variables
spotify_data %>%
  count(playlist_genre) %>%
  ggplot(aes(x = playlist_genre,
             y = n)) +
  geom_col()

################# ARTISTS #####################
# count how many songs we have per artist
# arrange so we see the the artists with the most songs at the top of the output
spotify_data %>%
  count(track_artist, sort = TRUE)

spotify_data %>%
  count(track_artist) %>%
  arrange(-n)

# filter our data to keep just some artists
my_two_favorite_bands <- spotify_data %>%
  filter(track_artist == "Queen" | track_artist == "The Beatles")

# check your data
my_two_favorite_bands %>%
  count(track_artist)

# filter our data to keep 5 top artists
top_5_artists <- spotify_data %>%
  filter(track_artist %in% c("Martin Garrix", "Queen", "The Chainsmokers",
                             "David Guetta", "Don Omar"))
top_5_artists %>%
  count(track_artist)

# create new year column in my data
my_two_favorite_bands <- my_two_favorite_bands %>%
  mutate(year = substr(track_album_release_date, 1, 4),
         decade = paste0(substr(track_album_release_date, 1, 3), "0"))

# Question: has duration changed for these two bands over time?
my_two_favorite_bands %>%
  ggplot(aes(x = year,
             y = duration_ms,
             color = track_artist,
             label = track_name)) + 
  geom_point(alpha = .5) +
  geom_text(size = 2)

