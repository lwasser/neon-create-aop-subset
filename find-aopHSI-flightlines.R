###
# this code takes a shapefile polygon extent and a directory containging
# a bunch of NEON H5 files and returns the flightlines that INTERSECT the 
# polygon boundary
###


# load libraries
library(sp)
library(rgeos)
library(rhdf5)

source("/Users/lwasser/Documents/GitHub/neon-aop-package/neonAOP/R/aop-data.R")


## functions
## Check Extent Function ####
# this function below checks to see if a raster falls within a spatial extent
# inputs: raster file to check, clipShp (spatial )
checkExtent <- function(aRaster, clipShp){
  # create polygon extent assign CRS to extent 
  h5.extent.sp <- as(h5.extent, "SpatialPolygons")
  # note this is ASSUMING both the extent and the h5 file are in the same CRS
  crs(rasterExtPoly) <-  crs(clip.polygon)
  
  # check to see if the polygons overlap
  # return a boolean (1= the raster contains pixels within the extent, 0 it doesn't)
 
  # check to see if the polygons overlap
  # return a boolean (1= the raster contains pixels within the extent, 0 it doesn't)
  return(gIntersects(h5.extent.sp, clip.polygon))
}
########## Inputs #####

# file path
h5dir.path <- "path-here"

# shapefile path and name
shape.path <- "NEONdata/D17-California/SJER/vector_data"
shape.name <- "sjer_clip_extent" 

#### Import shapefile ####
# import shapefile
clip.polygon <- readOGR("NEONdata/D17-California/SJER/vector_data",
                        "sjer_clip_extent")

######### Read H5 Files ####
# get a list of all files in the dir
h5.files <- list.files(h5dir.path, pattern = '\\.h5$')
if (length(h5.files==0)){
  print("No Files returned. Abort script")

  ELSE
  for(file in h5.files){
    # grab the H5 Extent
    h5.extent <- create_extent(file) 
    if(checkExtent){
      
    }
  }

  
}






