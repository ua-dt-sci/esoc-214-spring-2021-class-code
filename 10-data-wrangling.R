# load libraries
library(tidyverse)
library(rvest)
library(janitor)

# read data
presidential_elections_2020 <- read_csv("data/president_county_candidate.csv") %>%
  clean_names()

# create a new collapsed/summarize data frame with total votes
# per candidate
# count the total number of votes each candidate got
# start with presidential_elections_2020 and then group by candidate and 
# summarize the sum of total_votes (3:13pm) add kable() to make your table look nice
# and maybe arrange() to order candidates
total_votes_p_candidate <- presidential_elections_2020 %>%
  group_by(candidate) %>%
  summarize(total = sum(total_votes)) %>%
  arrange(-total)

# write the new dataframe to disk
write_csv(total_votes_p_candidate, "processed_data/votes_per_candidate.csv")

############# SCRAPE WIKIPEDIA FOR ELECTORAL VOTES ############
# get number of electoral votes per state
my_url <- "https://en.wikipedia.org/wiki/United_States_Electoral_College"

my_html <- read_html(my_url)

my_tables <- my_html %>%
  html_nodes(".wikitable")

historic_electoral_votes <- my_tables[[2]] %>%
  html_table(fill = TRUE)

state_elect_votes <- historic_electoral_votes[c(4:54), c(2, 36)]

colnames(state_elect_votes) <- c("state", "electoral_votes")

state_elect_votes <- state_elect_votes %>%
  mutate(state = ifelse(state == "D.C.",
                        "District of Columbia",
                        state))

write_csv(state_elect_votes, "processed_data/electoral_votes.csv")

############## Calculate who won each state ##############
pres_elect_votes <- presidential_elections_2020 %>%
  group_by(state, candidate) %>%
  summarize(vote_count = sum(total_votes)) %>%
  ungroup() %>%
  group_by(state) %>%
  top_n(1) %>%
  select(-vote_count) %>%
  left_join(state_elect_votes)

write_csv(pres_elect_votes, "processed_data/pres_elect_votes.csv")



