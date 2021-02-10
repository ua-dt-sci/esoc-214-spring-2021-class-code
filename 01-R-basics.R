# this is the first R coding session for ESOC 214
# operations
# to run a line/block ctrl+enter (windows) cmd+enter (mac)
3 + 4
-2 * 3
3 * -2
4 / 2
3 - 2
3 * 2 - 1
3 * (2 - 1)
1 - 3 * 2
3**2
3^2
11 %% 2
11 %/% 2

# boolean operators
3 == 2
3 == 3
3 != 2
2 > 3
2 < 3
2 <= 3

# to run it all you do cmd+option/alt+r
# Create objects
sum_results <- 3 + 4
3 + 11 -> sum_results
print(sum_results)
sum_results

# get class of sum_results
class(sum_results)

this_is_a_character <- "My name is Adriana"
this_is_a_number <- 12
this_is_another_string <- "12"

class(this_is_a_character)
class(this_is_a_number)
class(this_is_another_string)

# operations with objects
daisys_age <- 8
daisys_age * 4

# vectors or arrays
# my_vector = [1, 2, 3]
# create a vector of ages for all of my imaginary pets
my_pets_ages <- c(8, 2, 6, 3, 1)
my_pets_ages[1]
my_pets_ages[4]

my_vector <- c(1:100)
class(my_vector)

# a vector that is supposed to be all numeric but it is not
my_pets_ages <- c(8, 2, "-", 3, 1)
my_pets_ages * 4

# fix the vector
my_pet_ages <- c(8, 2, 6, 3, 1)
class(my_pet_ages)
my_pet_ages * 4

# create an integer object
my_age <- 39L
class(my_age)

################### DATAFRAMES ##################
# first create my pets' ages vector
my_pets_ages <- c(8, 2, 8, 3, 1)
my_pets_names <- c("Daisy", "Violet", "Lily", "Iris", "Poppy")

# create a data frame based on my ages and names vectors
my_pets <- data.frame(name = my_pets_names,
                      age = my_pets_ages)

# pop up the whole data frame on a different tab
View(my_pets)

# count number of rows (observations) and 
# count number of variables (columns)
nrow(my_pets)
ncol(my_pets)

# both rows and cols
dim(my_pets)

# inspect data, summary
summary(my_pets)

####### Slicing your data frame ####
#### use index or number
# retrieve row 1
my_pets[1,]
# retrieve first 1
my_pets[,1]
# retrieve value in the first column and first row
my_pets[1, 1]

#### use the name of the variable (columns)
my_pets[, "age"]
my_pets[, 2]
# negative number means do not include that column
my_pets[, -1]

# retrieve row by name
my_pets["1", ]

# retrieve both a specific value (cell)
my_pets["1", "age"]

# use $ to retrieve variable (column) by name
my_pets[, "age"]
my_pets$age

# retrieve a variable with $ and then index that vector
my_pets$name[2]

# multiply all aged by 4
my_pets$age * 4
my_pets$age == 2

# retrieve info on pets that are 2 years old
my_pets[my_pets$age == 2,]

# Print out a list of pet names that are older than 3
my_pets[my_pets$age > 3, "name"]
my_pets[my_pets$age >3, ]$name

# first number is the row number and
# second number is the column number
my_pets[1,]
my_pets[,1]

######## creating new variable (column) #####
my_pets$human_years <- my_pets$age * 4

######## Use functions on individual columns ####
mean(my_pets$age)

# What other different functions (besides mean) cab you run on 
# data variables (columns)
min(my_pets$age)
max(my_pets$age)
median(my_pets$age)
sum(my_pets$age)
mode(my_pets$age)
class(my_pets$age)
frequency(my_pets$age)
range(my_pets$age)
sd(my_pets$age)

# how do I get mean without using mean() using sum()
sum(my_pets$age) / length(my_pets$age)
sum(my_pets$age) / nrow(my_pets)
mean(my_pets$age)

# try to run mean on name
mean(my_pets$name)

# run mean on a logical variable
my_pets$older_than_three <- my_pets$age > 3
mean(my_pets$older_than_three)

class(my_pets$human_years)
mean(my_pets$human_years)

my_pets$human_years <- as.numeric(my_pets$human_years)

