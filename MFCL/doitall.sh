#!/bin/sh

# -----------------------------------
#  PHASE 0 - create initial par file
# -----------------------------------

mfclo64 yft.frq yft.ini 00.par -makepar

# -----------------------
#  PHASE 1 - initial par
# -----------------------

mfclo64 yft.frq 00.par 01.par -file - <<PHASE1
# Use default quasi-Newton minimizer
  1 351 0
  1 192 0
# Allow all growth parameters to be fixed during control phase
  1 32 7
#
# Catch conditioned flags
# General activation
  1 373 1  # activate CC with Baranov equation
  1 393 0  # estimate kludged_equilib_coffs and implicit_fm_level_regression_pars
  2 92 2   # specify catch-conditioned option with Baranov equation
# Catch equation bounds
  2 116 70   # value for Zmax_fish in catch equations
  2 189 80   # fraction of Zmax_fish above which penalty is calculated
  1 382 300  # weight for Zmax_fish penalty - set to 300 to avoid triggering Zmax_flag=1
# Deactivate any catch errors flags
  -999 1 0
  -999 4 0
  -999 10 0
  -999 15 0
  -999 13 0
#
# Survey fisheries defined
# CPUE variation  Index wt   Time varying CV
  -33 94 1        -33 92 61  -33 66 0
  -34 94 1        -34 92 77  -34 66 0
  -35 94 1        -35 92 79  -35 66 0
  -36 94 1        -36 92 82  -36 66 0
  -37 94 1        -37 92 74  -37 66 0
# Grouping flags for survey CPUE
   -1 99 1
   -2 99 2
   -3 99 3
   -4 99 4
   -5 99 5
   -6 99 6
   -7 99 7
   -8 99 8
   -9 99 9
  -10 99 10
  -11 99 11
  -12 99 12
  -13 99 13
  -14 99 14
  -15 99 15
  -16 99 16
  -17 99 17
  -18 99 18
  -19 99 19
  -20 99 20
  -21 99 21
  -22 99 22
  -23 99 23
  -24 99 24
  -25 99 25
  -26 99 26
  -27 99 27
  -28 99 28
  -29 99 29
  -30 99 30
  -31 99 31
  -32 99 32
  -33 99 33
  -34 99 33
  -35 99 33
  -36 99 33
  -37 99 33
#
# Recruitment and initial population settings
  1 149 100        # recruitment deviation penalty
  1 400 6          # final six recruitment deviates set to zero
# Fixed terminal recruitments are arithmetic mean of remaining period (not default geometric mean)
  1 398 1
  2 177 1          # use old totpop scaling method
  2 32 1           # and estimate totpop parameter
  2 93 4           # set no. of recruitments per year to 4
  2 57 4           # set no. of recruitments per year to 4
  2 94 1 2 128 10  # initial Z = 1.0*M, i.e. initial F = 0
#
# Movement
  2 69 1
#
# Likelihood component settings
  1 111 4     # set likelihood function for tags to negative binomial
  1 141 3     # set likelihood function for LF data to normal
  1 139 3     # set likelihood function for WF data to normal
  -999 49 20  # divide LL LF sample sizes by 20
  -999 50 20  # divide LL WF sample sizes by 20
# For longline ALL and Index fisheries, reduce sample size in half
# so we aren't double counting sample sizes
   -1 49 40   -1 50 40
   -2 49 40   -2 50 40
   -4 49 40   -4 50 40
   -7 49 40   -7 50 40
   -8 49 40   -8 50 40
   -9 49 40   -9 50 40
  -11 49 40  -11 50 40
  -12 49 40  -12 50 40
  -29 49 40  -29 50 40
  -33 49 40  -33 50 40
  -34 49 40  -34 50 40
  -35 49 40  -35 50 40
  -36 49 40  -36 50 40
  -37 49 40  -37 50 40
#
# Tag dynamics settings
  1 33 99    # maximum tag reporting rate for all fisheries is 0.99
  2 96 12    # pool tags after 12 quarters at liberty
  -9999 1 2  # set no. mixing periods for all tag release groups to 2
  2 198 1    # activate release group reporting rates
  -999 43 0  # estimate tag variance if = 1
  -999 44 0  # group all tags for variance estimation if = 1
