# Classification of remote sensing data via RStoolbox
library(raster)
setwd("C:/Telerilevamento_Geoecologico/Lab/")
so<-brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
plotRGB(so, 1, 2, 3, stretch="lin")
