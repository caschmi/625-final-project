# 625-final-project

Overleaf File for Project Proposal: https://www.overleaf.com/1171322613hnwwrxkxddzw#3ab6ad 

Adjustment to the dataset: 
We have data on the count of number of deaths for individuals, stratafied by: 

1) Month of death
2) Race
3) Age (continuous)
4) Gender
5) Cause of death

To estimate the mortality rate (Poisson regression), take (#Deaths / Total in Population) -- not available in CDC data. It _is_ available in yearly Census data, but in five-year age groups (i.e. <5, 5-9, 10-14, ..., >85), and not broken down by month. If we make the asusmption of a stable population throughout a year, we can assume that the total population during any given month throughout the year is equal (or close to equal) to the estimated total population. Total population then can be used as the offset. 

Also, CDC can export data in 5 year age groups, but they do not group it in the same way as the Census, so we need to combine the CDC data to match the Census to make valid comparisons. 

Census data can be found here: https://www.census.gov/data/tables/time-series/demo/popest/2020s-national-detail.html

<img width="639" alt="censusDataLocation" src="https://github.com/caschmi/625-final-project/assets/148912328/3361e4a0-da8a-4187-ad73-73e27edd5398">

Link to the report: 

https://www.overleaf.com/1232859622dxpkfbcshwch#120396
