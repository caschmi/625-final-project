# Data cleaning to:
#
# a) handle missing data
# b) change months into useable format
#
#

library(ggplot2)
library(naniar)
library(lubridate)
library(dplyr)

data = read.csv("substanceDeathData.csv")

gg_miss_var(data)

sum(is.na(data$Deaths)) # Missing 7854 values from data and single year age codes.

# View(data[is.na(data$Deaths) | is.na(data$Single.Year.Ages.Code), ])

# Looking at the data for where these missing values are present, all remaining columns
# are empty (there's no data present at all for these NA values)
# Remove from the data set.

dataNoNA = na.omit(data)


# Convert ages and dates into numeric
# Dates converted to "number of months after Jan. 2018, which is the first month in the data set.

attach(dataNoNA)

dataNoNA$ages = as.numeric(Single.Year.Ages.Code) # NA's induced because "NS" exists in data (NS = Not stated)


dates = lubridate::dmy(paste0("01 ", Month))

yearsData = lubridate::year(dates) - 2017 # subtract 2017 to adjust for first year being 2018
monthsData = lubridate::month(dates) # Extract month in number

dataNoNA$months.numeric = yearsData * monthsData # Multiply together to get # months passed

detach(dataNoNA)

dataNEW = na.omit(dataNoNA)

# population counts per group (i.e like death per 100,000 population)
# use this to standardize:
# https://www.census.gov/data/tables/time-series/demo/popest/2020s-national-detail.html
# and click first file under "Median Age..."
# I think we can use this census data to approximate the crude and age-adjusted rates



# treat age as categorical (5 year segments ) because age as a continous variable has the implicit assumption that drug related deaths
# changes linearly with age, which we can see is not true


# Start the seq() argument at -1, and increment by five so the age groups are appropriately ordered.
#
dataNEW$ageGroup = cut(dataNEW$ages,
                       breaks = c(seq(-1, 85, by = 5), Inf),
                       include.lowest = TRUE,
                       labels = c("<5", "5-9", "10-14", "15-19", "20-24",
                                  "25-29", "30-34", "35-39", "40-44", "45-49",
                                  "50-54", "55-59", "60-64", "65-69", "70-74",
                                  "75-79", "80-84", ">85"))
# Group in this way to match census data



library(tidyr)
result = dataNEW %>%
  group_by(Gender, Single.Race.6, months.numeric, Drug.Alcohol.Induced, ageGroup) %>%
  summarize(total_deaths = sum(Deaths)) %>%
  ungroup()

# Something looks wrong with this result. I think that there are missing age groups

# write.csv(dataNoNA, "cleanedSubstanceData.csv")

library(data.table)
fivedata <- read.csv("fiveYearData.csv")
fivedata1 <- fivedata[-c(1,2,4,6,7,10,12,14,15)]

fivedata1 <- transform(
  fivedata1, Age.Groups = ifelse(fivedata$Five.Year.Age.Groups == "< 1 year" | fivedata$Five.Year.Age.Groups == "1-4 years", "Under 5 years", fivedata$Five.Year.Age.Groups))

data.merged.age <- as.data.table(fivedata1)[, sum(Deaths), by = .(Single.Race.6, Gender.Code, Drug.Alcohol.Induced, Month, Age.Groups)]








