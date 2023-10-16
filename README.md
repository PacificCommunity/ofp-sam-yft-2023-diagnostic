# YFT 2023 Diagnostic Model

Download YFT 2023 assessment report:

- **Stock assessment of yellowfin tuna in the western and central Pacific Ocean: 2023**\
  **[WCPFC-SC19-2023/SA-WP-04](https://meetings.wcpfc.int/node/19352)**

Download YFT 2023 diagnostic model:

- Clone the **[yft-2023-diagnostic](https://github.com/PacificCommunity/ofp-sam-yft-2023-diagnostic)** repository or download as **[main.zip](https://github.com/PacificCommunity/ofp-sam-yft-2023-diagnostic/archive/refs/heads/main.zip)** file

Download YFT 2023 grid results:

- The **[yft-2023-grid](https://github.com/PacificCommunity/ofp-sam-yft-2023-grid/releases)** release page includes a **[yft-2023-grid-results.zip](https://github.com/PacificCommunity/ofp-sam-yft-2023-grid/releases/download/file/yft-2023-grid-results.zip)** file

## Reference model

In SPC assessment jargon, the *diagnostic model* is the reference model that is the basis of several sections and figures in the stock assessment report.

The diagnostic model is also the entry point when configuring and running the grid of ensemble models that is the basis of scientific advice. When the grid includes specific factor levels (for steepness, likelihood weights, etc.) the diagnostic model has intermediate levels, while other grid members explore higher and lower levels.

Finally, the diagnostic model is also the starting point for the YFT 2026 stock assessment model development. One purpose of this repository is to give the stock assessor a good starting point that is organized and documented.

## Explore data, model settings, and results

The **[MFCL](MFCL)** folder includes all the MFCL input files, model settings, and output files.

The **R** folder elaborates on the relationship between three closely related model runs: the diagnostic model (not jittered, runs from an ini file), the jittered model (runs from a par file), and the m2_s20_a075_h80 grid member (double jittered). The target audience is the YFT 2026 stock assessor.

The **TAF** folder extracts the data and results from MFCL format to CSV format that can be examined using Excel, R, or other statistical software. [TAF](https://cran.r-project.org/package=TAF) is a standard reproducible format for stock assessments that is practical for making the MFCL **[data](TAF/data)** and **[output](TAF/output)** available in a format that is easy to examine. The **[report](TAF/report)** folder contains formatted tables and example plots.

## Run the assessment model

The YFT 2023 model takes around 10 hours to run. It requires a Linux platform, such as:

- Plain Linux machine, e.g. a personal laptop
- Windows Subsystem for Linux, optional feature in Windows
- Virtual machine, e.g. VirtualBox or VMware
- Online services that provide Linux machines

The `mfclo64` executable was compiled on Ubuntu 20.04 using *static linking*, so it should run on almost any Linux machine.

### Run in a Linux terminal

Navigate to the MFCL folder and run:

```
./doitall.sh
```

Alternatively, copy the required files into a new folder,

```
doitall.sh
mfcl.cfg
mfclo64
yft.age_length
yft.frq
yft.ini
yft.tag
```

and then run the model:

```
./doitall.sh
```

### Run on Condor

SPC staff run most assessment models on a Condor cluster of Linux machines:

```
library(condor)
session <- ssh_connect("CONDOR_SUBMITTER_MACHINE")
condor_submit()
```

### Run in TAF format

Anyone can run the assessment analysis in TAF format. First install TAF, FLCore, and FLR4MFCL, if they are not already installed:

```
install.packages("TAF")
install_github("flr/FLCore")
install_github("PacificCommunity/FLR4MFCL")
```

On a Linux machine, the full assessment model can be run as a TAF analysis. Start R, make sure the TAF folder is the working directory, and then run:

```
library(TAF)
taf.boot()
source.taf("data.R")
source.taf("model.R")
source.taf("output.R")
source.taf("report.R")
```

A shortcut script is provided, to run the TAF analysis in 1 minute rather than 10 hours:

```
library(TAF)
taf.boot()
source.taf("data.R")
source.taf("model_shortcut.R")
source.taf("output.R")
source.taf("report.R")
```

The TAF shortcut analysis runs an all platforms: Windows, Linux, and macOS. It extracts the data and output from the MFCL files and makes them available as CSV files that can be examined and analyzed further.
