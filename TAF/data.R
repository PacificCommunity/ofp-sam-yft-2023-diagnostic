## Preprocess data, write TAF data tables

## Before: fdesc.txt, yft.age_length, yft.frq, yft.tag (boot/data),
##         length.fit (boot/model_results)
## After:  cpue.csv, fisheries.csv, length_comps.csv, otoliths.csv,
##         weight_comps.csv (data)

library(TAF)
taf.library(FLCore)
taf.library(FLR4MFCL)
library(tools)  # toTitleCase

mkdir("data")

# Read data
cat("Processing otolith data ... ")
oto <- suppressWarnings(read.MFCLALK("boot/data/yft.age_length",
                                     "boot/data/model_results/length.fit"))
cat("done\nProcessing catch data ... ")
frq <- read.MFCLFrq("boot/data/yft.frq")
cat("done\nProcessing fisheries description ...")
fisheries <- read.table("boot/data/fdesc.txt", fill=TRUE, header=TRUE)
cat("done\n")

# Format fisheries description
names(fisheries) <- toTitleCase(names(fisheries))

# Format otolith data
otoliths <- ALK(oto)
otoliths <- otoliths[otoliths$obs > 0,]
otoliths <- otoliths[rep(seq_len(nrow(otoliths)), otoliths$obs),]
otoliths$obs <- otoliths$species <- NULL
otoliths$region <- fisheries$Region[otoliths$fishery]
otoliths <- otoliths[c("year", "month", "region", "age", "length")]
rownames(otoliths) <- NULL
names(otoliths) <- toTitleCase(names(otoliths))

# Format CPUE data
cpue <- realisations(frq)
cpue <- cpue[cpue$fishery %in% 33:37,]  # index fisheries
cpue$index <- cpue$catch / cpue$effort / 1e6
cpue$region <- cpue$fishery - 32
cpue$fishery <- cpue$catch <- cpue$effort <- cpue$week <- cpue$penalty <- NULL
cpue <- cpue[c("year", "month", "region", "index")]
rownames(cpue) <- NULL
names(cpue) <- toTitleCase(names(cpue))

# Format size data
size <- freq(frq)
size$week <- size$penalty <- size$catch <- size$effort <- NULL
size <- size[size$freq != -1,]
length.comps <- size[!is.na(size$length),]
weight.comps <- size[!is.na(size$weight),]
length.comps$weight <- weight.comps$length <- NULL
row.names(length.comps) <- row.names(weight.comps) <- NULL
names(length.comps) <- toTitleCase(names(length.comps))
names(weight.comps) <- toTitleCase(names(weight.comps))

# Write TAF tables
write.taf(fisheries, dir="data")
write.taf(otoliths, dir="data")
write.taf(cpue, dir="data")
write.taf(length.comps, dir="data")
write.taf(weight.comps, dir="data")
