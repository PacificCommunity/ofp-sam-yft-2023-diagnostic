# The diagnostic model (14c) starts from ini file, inherited by next assessor
# Jitter model 14a_03_10 comes from exploring the likelihood surface
# The jittered grid member m2_s20_a075_h80 has the best objfun value
#
# All are the same model (parameters and structure) and all have a similar
# estimate for depletion, 0.43
# They differ in terms of starting values and estimation phases

library(FLR4MFCL)

model.runs <- "//penguin/assessments/yft/2023/model_runs"

diag.path <- file.path(model.runs, "diagnostic")
jit.path <- file.path(model.runs, "jitter/14a_Jitter_03/Jitter_16a_Jitter_03_10")
grid.path <- file.path(model.runs, "grid/round_3_m2_final/m2_s20_a075_h80")

################################################################################

diag.par <- read.MFCLParBits(finalPar(diag.path))
jit.par <- read.MFCLParBits(finalPar(jit.path))
grid.par <- read.MFCLParBits(finalPar(grid.path))

diag.objfun <- obj_fun(diag.par)
jit.objfun <- obj_fun(jit.par)
grid.objfun <- obj_fun(grid.par)

round(diag.objfun)  # -748630
round(jit.objfun)   # -748642
round(grid.objfun)  # -748647

################################################################################

diag.rep <- read.MFCLRep(finalRep(diag.path))
jit.rep <- read.MFCLRep(finalRep(jit.path))
grid.rep <- read.MFCLRep(finalRep(grid.path))

diag.dep <- SBSBF0(diag.rep)
jit.dep <- SBSBF0(jit.rep)
grid.dep <- SBSBF0(grid.rep)

diag.final <- tail(as.data.frame(diag.dep), 1)$data
jit.final <- tail(as.data.frame(jit.dep), 1)$data
grid.final <- tail(as.data.frame(grid.dep), 1)$data

round(diag.final, 3)  # 0.433
round(jit.final, 3)   # 0.427
round(grid.final, 3)  # 0.426

