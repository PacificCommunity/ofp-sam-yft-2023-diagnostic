## Extract results of interest, write TAF output tables

## Before: 11.par, catch.rep, length.fit, plot-11.par.rep, test_plot_output,
##         weight.fit (model)
## After:  11.par, catch.rep, length.fit, plot-11.par.rep, test_plot_output,
##         weight.fit (output)

library(TAF)
taf.library(FLCore)
taf.library(FLR4MFCL)
library(tools)  # toTitleCase

mkdir("output")

# Read model output
cat("Reading model estimates ... ")
rep <- read.MFCLRep(finalRep("model"))
cat("done\nReading parameters ... ")
par <- read.MFCLPar(finalPar("model"), first.yr=range(rep)[["minyear"]])
cat("done\nReading catches ...\n")
catches <- read.MFCLCatch("model/catch.rep", dimensions(par), range(par))
cat("done\nReading length fits ... ")
lenfit <- read.MFCLLenFit("model/length.fit")
cat("done\nReading likelihoods ... ")
like <- read.MFCLLikelihood("model/test_plot_output")
cat("done\nReading weight fits ... ")
wgtfit <- read.MFCLWgtFit("model/weight.fit")
cat("done\n")

# Calculate likelihoods and npar
likelihoods <- summary(like)
likelihoods <- as.data.frame(as.list(likelihoods$likelihood))
names(likelihoods) <- summary(like)$component
likelihoods$bhsteep <- likelihoods$effort_dev <- NULL
likelihoods$catchability_dev <- likelihoods$total <- NULL
likelihoods$penalties <- obj_fun(par) - sum(likelihoods)
names(likelihoods) <- toTitleCase(names(likelihoods))

# Calculate model stats
npar <- n_pars(par)
objfun <- obj_fun(par)
gradient <- max_grad(par)
start <- format(file.mtime("model/00.par"))
hours <- file.mtime(finalPar("model")) - file.mtime("model/00.par")
hours <- hours[[1]]
stats <- list(npar=npar, objfun=objfun, gradient=gradient, start=start,
              hours=hours)

# Calculate catches
catch <- as.data.frame(total_catch(catches))
catch$age <- catch$unit <- catch$area <- catch$iter <- NULL
