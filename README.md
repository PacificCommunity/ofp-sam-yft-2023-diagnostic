# YFT 2023 Diagnostic Model

## Reference model

In SPC assessment jargon, the *diagnostic model* is the reference model that is
the basis of several sections and figures in the stock assessment report.

The diagnostic model is also the entry point when configuring and running the
grid of ensemble models that is the basis of scientific advice. When the grid
includes specific factor levels (for steepness, likelihood weights, etc.) the
diagnostic model has intermediate levels, while other grid members explore
higher and lower levels.

## Explore data, model settings, and results

The [MFCL](MFCL) folder includes all the MFCL input files, model settings, and
output files.

The [TAF](TAF) folder extracts the data and results from MFCL format to CSV
format that can be examined using Excel, R, or other statistical software. TAF
is a standard reproducible format for stock assessments that is practical for
making the MFCL [data](TAF/data) and [output](TAF/output) available in a format
that is easy to examine. The [report](TAF/report) folder contains formatted
tables and example plots.

## Run the assessment model

The YFT 2023 model takes around 10 hours to run. It requires a Linux platform,
such as:

- Plain Linux machine, e.g. personal laptop
- Windows Subsystem for Linux, optional feature in Windows
- Virtual machine, e.g. VirtualBox or VMware
- Online services that provide Linux machines

The `mfclo64` executable was compiled on Ubuntu 20.04 using static linking, so
it should run on almost any Linux machine.
