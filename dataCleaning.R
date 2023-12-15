# Data cleaning to:
#
# a) Combine CDC data age groups to match the census data
#    Census merge is done in "censusData.Rmd"
#


library(ggplot2)
library(naniar)
library(lubridate)
library(dplyr)
library(data.table)

fiveData = read.csv("fiveYearData.csv")
fiveData1 = fiveData[-c(1,2,4,6,7,10,12,14,15)]

fiveData1 = transform(
  fiveData1, Age.Groups = ifelse(fiveData$Five.Year.Age.Groups == "< 1 year" | fiveData$Five.Year.Age.Groups == "1-4 years", "Under 5 years", fiveData$Five.Year.Age.Groups))

#MERGING PEOPLE ABOVE 85 "85 years and over"

fiveData1 = transform(
  fiveData1, Age.Groups = ifelse(fiveData1$Five.Year.Age.Groups == "85-89 years" | fiveData1$Five.Year.Age.Groups == "90-94 years"| fiveData1$Five.Year.Age.Groups == "95-99 years"| fiveData1$Five.Year.Age.Groups == "100+ years", "85 years and over", fiveData1$Age.Groups))

#combining data for below 5 and above 85

dataMergedAge = as.data.table(fiveData1)[, sum(Deaths), by = .(Single.Race.6, Gender.Code, Drug.Alcohol.Induced, Month, Age.Groups)]
colnames(dataMergedAge)[6] = "Deaths"

# write.csv(data.merged.age, "MergedData.csv")

# NA's and death counts under 9 are automatically excluded from the dataset.
# CDC also says we are not allowed to report any death counts under 9.


