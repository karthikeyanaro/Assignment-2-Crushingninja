# Overview ----------------------------------------------------------------

# Assignment 2: U.S. COVID Trends
# For each question/prompt, write the necessary code to calculate the answer.
# For grading, it's important that you store your answers in the variable names
# listed with each question in `backtics`. Please make sure to store the
# appropriate variable type (e.g., a string, a vector, a dataframe, etc.)
# For each prompt marked `Reflection`, please write a response
# in your `README.md` file.



# Loading data ------------------------------------------------------------

# You'll load data at the national, state, and county level. As you move through
# the assignment, you'll need to consider the appropriate data to answer
# each question (though feel free to ask if it's unclear!)

# Load the tidyverse package

install.packages("tidyverse")
library("tidyverse")


# Load the *national level* data into a variable. `national`
# (hint: you'll need to get the "raw" URL from the NYT GitHub page)

national <- read.csv("https://github.com/nytimes/covid-19-data/blob/master/us.csv")


# Load the *state level* data into a variable. `states`

states <- read.csv("https://github.com/nytimes/covid-19-data/blob/master/us-states.csv")


# Load the *county level* data into a variable. `counties`
# (this is a large dataset, which may take ~30 seconds to load)

county <- read.csv("https://github.com/nytimes/covid-19-data/blob/master/us-counties.csv")


# How many observations (rows) are in each dataset?

observations <- nrow(data) = 517L

# Create `obs_national`, `obs_states`, `obs_counties`

obs_national <- nrow(national)
obs_states <- nrow(states)
obs_counties <- nrow(counties)

# Reflection: What does each row represent in each dataset?

The rows for the national, states, and counties represent the # of cases and deaths
for the each  jurisdiction respectively

# How many features (columns) are there in each dataset?

features <- ncol(data) = 1L

# Create `num_features_national`, `num_features_states`, `num_features_counties`

num_features_national <- ncol(national)
num_features_states <- ncol(states)
num_features_counties <- ncol(counties)

# Exploratory analysis ----------------------------------------------------

# For this section, you should explore the dataset by answering the following
# questions. HINT: Remeber that in class, we talked about how you can answer 
# most data analytics questions by selecting specific columns and rows. 
# For this assignemnt, you are welcome to use either base R dataframe indexing or
# use functions from the DPLYR package (e.g., using `pull()`). Regardless, you 
# must return the specific column being asked about. For example, if you are 
# asked the *county* with the highest number of deaths, your answer should
# be a single value (the name of the county: *not* an entire row of data).
# (again, make sure to read the documentation to understand the meaning of
# each row -- it isn't immediately apparent!)

# How many total cases have there been in the U.S. by the most recent date
# in the dataset? `total_us_cases`

most_recent <- max(national$date)
total_us_cases <- national[national$date == most_recent, 2]


# How many total deaths have there been in the U.S. by the most recent date
# in the dataset? `total_us_deaths`

total_us_deaths <- national[national$date == most_recent, 3]

# Which state has had the highest number of cases?
# `state_highest_cases`
highest_cases <- max(states$cases)
state_highest_cases <- states[states$cases == highest_cases, 2]


# What is the highest number of cases in a state?
# `num_highest_state`

num_highest_state <- highest_casesg

# Which state has the highest ratio of deaths to cases (deaths/cases), as of the
# most recent date? `state_highest_ratio`
# (hint: you may need to create a new column in order to do this!)

states$ratio <- states$deaths / states$cases
recent_dates_states <- max(states$date)
recent_states <- states[states$date == recent_dates_states, ]
recent_states
highest_ratio <- max(recent_states$ratio)
state_highest_ratio <- recent_states[recent_states$ratio == highest_ratio, 2]


# Which state has had the lowest number of cases *as of the most recent date*?
# (hint, this is a little trickier to calculate than the maximum because
# of the meaning of the row). `state_lowest_cases`

state_lowest_cases <- recent_states[recent_states$ratio == min(recent_states$ratio), 2]


# Reflection: What did you learn about the dataset when you calculated
# the state with the lowest cases (and what does that tell you about
# testing your assumptions in a dataset)?

# Which county has had the highest number of cases?
# `county_highest_cases`

county_highest_cases <- counties[counties$date == max(counties$date), 2]


# What is the highest number of cases that have happened in a single county?
# `num_highest_cases_county`

num_highest_cases_county <- max(counties$cases)


# Because there are multiple counties with the same name across states, it
# will be helpful to have a column that stores the county and state together
# (in the form "COUNTY, STATE").
# Add a new column to your `counties` data frame called `location`
# that stores the county and state (separated by a comma and space).
# You can do this by mutating a new column, or using the `unite()` function
# (just make sure to keep the original columns as well)

counties <- unite(counties, "location", county:state, sep = ", " , na.rm = TRUE, remove = FALSE)


# What is the name of the location (county, state) with the highest number
# of deaths? `location_most_deaths`

location_most_deaths <- counties[counties$deaths == max(counties$deaths), 3]


# Reflection: Is the location with the highest number of cases the location with
# the most deaths? If not, why do you believe that may be the case?


