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
