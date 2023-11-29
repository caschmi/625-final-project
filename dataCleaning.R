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

write.csv(dataNoNA, "cleanedSubstanceData.csv")
