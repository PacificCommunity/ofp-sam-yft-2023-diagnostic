## Prepare plots and tables for report

## Before: biology.csv, f_annual.csv, f_stage.csv, summary.csv (output)
## After:  biology.csv, f_adult_juvenile_same_free.png,
##         f_adult_juvenile_same_axes.png, f_last_10_free_axes.png,
##         f_last_10_same_axes, summary.csv (report)

library(TAF)
library(lattice)

mkdir("report")

# Read results
biology <- read.taf("output/biology.csv")
summary <- read.taf("output/summary.csv")
f.stage <- read.taf("output/f_stage.csv")
f.annual <- read.taf("output/f_annual.csv")

# Format tables
biology <- rnd(biology, 2:5, c(1,1,3,3))
summary <- div(summary, 2:6, 10^c(6,3,3,3,3))
summary <- rnd(summary, 2:8, c(0, 0, 0, 0, 0, 2, 2))
biology <- format(biology)  # retain trailing zeros
summary <- format(summary)  # retain trailing zeros

# Plot adult and juvenile F
taf.png("f_adult_juvenile_same_axes", width=2200, height=1400, res=300)
p <- xyplot(f~year|area, groups=stage, f.stage, type="l", col=1, lty=1:2, lwd=2,
            grid=TRUE, xlab="Year", ylab="Fishing mortality", layout=c(2,3),
            as.table=TRUE, scales=list(alternating=FALSE))
plot(p)
dev.off()

taf.png("f_adult_juvenile_free_axes", width=2200, height=1400, res=300)
p <- xyplot(f~year|area, groups=stage, f.stage, type="l", col=1, lty=1:2, lwd=2,
            grid=TRUE, xlab="Year", ylab="Fishing mortality", layout=c(2,3),
            as.table=TRUE,
            scales=list(y=list(relation="free"), alternating=FALSE, rot=0),
            between=list(x=0.6))
plot(p)
dev.off()

# Plot fishing mortality by age for the last ten years
taf.png("f_last_10_same_axes", width=2200, height=1400, res=300)
f.last.10 <- f.annual[f.annual$year %in% tail(sort(unique(f.annual$year)), 10),]
f.last.10 <- aggregate(f~age+area, f.last.10, mean)
p <- xyplot(f~age|area, f.last.10, type="l", lwd=2, grid=TRUE, xlab="Age class",
            ylab="Fishing mortality", layout=c(2,3), as.table=TRUE,
            scales=list(alternating=FALSE))
plot(p)
dev.off()

taf.png("f_last_10_free_axes", width=2200, height=1400, res=300)
f.last.10 <- f.annual[f.annual$year %in% tail(sort(unique(f.annual$year)), 10),]
f.last.10 <- aggregate(f~age+area, f.last.10, mean)
p <- xyplot(f~age|area, f.last.10, layout=c(2,3), as.table=TRUE, type="l",
            lwd=2, grid=TRUE, xlab="Age class", ylab="Fishing mortality",
            scales=list(y=list(relation="free"), alternating=FALSE, rot=0),
            between=list(x=0.6))
plot(p)
dev.off()

# Write TAF tables
write.taf(biology, dir="report")
write.taf(summary, dir="report")
