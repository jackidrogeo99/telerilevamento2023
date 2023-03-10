# My first code in GitHub
# Let's install the raster package

install.packages("raster") #Si usano le "" perchè si esce da R

library(raster) 
# Import data, setting the working directory
setwd("C:/Telerilevamento Geoecologico/Lab/") #Windows

l2011<-brick("p224r63_2011_masked.grd")
# Plotting the data in a savage manner
plot(l2011)
cl<-colorRampPalette(c("red", "orange", "yellow"))(100) # I colori tra "" perchè così sono immagazzinati su R. 100 sono le sfumature
plot(l2011, col=cl)
# Plotting one el
nir<-l2011[[4]] # or: nir<-l2011$B4_sre
plot(nir, col=cl) 
