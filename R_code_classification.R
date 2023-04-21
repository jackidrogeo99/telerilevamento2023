# Classification of remote sensing data via RStoolbox
library(raster)
setwd("C:/Telerilevamento_Geoecologico/Lab/")
so<-brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
plotRGB(so, 1, 2, 3, stretch="lin")
plotRGB(so, 1, 2, 3, stretch="hist")

# Classifying the solar data
# 1. Get all the single values
singlenr<-getValues(so) 
singlenr
set.seed(99)

#2. Classify 
kcluster<-kmeans(singlenr, centers=3) # Calcola la distanza tra i px, la min è giusta, ma i calcoli sarebbero n*(n-1)
#Allora calcola il centroide permettendo una classificazione 
kcluster

#3. Set values to a raster on the basis of so
#setValues riassocia i val delle classi ai singoli px
soclass<-setValues(so[[1]],kcluster$cluster) #Assign new values to a raster object

cl <- colorRampPalette(c('yellow','black','red'))(100)
plot(soclass, col=cl)

#I punti con lo stesso colore hanno la stessa riflettanza
#Il viola indica la zona urbana
#La classificaz in classi serve per calcolare la freq delle varie classi 

# Gran Canyon exercise: salvare l'immagine su lab
gc<-brick("dolansprings_oli_2013088_canyon_lrg.jpg")
gc
plotRGB(gc,1,2,3,stretch="lin") # rosso = 1, verde = 2, blu = 3
# Change the stretch to histogram stretching
plotRGB(gc, r=1, g=2, b=3, stretch="hist")

#Si può fare il ritaglio di un'immagine e ridurre le sue dim
#La f che ritaglia l'immagine è crop() 
#The image is quite big, let's crop it! 
gcc<-crop(gc, drawExtent()) #Entrerà nell'immagine per disegnare un rettangolo 
	#cliccando in alto a sx e poi in basso a dx
ncell(gc) #Restituisce il n di px dell'immagine
ncell(gcc) 

# Classification
singlenr<-getValues(gcc)
kcluster<-kmeans(singlenr, centers=3) #centers calcola il n di centroidi --> Il n di classi
kcluster #Associa per ogni val una classe, ovvero una seq di 1,2,3
gcclass<-setValues(gcc[[1]],kcluster$cluster) 
gcclass
plot(gcclass) 
#Class 1: volcanic rocks
#Class 2: sandstones
#Class 3: conglomerates 
#Calcolo freq
frequencies <-freq(gcclass) 
frequencies 
total=ncell(gcclass) 
total 
percentages<-frequencies*100/total 
percentages 
install.packages("ggplot2") 
library(ggplot2) 





