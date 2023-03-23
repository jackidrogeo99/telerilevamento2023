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

# Day #3

# Plot of l2011 in the NIR channel (NIR band)
clnir <- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(l2011$B4_sre, col=clnir)
# or:
plot(l2011[[4]])

# Landsat ETM+
# b1 = blu
# b2 = verde
# b3 = rosso
# b4 = infrarosso vicino NIR

# plot RGB layers
plotRGB(l2011, r=3, g=2, b=1, stretch="lin") #stretch riscala i val per visualizzare ancora meglio l'immagine satellitare, lin secondo una rel lineare
plotRGB(l2011, r=3, g=4, b=2, stretch="lin")
plotRGB(l2011, r=3, g=2, b=4, stretch="lin")

plotRGB(l2011, r=3, g=4, b=2, stretch="hist") #hist riscala i val in modo che aumenti vertiginosam all'inizio mentre alla fine l'aum è molto più lim, per cui il 
  #contrasto è molto più importante

# Exercise: build a multiframe with visible RGB
# (linear stretch) on top of false colours
# (histogram stretch)
par(mfrow=c(2,1)) #mf=multiframe,tipo subplot in python
plotRGB(l2011, r=3, g=2, b=1, stretch="lin")
plotRGB(l2011, r=3, g=4, b=2, stretch="hist")

#Exercise: plot the NIR band
plot(l2011[[4]])
plotRGB(l2011, r=3, g=2, b=1, stretch="lin")
plotRGB(l2011, r=4, g=3, b=2, stretch="lin") #NIR
plotRGB(l2011, r=3, g=4, b=2, stretch="lin")
plotRGB(l2011, r=3, g=2, b=4, stretch="lin")

# Exercise: upload the image from 1988
l1988 <- brick("p224r63_1988_masked.grd")
l1988

par(mfrow=c(2,1))
plotRGB(l1988, r=4, g=3, b=2, stretch="lin")
plotRGB(l2011, r=4, g=3, b=2, stretch="lin")

#Exercise: plot in RGB space (natural colours)
plotRGB(l1988, r=3, g=2, b=1, stretch="lin")
plotRGB(l1988, r=4, g=3, b=2, stretch="lin") #plot(l1988, 4,3,2, stretch="lin")

#Multiframe
par(mfrow=c(2,1)) #Apre un nuovo plot grafico con 2 spazi per poi mettere le immagini successivam
plotRGB(l1988, 4,3,2, stretch="lin")
plotRGB(l2011, 4,3,2, stretch="lin")
dev.off()

plotRGB(l2011, 4,3,2, stretch="hist")

#Exercise
par(mfrow=c(2,2)) 
plotRGB(l1988, 4,3,2, stretch="lin")
plotRGB(l2011, 4,3,2, stretch="lin")
plotRGB(l1988, 4,3,2, stretch="hist")
plotRGB(l2011, 4,3,2, stretch="hist")













