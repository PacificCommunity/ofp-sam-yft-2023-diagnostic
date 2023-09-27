## Prepare plots and tables for report

## Before: 11.par, catch.rep, length.fit, plot-11.par.rep, test_plot_output,
##         weight.fit (output)
## After:

library(TAF)
taf.library(FLR4MFCL)

mkdir("report")

# Read model output
cat("Reading parameters ... ")
par <- read.MFCLPar("output/11.par", first.yr=1952)
cat("done\nReading catches ...\n")
catch <- read.MFCLCatch("output/catch.rep", dimensions(par), range(par))
cat("done\nReading length fits ... ")
lenfit <- read.MFCLLenFit("output/length.fit")
cat("done\nReading model estimates ... ")
rep <- read.MFCLRep("output/plot-11.par.rep")
cat("done\nReading likelihoods ... ")
likelihood <- read.MFCLLikelihood("output/test_plot_output")
cat("done\nReading weight fits ... ")
wgtfit <- read.MFCLWgtFit("output/weight.fit")
cat("done\n")
