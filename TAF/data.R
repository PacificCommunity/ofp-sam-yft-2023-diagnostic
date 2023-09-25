## Preprocess data, write TAF data tables

## Before: yft.age_length, yft.frq, yft.tag (boot/data),
##         length.fit (boot/length_fit)
## After:

library(TAF)
taf.library(FLCore)
taf.library(FLR4MFCL)

mkdir("data")

# Read MFCL data
oto <- suppressWarnings(read.MFCLALK("boot/data/yft.age_length",
                                     "boot/data/length_fit/length.fit"))
frq <- read.MFCLFrq("boot/data/yft.frq")

# Format otolith data
oto <- ALK(oto)
oto <- oto[oto$obs > 0,]
oto <- oto[rep(seq_len(nrow(oto)), oto$obs),]
oto$obs <- oto$species <- NULL
rownames(oto) <- NULL

# Format CPUE data
cpue <- realisations(frq)
cpue <- cpue[cpue$effort > 0,]
cpue$week <- cpue$penalty <- NULL
rownames(cpue) <- NULL
cpue$index <- cpue$catch / cpue$effort