# At this point, you (hopefully) have realized that the `cases` column *is not*
# the number of _new_ cases in a day (if not, you may need to revisit your work)
# Add (mutate) a new column on your `national` data frame called `new_cases`
# that has the nubmer of *new* cases each day (hint: look for the `lag`
# function).

national$new_cases <- national$cases - lag(national$cases, 1)


# Similarly, the `deaths` columns *is not* the number of new deaths per day.
# Add (mutate) a new column on your `national` data frame called `new_deaths`
# that has the nubmer of *new* deaths each day

national$new_deaths <- national$deaths - lag(national$deaths, 1)


# What was the date when the most new cases occured?
# `date_most_cases`

date_most_cases <- national[national$new_cases == max(national$new_cases, na.rm = TRUE), 1][2]


# What was the date when the most new deaths occured?
# `date_most_deaths`

date_most_deaths <- national[national$new_deaths == max(national$new_deaths, na.rm = TRUE), 1][2]

# How many people died on the date when the most deaths occured? `most_deaths`

most_deaths <- national[national$date == date_most_cases, 4]


# Grouped analysis --------------------------------------------------------

# An incredible power of R is to perform the same computation *simultaneously*
# across groups of rows. The following questions rely on that capability.

# What is the county with the *current* (e.g., on the most recent date)
# highest number of cases in each state? Your answer, stored in
# `highest_in_each_state`, should be a *vector* of
# `location` names (the column with COUNTY, STATE).
# Hint: be careful about the order of filtering your data!

highest_in_each_state <- counties %>%
  group_by(state)%>%
  filter(date == max(date),
         cases == max(cases))%>%
  pull(location)


# What is the county with the *current* (e.g., on the most recent date)
# lowest number of deaths in each state? Your answer, stored in
# `lowest_in_each_state`, should be a *vector* of
# `location` names (the column with COUNTY, STATE).
lowest_in_each_state <- counties %>%
  group_by(state)%>%
  filter(date == max(date),
         cases == min(cases))%>%
  pull(location)


# Reflection: Why are there so many observations (counties) in the variable
# `lowest_in_each_state` (i.e., wouldn't you expect the number to be ~50)?


# The following is a check on our understanding of the data.
# Presumably, if we add up all of the cases on each day in the
# `states` or `counties` dataset, they should add up to the number at the
# `national` level. So, let's check.

# First, let's create `state_by_day` by adding up the cases on each day in the
# `states` dataframe. For clarity, let's call the column with the total cases
# `state_total`
# This will be a dataframe with the columns `date` and `state_total`.

state_by_day <- states %>% group_by(date) %>%
  summarise(state_total = sum(cases))


# Next, let's create `county_by_day` by adding up the cases on each day in the
# `counties` dataframe. For clarity, let's call the column with the total cases
# `county_total`
# This will also be a dataframe, with the columns `date` and `county_total`.
county_by_day <- counties %>% group_by(date) %>%
  summarise(county_total = sum(cases))

# Now, there are a few ways to check if they are always equal. To start,
# let's *join* those two dataframes into one called `totals_by_day`
totals_by_day <> merge(county_by_day, state_by_day, by-"date")


# Next, let's create a variable `all_totals` by joining `totals_by_day`
# to the `national` dataframe
all_totals <> left_join(national, totals_by_day, by-"date")


# How many rows are there where the state total *doesn't equal* the natinal
# cases reported? `num_state_diff`
num_state_diff <- all_totals %>%
  filter(state_total != cases) %>%
  nrow()



# How many rows are there where the county total *doesn't equal* the natinal
# cases reported? `num_county_diff`
num_county_diff <- all_totals %>%
  filter(county_total != cases) %>%
  nrow()


# Oh no! An inconsistency -- let's dig further into this. Let's see if we can
# find out *where* this inconsistency lies. Let's take the county level data,
# and add up all of the cases to the state level on each day (e.g.,
# aggregating to the state level). Store this dataframe with three columns
# (state, date, county_totals) in the variable `sum_county_to_state`.
# (To avoid DPLYR automatically grouping your results,
# specify `.groups = "drop"` in your `summarize()` statement. This is a bit of
# an odd behavior....)
sum_county_to_state <- counties %>%
  group_by(state, date) %>%
  summarise(county_total = sum(cases), groups = "drop")


# Then, let's join together the `sum_county_to_state` dataframe with the
# `states` dataframe into the variable `joined_states`.
sum_state <- states[c(1, 2, 9)]
sum_state


# To find out where (and when) there is a discrepancy in the number of cases,
# create the variable `has_discrepancy`, which has *only* the observations
# where the sum of the county cases in each state and the state values are
# different. This will be a *dataframe*.
has_discrepancy <- joined_states %>%
  filter(county_total != (cases))


# Next, lets find the *state* where there is the *highest absolute difference*
# between the sum of the county cases and the reported state cases.
# `state_highest_difference`.
# (hint: you may want to create a new column in `has_discrepancy` to do this.)
state_highest_difference <- has_discrepancy %>%
  mutate(difference_total = abs(county_total - cases)) %>%
  filter(difference_total == max(difference_total))%>%
  pull(state)


# Independent exploration -------------------------------------------------

# Ask your own 3 questions: in the section below, pose 3 questions,
# then use the appropriate code to answer them.

# Reflection: What surprised you the most throughout your analysis?
