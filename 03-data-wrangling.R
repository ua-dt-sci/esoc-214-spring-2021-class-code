# install readxl
#install.packages("readxl")

# load library
library(tidyverse)
library(readxl)

# check where data file is
dir("data")

# read data in
nfl_salary_data <- read_excel("data/nfl_salary.xlsx")

# count() -- count observations by a categorical variable
nfl_salary_data %>%
  count(year)

# group_by() + summarize()
nfl_salary_data %>%
  group_by(year) %>%
  summarize(qb_mean_salary = mean(Quarterback, na.rm = TRUE),
            cb_mean_salary = mean(Cornerback, na.rm = TRUE),
            dl_mean_salary = mean(`Defensive Lineman`, na.rm = TRUE))


############## PIVOT LONGER to make the data tidy ########################
nfl_salary_longer <- nfl_salary_data %>%
  pivot_longer(cols = Cornerback:`Wide Receiver`,
               names_to = "position",
               values_to = "salary")


# using this new longer data frame calculate the mean salary for all positions
# per year --- group_by() + summarize()
nfl_salary_longer %>%
  group_by(position, year) %>%
  summarize(mean_salary = mean(salary, na.rm = TRUE)) %>%
  arrange(mean_salary)

# Keep only data that is not missing (remove missing data)
nfl_salary_clean <- nfl_salary_longer %>%
  filter(!is.na(salary))

# count()
nfl_salary_clean %>%
  count(position)

nfl_salary_longer %>%
  count(position)



