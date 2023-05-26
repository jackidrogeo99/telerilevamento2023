# R code for downloading and visualising Copernicus data
library(raster)
install.packages("ncdf4") # Serve per leggere i dati .nc
library(ncdf4)
setwd("C:/Telerilevamento_Geoecologico/Lab/")
# dataset: c_gls_SSM1km_202305030000_CEURO_S1CSAR_V1.2.1.nc
sc<-raster("c_gls_SSM1km_202305030000_CEURO_S1CSAR_V1.2.1.nc")
sc # ca 28 mln di px

# With the raster package --> RasterLayer
plot(sc) # Il sensore che rileva l'umidità del suolo fa delle strisciate

scd<-as.data.frame(sc, xy=T) # Trasforma il dato sc in un dataframe (dato 
  # continuo tabellare)
head(scd) # Fa vedere solo i primi 6 px di dati

ggplot() + geom_raster(scd, mapping=aes(x=x, y=y, fill=Surface.Soil.Moisture))+
  ggtitle("Soil Moisture from Copernicus")
# ggplot() crea solo una finestra vuota, geom_raster() ritrasforma il dataframe 
# in un raster
# dev.off()

# Cropping an image
ext<-c(12,25,42,45) # Min/Max lat vs Min/Max longitudine
sc.crop<-crop(sc, ext) # x e y sono le coordinate su cui si vuole fare il 
  # ritaglio. Utilizzando le coordinate è molto meglio
plot(sc.crop)

# Exercise: plot via ggplot the cropped image
sc.crop_d<-as.data.frame(sc.crop, xy=T) # T=True
head(sc.crop_d)
names(sc.crop_d)
# With magma
ggplot()+geom_raster(sc.crop_d, mapping=aes(x=x, y=y, 
                                            fill=Surface.Soil.Moisture))+
  ggtitle("Cropped Soil Moisture")+scale_fill_viridis(option="magma")

# source() legge direttam il codice dall'esterno
source("Copernicus.txt")



