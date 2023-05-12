# R code for downloading and visualising Copernicus data
library(raster)
install.packages("ncdf4") # Serve per leggere i dati .nc
library(ncdf4)
setwd("C:/Telerilevamento_Geoecologico/Lab/")
# dataset: c_gls_SSM1km_202305030000_CEURO_S1CSAR_V1.2.1.nc
sc<-raster("c_gls_SSM1km_202305030000_CEURO_S1CSAR_V1.2.1.nc")




