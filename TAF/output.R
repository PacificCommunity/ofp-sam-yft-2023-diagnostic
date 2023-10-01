## Extract results of interest, write TAF output tables

## Before: 00.par, 11.par, catch.rep, length.fit, plot-11.par.rep,
##         test_plot_output, weight.fit (model), fisheries.csv (data)
## After:  biology.csv, biomass.csv, catch.csv, cpue.csv, f_aggregated.csv,
##         f_annual.csv, f_season.csv, f_stage.csv, length.comps.csv,
##         likelihoods.csv, natage.csv, selectivity.csv, stats.csv, summary.csv,
##         weight.comps.csv (output)

library(TAF)
taf.library(FLR4MFCL)
source("utilities.R")  # reading

mkdir("output")

# Read MFCL output files
par <- reading("parameters", read.MFCLPar(finalPar("model")))
rep <- reading("model estimates", read.MFCLRep(finalRep("model")))
catches <- reading("catches", read.MFCLCatch("model/catch.rep",
                                             dimensions(par), range(par)))
lenfit <- reading("length fits", read.MFCLLenFit("model/length.fit"))
like <- reading("likelihoods", read.MFCLLikelihood("model/test_plot_output"))
wgtfit <- reading("weight fits", read.MFCLWgtFit("model/weight.fit"))

# Read fisheries description
fisheries <- reading("fisheries description", read.taf("data/fisheries.csv"))

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

# Catch
catch <- as.data.frame(fishery_catch(catches))
catch$age <- catch$iter <- NULL
names(catch)[names(catch) == "unit"] <- "fishery"
names(catch)[names(catch) == "data"] <- "t"
catch$area <- fisheries$area[catch$fishery]
catch <- catch[c("year", "season", "fishery", "area", "t")]

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

# Selectivity
selectivity <- as.data.frame(sel(rep))
names(selectivity)[names(selectivity) == "unit"] <- "fishery"
names(selectivity)[names(selectivity) == "data"] <- "sel"
selectivity <- selectivity[c("fishery", "age", "sel")]

# Fishing mortality: season
f.season.all <- as.data.frame(fm_aggregated(rep))
f.season.reg <- as.data.frame(fm(rep))
f.season <- rbind(f.season.reg, f.season.all)
names(f.season)[names(f.season) == "data"] <- "f"
f.season$unit <- f.season$iter <- NULL

# Fishing mortality: annual
f.annual.all <- as.data.frame(seasonSums(fm_aggregated(rep)))
f.annual.reg <- as.data.frame(seasonSums(fm(rep)))
f.annual <- rbind(f.annual.reg, f.annual.all)
names(f.annual)[names(f.annual) == "data"] <- "f"
f.annual$unit <- f.annual$season <- f.annual$iter <- NULL

# Fishing mortality: adult and juvenile
p.adult <- mat(par)
p.juven <-  1- p.adult
f.adult <- aggregate(f~year+area, f.annual, weighted.mean, w=p.adult)
f.juven <- aggregate(f~year+area, f.annual, weighted.mean, w=p.juven)
f.adult$stage <- "adult"
f.juven$stage <- "juvenile"
f.stage <- rbind(f.adult, f.juven)[c("year", "area", "stage", "f")]

# Fishing mortality: aggregate
f.aggregate <- as.data.frame(AggregateF(rep))
names(f.aggregate)[names(f.aggregate) == "data"] <- "f"
f.aggregate <- f.aggregate[c("year", "season", "f")]

# Numbers at age
natage <- as.data.frame(popN(rep))
natage$unit <- natage$iter <- NULL
names(natage)[names(natage) == "data"] <- "n"
natage <- natage[c("year", "season", "area", "age", "n")]

# Spawning potential
biomass <- as.data.frame(adultBiomass(rep))
biomass$age <- biomass$unit <- biomass$iter <- NULL
names(biomass)[names(biomass) == "data"] <- "ssb"

# Annual summary
rec <- aggregate(data~year, as.data.frame(popN(rep)), sum, subset=age==1)
y <- as.data.frame(seasonSums(total_catch(catches)))
sb <- as.data.frame(SB(rep))
sbf0 <- as.data.frame(SBF0(rep))
dep <- as.data.frame(SBSBF0(rep))
f <- as.data.frame(seasonSums(AggregateF(rep)))
summary <- data.frame(year=sb$year, rec=rec$data, catch=y$data, sb=sb$data,
                      sbf0=sbf0$data, dep=dep$data, f=f$data)

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

# Write TAF tables
write.taf(biology, dir="output")
write.taf(biomass, dir="output")
write.taf(catch, dir="output")
write.taf(cpue, dir="output")
write.taf(f.season, dir="output")
write.taf(f.annual, dir="output")
write.taf(f.stage, dir="output")
write.taf(f.aggregate, dir="output")
write.taf(length.comps, dir="output")
write.taf(likelihoods, dir="output")
write.taf(natage, dir="output")
write.taf(selectivity, dir="output")
write.taf(stats, dir="output")
write.taf(summary, dir="output")
write.taf(weight.comps, dir="output")
