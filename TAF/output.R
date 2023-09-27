## Extract results of interest, write TAF output tables

## Before: 11.par, catch.rep, length.fit, plot-11.par.rep, test_plot_output,
##         weight.fit (model), fisheries.csv (data)
## After:

library(TAF)
taf.library(FLR4MFCL)
source("utilities.R")  # reading

mkdir("output")

# Read MFCL output files
rep <- reading("model estimates", read.MFCLRep(finalRep("model")))
par <- reading("parameters", read.MFCLPar(finalPar("model"),
                                          first.yr=range(rep)[["minyear"]]))
catches <- reading("catches", read.MFCLCatch("model/catch.rep",
                                             dimensions(par), range(par)))
lenfit <- reading("length fits", read.MFCLLenFit("model/length.fit"))
like <- reading("likelihoods", read.MFCLLikelihood("model/test_plot_output"))
wgtfit <- reading("weight fits", read.MFCLWgtFit("model/weight.fit"))

# Read fisheries description
fisheries <- read.taf("data/fisheries.csv")

# Likelihoods
likelihoods <- summary(like)
likelihoods <- as.data.frame(as.list(likelihoods$likelihood))
names(likelihoods) <- summary(like)$component
likelihoods$bhsteep <- likelihoods$effort_dev <- NULL
likelihoods$catchability_dev <- likelihoods$total <- NULL
likelihoods$penalties <- obj_fun(par) - sum(likelihoods)

# Model stats
npar <- n_pars(par)
objfun <- obj_fun(par)
gradient <- max_grad(par)
start <- file.mtime("model/00.par")
hours <- file.mtime(finalPar("model")) - file.mtime("model/00.par")
hours <- hours[[1]]
stats <- data.frame(npar, objfun, gradient, start, hours)

# Catches
catch <- as.data.frame(fishery_catch(catches))
catch$age <- catch$iter <- NULL
names(catch)[names(catch) == "unit"] <- "fishery"
names(catch)[names(catch) == "data"] <- "catch"
catch$area <- fisheries$area[catch$fishery]

# Length comps
length.comps <- lenfits(lenfit)
length.comps$season <- (1 + length.comps$month) / 3
length.comps$area <- fisheries$area[length.comps$fishery]
names(length.comps)[names(length.comps) == "sample_size"] <- "ess"
length.comps <- length.comps[c("year", "season", "fishery", "area",
                               "ess", "length", "obs", "pred")]

# Weight comps
weight.comps <- wgtfits(wgtfit)
weight.comps$season <- (1 + weight.comps$month) / 3
weight.comps$area <- fisheries$area[weight.comps$fishery]
names(weight.comps)[names(weight.comps) == "sample_size"] <- "ess"
weight.comps <- weight.comps[c("year", "season", "fishery", "area",
                               "ess", "weight", "obs", "pred")]

# Biology
laa <- as.data.frame(mean_laa(rep))
names(laa)[names(laa) == "data"] <- "length"
waa <- as.data.frame(mean_waa(rep))
names(waa)[names(waa) == "data"] <- "weight"
biology <- cbind(laa, waa["weight"])
biology$year <- biology$unit <- biology$area <- biology$iter <- NULL
biology$age <- biology$age * 4 + as.integer(biology$season)
biology$season <- NULL
biology <- biology[order(biology$age),]
biology$maturity <- mat(par)
biology$natmort <- m_at_age(rep)
rownames(biology) <- NULL
