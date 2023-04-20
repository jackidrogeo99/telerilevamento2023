# Classification of remote sensing data via RStoolbox
library(raster)
setwd("C:/Telerilevamento_Geoecologico/Lab/")
so<-brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
plotRGB(so, 1, 2, 3, stretch="lin")
plotRGB(so, 1, 2, 3, stretch="hist")

#... Venerdì 14/4

# 1. Get value 
singlenr<-getValues(gc) 
singlenr
#2. Classify 
kcluster<-kmeans(singlenr, centers=3) # Calcola la distanza tra i px, la min è giusta, ma i calcoli sarebbero n*(n-1)
#Allora calcola il centroide permettendo una classificazione 
kcluster
#3.
#I punti con lo stesso colore hanno la stessa riflettanza
#Il viola indica la zona urbana
#La classificaz in classi serve per calcolare la freq delle varie classi 

# Gran Canyon exercise: salvare l'immagine su lab
gc<-brick("dolansprings_oli_2013088_canyon_lrg.jpg")
gc
plotRGB(gc,1,2,3,stretch="lin")
#Si può fare il ritaglio di un'immagine e di ridurre le dim
#La f che ritaglia l'immagine è crop() 
#The image is quite big, let's crop it! 
gcc<-crop(gc, drawExtent()) #Entrerà nell'immagine per disegnare un rettangolo 
	#cliccando in alto a sx e poi in basso a dx
ncell(gc) #Restituisce il n di px dell'immagine
ncell(gcc) 
singlenr<-getValues(gcc)
kcluster<-kmeans(singlenr, centers=3) #centers calcola il n di centroidi