# Grouping of fisheries for tag return data
   -1 32  1
   -2 32  2
   -3 32  3
   -4 32  4
   -5 32  5
   -6 32  6
   -7 32  7
   -8 32  8
   -9 32  9
  -10 32 10
  -11 32 11
  -12 32 12
  -13 32 13
  -14 32 13
  -15 32 14
  -16 32 14
  -17 32 15
  -18 32 15
  -19 32 16
  -20 32 17
  -21 32 18
  -22 32 19
  -23 32 15
  -24 32 15
  -25 32 20
  -26 32 20
  -27 32 21
  -28 32 22
  -29 32 23
  -30 32 24
  -31 32 24
  -32 32 25
  -33 32 26
  -34 32 26
  -35 32 26
  -36 32 26
  -37 32 26
#
# Selectivity settings
  -999 3 37  # all selectivities equal for age class 37 and older
  -999 26 2  # set length-dependent selectivity option
  -999 57 3  # use cubic spline selectivity
  -999 61 5  # with 5 nodes for cubic spline
# Grouping of fisheries with common selectivity
   -1 24 1   # LL ALL 1
   -2 24 2   # LL ALL 2
   -3 24 3   # LL US 2
   -4 24 4   # LL ALL 3
   -9 24 5   # LL ALL 4
  -12 24 6   # LL ALL 6
  -11 24 7   # LL ALL 5
  -29 24 7   # LL ALL 9
   -5 24 8   # LL OS 3
   -6 24 9   # LL OS 7
   -7 24 10  # LL ALL 7
   -8 24 11  # LL ALL 8
  -10 24 12  # LL AU 5
  -27 24 12  # LL AU 9
  -13 24 13  # PS ASS
  -30 24 13  # combine because small sample size
  -15 24 14
  -25 24 15
  -14 24 16  # PS UNA
  -31 24 16  # combine because small sample size
  -16 24 17
  -26 24 18
  -17 24 19  # Dom PH
  -18 24 20  # HL ID PH
  -19 24 21  # PS JP 1
  -20 24 22  # PL JP 1, 3, 8
  -21 24 23
  -22 24 24
  -23 24 25  # Dom ID and VN PL region 7
  -28 24 26
  -32 24 27
  -24 24 28
  -33 24 29  # Index fisheries
  -34 24 29
  -35 24 29
  -36 24 29
  -37 24 29
# Non-decreasing selectivity for at least one index/longline fishery in each region
  -33 16 1
  -34 16 1
  -35 16 1
  -36 16 1
  -37 16 1
# Make some longline selectivites 0 for first few age classes
   -2 75 2
   -4 75 2
   -5 75 2
   -6 75 2
   -7 75 2
   -9 75 2
  -11 75 2
  -12 75 2
  -29 75 2
  -17 16 2  -17 3 12  # force selectivity to zero for large fish in small MISC fisheries
  -23 16 2  -23 3 12
  -28 16 2  -28 3 12
  -32 16 2  -32 3 12
  -24 16 2  -24 3 12  # PS PH ID weird bump at 110 cm
  -20 16 2  -20 3 24
  -21 16 2  -21 3 24
  -22 16 2  -22 3 24
# Set first age class for PS and PL fisheries to 0 to prevent weird recruitment distributions
  -13 75 1
  -14 75 1
  -15 75 1
  -16 75 1
  -18 75 4
  -19 75 1
  -20 75 1
  -21 75 1
  -22 75 1
  -25 75 1
  -26 75 1
  -30 75 1
  -31 75 1
# Turn on weighted spline for calculating maturity at age
  2 188 2
# Set Lorenzen M
  2 109 3   # select Lorenzen curve
  1 121 0   # do not estimate Lorenzen scaling parameter yet
# Truncate tails off size compositions and filter out small samples
  1 311 1   # set tail compression for LF data
  1 301 1   # set tail compression for WF data
  1 313 0   # proportions in compressed tails for LF data
  1 303 0   # proportions in compressed tails for WF data
  1 312 50  # set minimum obs sample size for LF data
  1 302 50  # set minimum obs sample size for WF data
