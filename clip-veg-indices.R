
# load r packages
library(raster)
library(rgdal)
library(rgeos)

# identify directory where data are located

aDir <- file.path("Y:","IndexConversionOutput", "D17","TEAK","2013","TEAK_L2","TEAK_Spectrometer","Veg_Indices")

outputDir <- file.path("H:","1_Teakettle","veg-indices")

# what site is being used
site="TEAK"

# get just the files that are geotiffs
veg.files <- list.files(aDir, 
           pattern = ".tif",
           full.names = TRUE)

# clipFile <- "teakettle_clip"
clipFile <- "teakettleClip_2"
# specify the path to the clip file
clipFilePath <- file.path("H:","1_Teakettle")

# import shapefile to spatial polygon
clipExtent <- readOGR(clipFilePath, clipFile)


# create a list of output filenames
outNames <- paste0(clipFilePath,"/TEAK/2013/spectrometer/veg_index/", basename(veg.files))


vi.crop.data <- function(aRasterFile, outFileName, clipExtent=clipExtent){
  print("just starting")
  # open raster
  aRaster <- raster(aRasterFile)
  print("opened raster")
  # crop raster to clip extent
  vi.crop <- crop(aRaster, clipExtent)
  print("cropped raster")

  # write geotiff
  writeRaster(vi.crop,
            filename=outFileName,
            format="GTiff",
            options="COMPRESS=LZW",
            overwrite = TRUE,
            NAflag = -9999)
}


# crop all data
mapply(vi.crop.data, 
       aRasterFile=veg.files,
       outFileName=outNames,
       clipExtent=clipExtent)

# for some reason mapply isn't working so writing a for loop

for(i in 1:length(veg.files)){
    vi.crop.data(aRasterFile = veg.files[i],
             clipExtent = clipExtent,
             outFileName = outNames[i]
              )}
