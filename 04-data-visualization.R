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

# mutate year so it is a number
my_two_favorite_bands <- my_two_favorite_bands %>%
  mutate(year = as.numeric(year))

# Question: has duration changed for these two bands over time?
my_two_favorite_bands %>%
  ggplot(aes(x = year,
             y = duration_ms,
             color = track_artist,
             label = track_name,
             size = track_popularity)) + 
  geom_point(alpha = .5) +
  labs(x = "year song was released",
       y = "song duration in miliseconds",
       color = "Band",
       title = "Song duration across years",
       subtitle = "Displaying songs by Queen and The Beatles",
       caption = "Data from spotify") +
  geom_text() +
  scale_x_continuous(breaks = c(1965, 1975, 1985, 1995, 2005, 2015, 2020))

################### March 4 2021 #####################
# filter by partial match -- contains a string
the_bands_data <- spotify_data %>%
  filter(grepl("the\\s", track_artist, ignore.case = TRUE))

the_bands_data %>%
  count(track_artist)

####### sumarization + plotting #####
# What is the mean popularity of my two favorite bands across decades (release)
# start with my two favorite bands dataframe
# group by decade, track artist and then
# summarize mean of track popularity
# plot a line plot
my_two_favorite_bands %>%
  group_by(decade, track_artist) %>%
  summarize(mean_popularity = mean(track_popularity)) %>%
  ggplot(aes(x = decade,
             y = mean_popularity,
             color = track_artist,
             group = track_artist)) +
  geom_point() +
  geom_line()

# plot a bar plot
my_two_favorite_bands %>%
  group_by(decade, track_artist) %>%
  summarize(mean_popularity = mean(track_popularity)) %>%
  ggplot(aes(x = decade,
             y = mean_popularity,
             fill = track_artist)) +
  geom_col(position = "dodge") +
  facet_wrap(~track_artist)

########### Filter the Data to keep only songs by Drake ######
# create a new dataframe with track_artist equals Drake
drake_songs <- spotify_data %>%
  filter(track_artist == "Drake")

library(ggthemes)
# What is the mean popularity of different albums by Drake
drake_songs %>%
  group_by(track_album_name) %>%
  summarize(song_count = n(),
            mean_popularity = mean(track_popularity)) %>%
  ggplot(aes(y = reorder(track_album_name, mean_popularity),
             x = mean_popularity,
             label = song_count,
             fill = track_album_name)) +
  geom_col() +
  geom_label() +
  labs(y = "",
       x = "Mean Album Popularity",
       title = "Mean popularity of Drake Albums") +
  theme(legend.position = "none")



my_two_favorite_bands %>%
  group_by(decade, track_artist) %>%
  summarize(mean_popularity = mean(track_popularity)) %>%
  ggplot(aes(x = decade,
             y = mean_popularity,
             fill = decade)) +
  geom_col(position = "dodge") +
  facet_wrap(~track_artist) +
  scale_fill_brewer() +
  theme_linedraw()



my_two_favorite_bands %>% 
  group_by(decade, track_artist) %>% 
  summarize(mean_popularity = mean(track_popularity)) %>% 
  ggplot(aes(x = decade,
             y = mean_popularity,
             fill = track_artist)) +
  geom_col(position = position_dodge(preserve = 'single')) +
  scale_fill_colorblind() +
  theme_linedraw()