# SD of length at age
  1 34 0    # set to 1 34 1 to run with old variance, as in MFCL 2.1.1.0 and earlier
PHASE1

# ---------
#  PHASE 2
# ---------

mfclo64 yft.frq 01.par 02.par -file - <<PHASE2
 1 1 1000  # set max. number of function evaluations per phase to 1000
 2 113 0   # turn off useless parameter rec_init_diff
PHASE2

# ---------
#  PHASE 3
# ---------

mfclo64 yft.frq 02.par 03.par -file - <<PHASE3
 2 70 1   # activate time series of reg recruitment parameters
 2 71 1   # estimate temporal changes in recruitment distribution
 2 178 1  # constrain regional recruitments
PHASE3

# ---------
#  PHASE 4
# ---------

mfclo64 yft.frq 03.par 04.par -file - <<PHASE4
 2 68 1   # estimate movement coefficients
 2 27 -1  # penalty wt 0.1 computed against prior
PHASE4

# ---------
#  PHASE 5
# ---------

mfclo64 yft.frq 04.par 05.par -file - <<PHASE5
  -100000 1 1  # estimate
  -100000 2 1  # time-invariant
  -100000 3 1  # distribution
  -100000 4 1  # of
  -100000 5 1  # recruitment
PHASE5

# ---------
#  PHASE 6
# ---------

mfclo64 yft.frq 05.par 06.par -file - <<PHASE6
 1 240 1  # activate model fit to observed age-length data
 1 12 0   # do not estimate mean length of age 1
 1 13 0   # do not estimate mean length of largest age class
 1 14 0   # do not estimate von Bertalanffy K
PHASE6

# ---------
#  PHASE 7
# ---------

mfclo64 yft.frq 06.par 07.par -file - <<PHASE7
  1 15 1  # estimate overall SD
  1 16 1  # estimate length dependent SD
PHASE7

# ---------
#  PHASE 8
# ---------

mfclo64 yft.frq 07.par 08.par -file - <<PHASE8
 1 173 0  # estimate independent mean lengths for 1st 0 age classes
 1 182 0
 1 184 0
PHASE8

# ---------
#  PHASE 9
# ---------

mfclo64 yft.frq 08.par 09.par -file - <<PHASE9
  2 145 1    # penalty on stock-recruit pars
  1 149 0    # penalty for recruitment devs
  2 146 1    # activate estimation of SRR parameter
  2 182 1    # annual SRR
  2 163 0    # alternate parameters for SRR, turn off
  2 147 1    # lag b/w spawning and recruitment
  2 148 20   # years from last year to get average F
  2 155 4    # years from last year to omit from average F
  -999 55 1  # turn on fishery impact analysis
  2 161 1    # activate SRR log-normal bias correction
  2 199 212  # start time period for yield calculation
  2 200 4    # end time for yield calculation/SRR estimation
  2 171 1    # include SRR-based equilibrium recruitment to compute unfished biomass
  2 116 200  # increase Z bound for NR computations to 2.0
#
# Output flags
  1 190 1  # write plot.rep
  1 186 1  # write fishmort and plotq0.rep
  1 187 1  # write temporary_tag_report
  1 188 1  # write ests.rep
  1 189 1  # write .fit files
  1 50 -2  # convergence criteria
  1 1 500  # extra evals
PHASE9

# ----------
#  PHASE 10
# ----------

mfclo64 yft.frq 09.par 10.par -file - <<PHASE10
  2 145 -1   # use SRR parameters - low penalty for deviation
  1 1 10000
  1 50 -5
  2 116 300  # increase Z bound for NR computations to 3.0
PHASE10

# ----------
#  PHASE 11
# ----------

mfclo64 yft.frq 10.par 11.par -file - <<PHASE11
  1 13 1     # estimate mean length of largest age class
  1 14 1     # estimate von Bertalanffy K
  1 121 1    # estimate Lorenzen scaling parameter
  1 1 10000
  1 50 -5
PHASE11
