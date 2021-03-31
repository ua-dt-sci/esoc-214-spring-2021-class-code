# load libraries
library(tidyverse)
library(usmap)
#install.packages("usmap")

# read data in
beer_awards <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-10-20/beer_awards.csv")

# inspect statepop data
statepop

# add statepop to beer_awards
beer_awards <- left_join(beer_awards,
                         statepop,
                         by = c("state" = "abbr"))
