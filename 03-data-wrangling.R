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

############### February 16, 2021 #############
glimpse(nfl_salary_data)

# pivot all columns that hold position names
nfl_salary_longer <- nfl_salary_data %>%
  pivot_longer(cols = Cornerback:`Wide Receiver`,
               names_to = "position",
               values_to = "salary") %>%
  filter(!is.na(salary))

nfl_salary_longer %>%
  group_by(position) %>% 
  summarise(mean_salary = mean(salary)) %>%
  arrange(mean_salary)

### mutate ####
nfl_salary_longer <- nfl_salary_longer %>%
  mutate(is_quarterback = (position == "Quarterback"))

nfl_salary_longer %>%
  group_by(is_quarterback) %>%
  summarise(mean_salary = mean(salary))

###### Visualization with ggplot ######
nfl_salary_longer %>%
  ggplot(aes(x = year,
             y = salary,
             color = position))  +
  geom_point()

# group_by %>%  summarize() %>%  ggplot()
nfl_salary_longer %>%
  group_by(year, position) %>%
  summarize(mean_salary = mean(salary)) %>%
  ggplot(aes(x = year,
             y = mean_salary,
             color = position)) +
  geom_point() +
  geom_line()

nfl_salary_longer %>%
  group_by(year, is_quarterback) %>%
  summarize(mean_salary = mean(salary)) %>%
  ggplot(aes(x = year,
             y = mean_salary,
             color = is_quarterback)) +
  geom_point() +
  geom_line()
