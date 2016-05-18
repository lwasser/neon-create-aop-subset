
# load r packages
library(raster)

# identify directory where data are located

aDir <- file.path("Y:","IndexConversionOutput", "D17","TEAK","2013","TEAK_L2","TEAK_Spectrometer","Veg_Indices")

outputDir <- file.path("H:","1_Teakettle","veg-indices")

# get just the files that are geotiffs
list.files(aDir, 
           pattern = ".tif",
           full.names = TRUE)
