## Extract results of interest, write TAF output tables

## Before: 11.par, catch.rep, length.fit, plot-11.par.rep, test_plot_output,
##         weight.fit (model)
## After:  11.par, catch.rep, length.fit, plot-11.par.rep, test_plot_output,
##         weight.fit (output)

library(TAF)

mkdir("output")

cp("model/11.par",           "output")
cp("model/catch.rep",        "output")
cp("model/length.fit",       "output")
cp("model/plot-11.par.rep",  "output")
cp("model/test_plot_output", "output")
cp("model/weight.fit",       "output")
