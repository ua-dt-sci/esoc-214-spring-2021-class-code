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
  
ua_wiki_tables[1] %>%
  html_table()

ua_wiki_tables[2] %>%
  html_table()

ua_wiki_tables[3] %>%
  html_table()
