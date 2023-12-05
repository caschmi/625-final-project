# Data is exported from the CDC. In order to extract the amount we were interested in,
# requests had to be split up by race since the CDC limits that number of data points
# that can be extracted at a single time.
#
# Data was obtained from:
#
# https://www.cdc.gov/nchs/fastats/alcohol.htm

### Merging datasets ###

deathData_AmInd = read.delim("Underlying Cause of Death, 2018-2021, American Indian.txt")
deathData_Asian = read.delim("Underlying Cause of Death, 2018-2021, Asian.txt")
deathData_Black = read.delim("Underlying Cause of Death, 2018-2021, Black.txt")
deathData_Hawaiian = read.delim("Underlying Cause of Death, 2018-2021, Native Hawaiian.txt")
deathData_MTOR = read.delim("Underlying Cause of Death, 2018-2021, More than One Race.txt")
deathData_White = read.delim("Underlying Cause of Death, 2018-2021, White.txt")

data = list(deathData_AmInd, deathData_Asian, deathData_Black, deathData_Hawaiian, deathData_MTOR, deathData_White)
data = Reduce(function(x, y) merge(x, y, all=TRUE), data)



# write.csv(data, "substanceDeathData.csv", row.names = FALSE)

# population counts per group (i.e like death per 100,000 population)
# use this to standardize:
# https://www.census.gov/data/tables/time-series/demo/popest/2020s-national-detail.html
# and click first file under "Median Age..."
# I think we can use this census data to approximate the crude and age-adjusted rates



# treat age as categorical (5 year segments ) because age as a continous variable has the implicit assumption that drug related deaths
# changes linearly with age, which we can see is not true
library(knitr)
png()
knitr::kable(sample_n(fivedata, 10))
dev.off()
