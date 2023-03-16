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
# Exercise: change the color gamut for all the images by choosing at least 5 colors
cl<-colorRampPalette(c("chartreuse", "azure", "darkgoldenrod1", "darkred"))(100)
plot(l2011,col=cl)
# Exercise: plot the near band: B1=blue, B2=green, B3=red, B4=NIR
plot(nir, col=cl) #plot(l2011[[4]], col=cl)=plot(l2011$B4_sre, col=cl) Il $ è il simbolo che lega dei pezzi tra loro: in questo caso lega l'immagine alla singola banda. 
dev.off() # It closes the graphs

#Export graphs in R
pdf("Myfirstgraph.pdf")
plot(l2011$B4_sre, col=cl)
dev.off()

# Plotting several bands in a multiframe
par(mfrow=c(2,1))
plot(l2011[[3]], col=cl)
plot(l2011[[4]], col=cl)
dev.off()
# Plotting the first 4 layers
par(mfrowc(2,2))

#Blue
clb<-colorRampPalette(c("blue4", "blue2", "lightblue"))(100)
plot(l2011[[1]], col=clb)

#Green
clg<-colorRampPalette(c("chartreuse", "chartreuse2", "chartreuse"))(100)
plot(l2011[[2]], col=clg)

#Red
clr<-colorRampPalette(c("coral3", "coral1", "coral"))(100)
plot(l2011[[3]], col=clr)

#NIR
clN1<-colorRampPalette(c("darkorchid4", "darkorchid2", "darkorchid"))(100)
plot(l2011[[4]],col=clN1)





















