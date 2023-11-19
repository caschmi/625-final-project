#who_suicide_statistics = read_csv("who_suicide_statistics.csv")
#who_complete = na.omit(who_suicide_statistics)
# Merging datasets
library(tidyverse)

### Data is exported from the
deathData_AmInd = read.delim("Underlying Cause of Death, 2018-2021, American Indian.txt")
deathData_Asian = read.delim("Underlying Cause of Death, 2018-2021, Asian.txt")
deathData_Black = read.delim("Underlying Cause of Death, 2018-2021, Black.txt")
deathData_Hawaiian = read.delim("Underlying Cause of Death, 2018-2021, Native Hawaiian.txt")
deathData_MTOR = read.delim("Underlying Cause of Death, 2018-2021, More than One Race.txt")
deathData_White = read.delim("Underlying Cause of Death, 2018-2021, White.txt")

data = list(deathData_AmInd, deathData_Asian, deathData_Black, deathData_Hawaiian, deathData_MTOR, deathData_White)
data = Reduce(function(x, y) merge(x, y, all=TRUE), data)

write.csv(data, "/Users/caseyschmidt/Documents/Grad School /fall 23/625/625-final-project/substanceDeathData", row.names = FALSE)
