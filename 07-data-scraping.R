# install packages
#install.packages("rvest")

# load libraries
library(tidyverse)
library(rvest)

# url
ua_wiki_url <- "https://en.wikipedia.org/wiki/University_of_Arizona"

# read html as an object
ua_wiki_html <- read_html(ua_wiki_url)

# look for table nodes
ua_wiki_tables <- ua_wiki_html %>%
  html_nodes(".wikitable")

# what's in the first table?
ua_wiki_tables[1] %>%
  html_table()

# what's in the second table?
ua_wiki_tables[2] %>%
  html_table()

# store third table in an object/dataframe
fall_freshman_stats <- ua_wiki_tables[[3]] %>%
  html_table(fill = TRUE)

# check column names
colnames(fall_freshman_stats)[1] <- "type"

# get only rows with student count as unit
fall_freshman_stats_count <- fall_freshman_stats %>%
  filter(type %in% c("Admits", "Applicants", "Enrolled"))

# slice the dataframe
fall_freshman_stats_count <- fall_freshman_stats %>%
  slice(1, 2, 4)

# pivot the year columns
fall_freshman_tidy <- fall_freshman_stats_count %>%
  pivot_longer(cols = `2017`:`2013`,
               names_to = "year",
               values_to = "student_count")

# transform student_count to an actual numeric variable
fall_freshman_tidy <- fall_freshman_tidy %>%
  mutate(student_count = parse_number(student_count))

# plot student count as number
fall_freshman_tidy %>%
  ggplot(aes(x = year,
             y = student_count,
             color = type,
             group = type)) +
  geom_point() +
  geom_line() +
  theme_linedraw() +
  labs(y = "number of students",
       color = "",
       title = "University of Arizona Undergraduate Numbers",
       caption = "data from wikipedia")



