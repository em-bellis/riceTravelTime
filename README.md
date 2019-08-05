# riceTravelTime

This repository contains code used to estimate human travel time over land and sea, as presented in Gutaker, R. *et al.* (in prep).

Since most of the code is pretty specific to running the 'gdistance' analysis on our local compute cluster for many thousands of pairwise distance calculations, I provide it mostly as an example of how the analysis was performed (it would need a lot of editing to get it going on your own system!)

In general there are three phases to the analysis:

**1. Create a conductance layer from which pairwise travel distance can be calculated (`getConductanceLayer.R`)**

**2. Calculate distances between all possible pairwise combinations**. For this I create a helper file of unique combinations of GPS coordinates, which is split up into smaller chunks of about 24 lines (=unique pairwise combinations) each. The script `subAll.sh` is used to submit jobs based on these chunks to the queue (via `subCost.pbs`). `subCost.pbs` runs `costDistance.R` for each pairwise comparison and prints to a file containing all the output for that chunk.

**3. Format a matrix based on output calculated in #2 (`makeMat.pl`)**

This analysis was performed using R version 3.5 and R package 'gdistance' version 1.2-2.
