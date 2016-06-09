###
# this code takes a shapefile polygon extent and a directory containging
# a bunch of NEON H5 files and returns the flightlines that INTERSECT the 
# polygon boundary
###

library(devtools)

## install from github
install_github("lwasser/neon-aop-package/neonAOP")

library(neonAOP)

# load libraries
library(sp)
library(rgeos)
library(rhdf5)

# source("/Users/lwasser/Documents/GitHub/neon-aop-package/neonAOP/R/aop-data.R")


########## Inputs #####

# shapefile path and name
# shape.path <- "NEONdata/D17-California/SJER/vector_data"
# clipFile <- "sjer_clip_extent"


########## Inputs #####

# ##### OSBS Clip
# # the name of the site
# site <- "OSBS"
# domain <- "D3"
# fullDomain <- "D03-Florida"
# level <- "L1"
# dataType <- "lidar"
# level <- paste0(site,"_L1")
# year <- "2014"
# productType <- paste0(site,"_Spectrometer")
# dataProduct <- "Reflectance"

### SOAP Clip
# the name of the site
site <- "SOAP"
domain <- "D17"
fullDomain <- "D17-Florida"
level <- "L1"
dataType <- "Spectrometer"
level <- paste0(site,"_L1")
year <- "2013"
productType <- paste0(site,"_", dataType)
dataProduct <- "Reflectance"
adate <- "2013061216"

clipFile <- paste0(site,"_crop")




dataDir <- file.path("P:","Distros","1.3a+WaveForm_V1.1a",
                     "1.3a", domain,
                     site, year, level, productType, adate, dataProduct)
# specify the path to the clip file
clipFilePath <- file.path("H:","1_Data-Institute-subsets",fullDomain, site, "vector_data")

# get a list of all files in the dir
h5.files <- list.files(dataDir, pattern = '\\.h5$', full.names = TRUE)

#### Import shapefile ####
# import shapefile
clip.polygon <- readOGR(clipFilePath,
                        clipFile)

#### Get File Dir


#####
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
 



######### Read H5 Files ####

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






