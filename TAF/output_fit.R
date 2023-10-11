## Extract model fit results, write TAF output tables

## Before: 00.par, 11.par, length.fit, plot-11.par.rep, test_plot_output,
##         weight.fit (model)
## After:  cpue.csv, length.comps.csv, likelihoods.csv, stats.csv,
##         weight.comps.csv (output)

library(TAF)
taf.library(FLR4MFCL)
source("utilities.R")  # reading

mkdir("output")

# Read MFCL output files
par <- reading("parameters", read.MFCLPar(finalPar("model")))
rep <- reading("model estimates", read.MFCLRep(finalRep("model")))
like <- reading("likelihoods", read.MFCLLikelihood("model/test_plot_output"))
lenfit <- reading("length fits", read.MFCLLenFit("model/length.fit"))
wgtfit <- reading("weight fits", read.MFCLWgtFit("model/weight.fit"))

# Model stats
npar <- n_pars(par)
objfun <- obj_fun(par)
gradient <- max_grad(par)
start <- file.mtime("model/00.par")
hours <- file.mtime(finalPar("model")) - file.mtime("model/00.par")
hours <- hours[[1]]
stats <- data.frame(npar, objfun, gradient, start, hours)

# Likelihoods
likelihoods <- summary(like)
likelihoods <- as.data.frame(as.list(likelihoods$likelihood))
names(likelihoods) <- summary(like)$component
likelihoods$bhsteep <- likelihoods$effort_dev <- NULL
likelihoods$catchability_dev <- likelihoods$total <- NULL
likelihoods$penalties <- obj_fun(par) - sum(likelihoods)

# CPUE
obs <- as.data.frame(cpue_obs(rep))
pred <- as.data.frame(cpue_pred(rep))
names(obs)[names(obs) == "data"] <- "obs"
names(pred)[names(pred) == "data"] <- "pred"
cpue <- cbind(obs, pred["pred"])
cpue <- cpue[cpue$unit %in% 33:37,]
cpue$area <- as.integer(cpue$unit) - 32
cpue$obs <- exp(cpue$obs)
cpue$pred <- exp(cpue$pred)
cpue$age <- cpue$unit <- cpue$iter <- NULL

# Length comps
length.comps <- lenfits(lenfit)
length.comps$season <- (1 + length.comps$month) / 3
names(length.comps)[names(length.comps) == "sample_size"] <- "ess"
length.comps <- length.comps[c("year", "season", "fishery", "ess",
                               "length", "obs", "pred")]

# Weight comps
weight.comps <- wgtfits(wgtfit)
weight.comps$season <- (1 + weight.comps$month) / 3
names(weight.comps)[names(weight.comps) == "sample_size"] <- "ess"
weight.comps <- weight.comps[c("year", "season", "fishery", "ess",
                               "weight", "obs", "pred")]

# Write TAF tables
write.taf(cpue, dir="output")
write.taf(length.comps, dir="output")
write.taf(likelihoods, dir="output")
write.taf(stats, dir="output")
write.taf(weight.comps, dir="output")
