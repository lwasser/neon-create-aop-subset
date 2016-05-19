## A set of functions to...
## This script will sort through a directory of raster files 
## to determine what files are within a particular study AOI extent
## Author: Leah A. Wasser
## Last Modified: 4 May 2016

### Required packages ####
# install.packages(c("raster","rgdal","rgeos"))
library(raster)
library(rgdal)
library(rgeos)

# specify the working DIR

# setwd("~/Documents/data/1_spectrometerData/Teakettle")
setwd("H:\\1_Teakettle\\new_subset\\lidar")



## Check Extent Function ####
# this function below checks to see if a raster falls within a spatial extent
# inputs: raster file to check, clipShp (spatial )
checkExtent <- function(aRaster, clipShp){
  # create polygon extent assign CRS to extent 
  rasterExtPoly <- as(extent(aRaster), "SpatialPolygons")
  crs(rasterExtPoly) <-  crs(aRaster)
  
  # check to see if the polygons overlap
  # return a boolean (1= the raster contains pixels within the extent, 0 it doesn't)
  return(gIntersects(clipShp, rasterExtPoly))
}


## This function checks to see if a raster falls within the extent
## if it's in the extent, it then records the name of the file

rastInClip <- function(rasterFile,clipShp) {
  # rasterFile <- "/Volumes/data_dr/teakettle/DTM/2013_TEAK_1_326000_4103000_DTM.tif"
  # rasterFile <- rasterList[221]
  recordRaster <- NA
  aRaster <- raster(rasterFile)
  if (checkExtent(aRaster, clipShp)) {
    recordRaster <- rasterFile
  }
  return(recordRaster)
}


## Get Aop Tiles ####
# This fun takes a list of file names (gtif), a clipping extent and an output
# gtif name to create a mosaic and write a gtif. 
get_AOP_tiles <- function(tileDir, clipExtent, outFileName){
  message(paste0("Now running ", tileDir[1]))
  # get list of files from the server
  rasterList <- list.files(tileDir, full.names = TRUE, pattern = "\\.tif$")
  
  # create a boolean list of rasters in the extent window == 1
  finalList <- unlist(lapply(rasterList, rastInClip, clipShp = clipExtent))
  # remove NA and get the final list of rasters to mosaic
  finalList <- finalList[!is.na(finalList)]
  
  # take the list of rasters, and create a mosaic
  rast.list <- list()
  for(i in 1:length(finalList)) { rast.list[i] <- stack(finalList[i]) }
  
  # mosaic rasters
  # note removed () from the function max call for windows
  rast.list$fun <- max
  rast.mosaic <- do.call(mosaic, rast.list)
  # plot(rast.mosaic)
  
  # crop final mosaic to clip extent
  rast.mosaic <- crop(rast.mosaic, clipExtent)
  
  # write geotiff
  writeRaster(rast.mosaic,
              filename=outFileName,
              format="GTiff",
              options="COMPRESS=LZW",
              overwrite = TRUE,
              NAflag = -9999,
              datatype="FLT4S") # ensure it's writing to 32 bit
  # for those who want to plot the final raster to check it out
  # return(rast.mosaic)
}

### run code ####

# the function below if used with lapply could potentially 
# or use mapply to work through a list of paths and associated outputs
# dataDir <- "P:\\Distros\\1.3a+WaveForm_V1.1a\\1.3a\\D17\\TEAK\\2013\\TEAK_L1\\TEAK_Camera\\Images"

# tristan updated the CHM data -- make sure it is on the server ! 
# fixed CHM data
# dataDir <- "Y:\\users\\tgoulden\\TEAK\\L3\\DiscreteLidar\\CanopyHeightModelGtif"
# create list of output dirs to parse through


# this is where the data are stored in separate directories
# NOTE: if you use file.path then it will adjust the slashes to pc vs mac!
dataDir <- file.path("Users","lwasser","Documents")
# P:\\Distros\\1.3a+WaveForm_V1.1a\\1.3a\\D17\\TEAK\\2013\\TEAK_L3\\TEAK_Lidar\\
#dataDir <- file.path("P:","Distros","1.3a+WaveForm_V1.1a",
#                     "1.3a","D17",
#                     "TEAK","2013","TEAK_L3",
#                     "TEAK_Lidar")


#dataDir <- file.path("P:","Distros","1.3a+WaveForm_V1.1a",
#                     "1.3a","D17",
#                     "SJER","2013","SJER_L3",
#                     "SJER_Lidar")


# the name of the site
site <- "SJER"
domain <- "D17"
level <- "L3"
dataType <- "lidar"
level <- "SJER_L3"
year <- "2013"
dataDir <- "SJER_Lidar"


dataDir <- file.path("P:","Distros","1.3a+WaveForm_V1.1a",
                     "1.3a", domain,
                     site, year, level,
                     dataDir)

# dataDir <- "/Users/lwasser/Documents/data/1_data-institute-2016/Teakettle/may1_subset"




## Get Clip File ####

# clipFile <- "teakettle_clip"
#clipFile <- "teakettleClip_2"
clipFile <- "soap_clip_extent"
# specify the path to the clip file
clipFilePath <- file.path("H:","1_Teakettle", site)


# where you want to save the outputs
# outputDir <- "/Users/lwasser/Documents/data/1_data-institute-2016/Teakettle/may1_subset/subset/lidar"
outputDir <- file.path("H:","1_Teakettle", site, year, dataType)


# automate parsing through all lidar subdirs to grab data
tileDir <- list.dirs(dataDir,
                     full.names = TRUE, 
                     recursive = FALSE)

# create a list of output filenames
outNames <- paste0(clipFilePath, "/2013/",dataType,"/", site, "_", dataType, basename(tileDir),".tif")



# import shapefile to spatial polygon
clipExtent <- readOGR(clipFilePath, clipFile)

## write output mosaics ####
# the code below calls a function that grabs all of the gtifs within a clipping
# extent from each directory specified in the list. it should then
# write an output gtif

mapply(get_AOP_tiles, tileDir, 
       clipExtent = clipExtent, 
       outFileName = outNames)

# mapply is still acting odd so using a for loop

for(i in 1:length(tileDir)){
  get_AOP_tiles(tileDir = tileDir[i], outFileName = outNames[i], clipExtent=clipExtent)
  }
