#!/usr/bin/Rscript
######this script is used to calculate and output travel time between a single pair of points, given each's coordinates
args = commandArgs(trailingOnly=TRUE)
library(gdistance)

Aid <- args[1]
LatA <- as.numeric(args[2])
LonA <- as.numeric(args[3])
Bid <- args[4]
LatB <- as.numeric(args[5])
LonB <- as.numeric(args[6])

row.info <- cbind.data.frame(Aid, LatA, LonA, Bid, LatB, LonB)

A <- SpatialPoints(cbind(LonA,LatA))
B <- SpatialPoints(cbind(LonB,LatB))

if(A@coords[1] == B@coords[1] && A@coords[2] == B@coords[2]) {
	hrs <- 0
} else {
	load('/storage/home/ezb336/scratch/riceCollab/dec/con_ocean1.1x.RDA')
	hrs <- costDistance(con_ocean1.1x, A, B)/1000
}
gc()
Sys.time()
row.info[7] <- hrs
pcfile <- paste("/storage/home/ezb336/scratch/riceCollab/run24/values/", args[7], sep="")
write.table(row.info, file=pcfile, sep="\t", row.names=F, col.names=F, append=T)
