####this code produces a conductance layer from which travel time can be determined
####In general, it follows the 'Hiking around Maunga Whau' section of the 'gdistance' vignette https://cran.r-project.org/web/packages/gdistance/vignettes/gdistance1.pdf to determine the fastest hiking route between two points.
####For travel over water, we assume a constant travel speed of 3 knots

library(gdistance)
library(raster)

## load a raster file giving elevation in meters
alt<-raster('/gpfs/group/jrl35/default/EnvData/alt/alt/w001001.adf')
## we have found computation of the transition layers is quite memory intensive, best to crop to a smaller extent a degree or two beyond the coordinates of the furthest landraces 
e <- extent(71, 135, -10, 41) 
alt.c <- crop(alt, e)

######Tobler's hiking function requires slope, which can be computed from the difference in elevation between two cells and distance between cell centers
#change NA cells (incl. ocean cells) to 0
w <- alt.c
values(w) <- 0
alt.nona <- cover(alt.c, w)

altDiff <- function(x){x[2] - x[1]}	#function to calculate difference in elevation between two cells		
hd <- transition(alt.nona, altDiff, 8, symm=FALSE) #this matrix reflects diff. in elevation between center cell and cell in all 8 directions from it
slope <- geoCorrection(hd) #divide by the distance between cells

adj <- adjacent(alt.nona, cells=1:ncell(alt.nona), pairs=TRUE, directions=8)  #only calculate speed for adjacent cells
speed <- slope
speed[adj] <- 6 * exp(-3.5 * abs(slope[adj] + 0.05)) #Tobler's hiking function			
Conductance <- geoCorrection(speed) #take into account distance between cell centers (longer for cells on diagonal), this gives final conductance, equal to the reciprocal of travel time

######However, we still need to take into account travel over ocean, which should be faster than travel over flat land 
s <- calc(alt.c, fun=function(x){ x[x != "NA"] <- 1; return(x)} ) # make a raster where all cells on land have value 1
w <- alt.c
values(w) <- 1.1 #3 knots under sail is approximately 1.54 m/s which is about 1.1 times the speed of walking over flat land
alt.land1.ocean1.1 <- cover(s,w) # this raster has values of 1 for cells on land and 1.1 for cells over ocean
hd.2 <- transition(alt.land1.ocean1.1, mean, 8, symm=FALSE) #create transition matrix for layer
con_ocean1.1x <- Conductance*hd.2 #done! ow conductance over sea is 1.1 times that over land
