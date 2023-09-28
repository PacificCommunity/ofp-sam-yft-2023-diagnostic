## Prepare plots and tables for report

## Before: biology.csv, biomass.csv, catch.csv, cpue.csv, depletion.csv,
##         fatage.csv, length.comps.csv, likelihoods.csv, natage.csv,
##         selectivity.csv, stats.csv, weight.comps.csv (output)
## After:

library(TAF)

mkdir("report")

biology <- read.taf("output/biology.csv")
biology <- rnd(biology, 2:5, c(1,1,3,3))
write.taf(biology, dir="report")

biomass <- read.taf("output/biomass.csv")
