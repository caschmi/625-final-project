library(shiny)
library(ggplot2)

data = read.csv("cleanedSubstanceData.csv")

# Test ggplot to play around with formatting of the shiny app (What do we want to show)
ggplot(data = data %>%
         filter(Single.Race.6 == "White")) +
  aes(x = months.numeric, y = Deaths) +
  geom_smooth(method = "lm") +
  theme_bw() +
  aes(color = Drug.Alcohol.Induced)

sum(data[(data$months.numeric > 36) & (data$Drug.Alcohol.Induced == "Drug-induced causes"), ]$Deaths)

data$Deaths[data$months.numeric > 36, ]

