#!/bin/bash
####this script is also used for submitting jobs to the Penn State cluster (needed to get around limits regarding number of files that can be created in a single directory)

for value in {0..1}
do
      qsub -e ~/scratch/riceCollab/run24/outputs -o ~/scratch/riceCollab/run24/outputs -v CHUNK=~/scratch/riceCollab/run24/inputs/PC000${value} /storage/home/ezb336/scratch/riceCollab/run24/subCost.pbs
done
