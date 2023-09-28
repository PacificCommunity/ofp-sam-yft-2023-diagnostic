## Preprocess data, write TAF data tables

## Before: fdesc.txt, yft.age_length, yft.frq, yft.tag (boot/data),
##         length.fit (boot/model_results)
## After:  cpue.csv, fisheries.csv, length_comps.csv, otoliths.csv,
##         weight_comps.csv (data)

library(TAF)
taf.library(FLR4MFCL)
source("utilities.R")  # reading

mkdir("data")

# Read data
oto <- reading("otolith data",
               read.MFCLALK("boot/data/yft.age_length",
                            "boot/data/model_results/length.fit"))
frq <- reading("catch data", read.MFCLFrq("boot/data/yft.frq"))
fisheries <- reading("fisheries description",
                     read.table("boot/data/fdesc.txt", fill=TRUE, header=TRUE))

# Fisheries description
names(fisheries)[names(fisheries) == "region"] <- "area"

# Otolith data
otoliths <- ALK(oto)
otoliths <- otoliths[otoliths$obs > 0,]
otoliths <- otoliths[rep(seq_len(nrow(otoliths)), otoliths$obs),]
otoliths$season <- (1 + otoliths$month) / 3
otoliths$area <- fisheries$area[otoliths$fishery]
otoliths <- otoliths[c("year", "season", "area", "age", "length")]

# CPUE data
cpue <- realisations(frq)
cpue <- cpue[cpue$fishery %in% 33:37,]  # index fisheries
cpue$season <- (1 + cpue$month) / 3
cpue$area <- cpue$fishery - 32
cpue$index <- cpue$catch / cpue$effort / 1e6
cpue <- cpue[c("year", "season", "area", "index")]

# Size data
size <- freq(frq)
size <- size[size$freq != -1,]

# Length compositions
length.comps <- size[!is.na(size$length),]
length.comps$season <- (1 + length.comps$month) / 3
length.comps <- length.comps[c("year", "season", "fishery", "length", "freq")]
row.names(length.comps) <- NULL

# Weight compositions
weight.comps <- size[!is.na(size$weight),]
weight.comps$season <- (1 + weight.comps$month) / 3
weight.comps <- weight.comps[c("year", "season", "fishery", "weight", "freq")]
row.names(weight.comps) <- NULL

# Write TAF tables
write.taf(fisheries, dir="data")
write.taf(otoliths, dir="data")
write.taf(cpue, dir="data")
write.taf(length.comps, dir="data")
write.taf(weight.comps, dir="data")
