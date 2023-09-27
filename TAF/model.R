## Run analysis, write model results

## Before: doitall.sh, mfcl.cfg, yft.age_length, yft.frq, yft.ini,
##         yft.tag (boot/data), mfclo64 (boot/software)
## After:

library(TAF)

mkdir("model")

# Software
cp("boot/software/mfclo64", "model")

# Input files
cp("boot/data/doitall.sh",     "model")
cp("boot/data/mfcl.cfg",       "model")
cp("boot/data/yft.age_length", "model")
cp("boot/data/yft.frq",        "model")
cp("boot/data/yft.ini",        "model")
cp("boot/data/yft.tag",        "model")

# Run model
setwd("model")
system("doitall.sh")
setwd("..")
