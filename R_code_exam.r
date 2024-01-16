# Fase 1: Installazione, importazione delle librerie e definizione del percorso

install.packages("ncdf4")
install.packages("viridis")
install.packages("jsonlite") # Libreria che legge i file .json (Water Level)
library(raster)
library(viridis)
library(ggplot2)
library(ncdf4) # Libreria che legge i file .nc (tutti gli altri)
library(jsonlite)

setwd("C:/Telerilevamento_Geoecologico/Progetto/")

# Fase 2: Importazione dell'immagine Landsat

L4<-brick("LC09_L1TP_192029_20230401_20230401_02_T1.jpg") # L4 contiene tutte le bande spettrali nel file .jpg
		# In questo modo è possibile utilizzare la funzione plotRGB() per visualizzare l'immagine
plotRGB(L4, r=1, g=2, b=3, stretch="lin") # Immagine Landsat dell'1/04/2023: da notare come la neve (in azzurro)
		# sia praticamente assente

# Ritaglio immagine con zoom in Appennino 
ext<-c(400,2300,1580,3100) 
L4.crop<-crop(L4, ext) # Ritaglia il raster in base all'estensione ext. Utilizzare le coordinate è molto meglio
plotRGB(L4.crop, r=1, g=2, b=3, stretch="lin") 

L5<-brick("LC08_L1TP_192029_20230527_20230603_02_T1.jpg") 
plotRGB(L5, r=1, g=2, b=3, stretch="lin") # Immagine Landsat del 27/05/2023

# Ritaglio immagine nell'area alluvionata
ext<-c(3500,5250,3300,4300)  
L5.crop<-crop(L5, ext)

# Fase 3: Classificazione per studiare l'area coperta dall'acqua 
	# A) Get all the single values
singlenr<-getValues(L5.crop) # Estrae i valori delle celle del raster L5 per accedervi
set.seed(90) # Generatore di numeri pseudocasuali

	# B) Classify 
kcluster<-kmeans(singlenr, centers=3) # Raggruppa le osservazioni in 3 cluster calcolando la somma dei quadrati 
		# delle distanze tra i px

	# C) Set values to a raster on the basis of L5
L5class<-setValues(L5.crop[[1]],kcluster$cluster) # Riassocia i nuovi valori dei cluster (1, 2, 3) ai singoli px

cl <- colorRampPalette(c('cyan','black','red'))(100) # 100 sono le sfumature
par(mfrow=c(1,2))
plotRGB(L5.crop, r=1, g=2, b=3, stretch="lin") 
plot(L5class, col=cl)
par(mfrow=c(1,1))  # Ripristina le posizioni grafiche predefinite

# Calcolo frequenze per studiare l'area allagata
frequencies <-freq(L5class)
total=ncell(L5class) 
percentages<-frequencies*100/total 
percentages # ca il 7% dell'area ritagliata dall'immagine L5 è alluvionata

# Tabella con 2 colonne e 3 righe con titolo coperture, valori con la f data.frame()
coperture<-c("Acqua", "Nuvole", "Suolo")
valori<-c(percentages[1,2], percentages[2,2], percentages[3,2]) # Nella 2° colonna si trovano le 3 percentuali
tab<-data.frame(coperture, valori)
View(tab)

# Fase 4: Plot delle immagini intere e ritagliate

#	A) Land Surface Temperature (LST): global 10-daily Thermal Condition Index (TCI)
TCI<-raster("c_gls_LST10-TCI_202305010000_GLOBE_GEO_V2.1.2.nc")
TCI # circa 29 mln di px
ext<-c(9,13,43.5,45.5) # Min/Max long vs Min/Max lat (Italia settentrionale)
TCI.crop<-crop(TCI, ext) 

TCI21<-raster("c_gls_LST10-TCI_202305210000_GLOBE_GEO_V2.1.2.nc") 
TCI21.crop<-crop(TCI21, ext)
cl<-colorRampPalette(c("green", "white", "brown"))(100) 

# Per plottare più immagini in una stessa finestra grafica si utilizza il MULTIFRAME, che dispone in righe e colonne i grafici
par(mfrow=c(1,2)) # Apre una nuova finestra grafica con spazi riempiti successivamente dai plot (1 riga e 2 colonne)
plot(TCI.crop, col=cl) # Immagine dell'1/05/2023 prima dell'alluvione.
plot(TCI21.crop, col=cl) # Immagine del 21/05/2023 durante l'alluvione
mtext("TCI 1/05/2023 vs TCI 21/05/2023") # Titolo sopra l'intera finestra grafica

# Differenza LST 21/05 vs 1/05
par(mfrow=c(1,1))
I1<-"c_gls_LST10-TCI_202305010000_GLOBE_GEO_V2.1.2.nc"
I21<-"c_gls_LST10-TCI_202305210000_GLOBE_GEO_V2.1.2.nc"
Tnv<-"MEDIAN" # Temperatura superficiale del suolo mediana calcolata nei 10 gg di misuraz
M1<-brick(I1, varname=Tnv) # varname è utilizzato per specificare manualmente il nome della variabile associata alle bande raster. 
M21<-brick(I21, varname=Tnv)
cl_diff<-colorRampPalette(c("white", "orange", "red"))(1000)
M_diff<-M21-M1
M_diff.crop<-crop(M_diff, ext)
plot(M_diff.crop, col=cl_diff, main="Differenza LST mediana 21/05 vs 1/05") # L'argomento main permette di inserire il titolo alla mappa

#	B) Soil Water Index (SWI) 
I4<-"c_gls_SWI1km_202304301200_CEURO_SCATSAR_V1.0.2.nc"
nv="SWI_002" # Umidità del suolo a 2 cm di profondità
SWI4<-brick(I4, varname=nv) 
SWI4.crop<-crop(SWI4, ext) 
cl<-colorRampPalette(c("brown", "green", "cyan"))(100) 

I5<-"c_gls_SWI1km_202305311200_CEURO_SCATSAR_V1.0.2.nc"
SWI5<-brick(I5, varname=nv) 
SWI5.crop<-crop(SWI5, ext) 

par(mfrow=c(1,2))
plot(SWI4.crop, col=cl, main="SWI 30/04/2023") # Immagine del 30/04/2023 prima dell'alluvione
plot(SWI5.crop, col=cl, main="SWI 31/05/2023") # Immagine del 31/05/2023 dopo l'alluvione
mtext("SWI 30/04/2023 vs SWI 31/05/2023")

# Differenza tra le due immagini
par(mfrow=c(1,1))
cl_diff<-colorRampPalette(c("brown", "white", "blue"))(100)
SWI_diff<-SWI5.crop-SWI4.crop
plot(SWI_diff, col=cl_diff, main="Differenza tra le due immagini")

#	C) Surface Soil Moisture (SSM)
SSM4<-raster("c_gls_SSM1km_202304290000_CEURO_S1CSAR_V1.2.1.nc") # Immagine del 29/04/2023  
SSM4.crop<-crop(SSM4, ext)

SSM4d<-as.data.frame(SSM4, xy=T) 
SSM4.crop_d<-as.data.frame(SSM4.crop, xy=T) # T=True
names(SSM4.crop_d)

SSM5<-raster("c_gls_SSM1km_202305230000_CEURO_S1CSAR_V1.2.1.nc") # Immagine del 23/05/2023
SSM5.crop<-crop(SSM5, ext)

SSM5d<-as.data.frame(SSM5, xy=T)
SSM5.crop_d<-as.data.frame(SSM5.crop, xy=T) 

# With magma
ggplot()+geom_raster(SSM4.crop_d, mapping=aes(x=x, y=y, fill=Surface.Soil.Moisture))+
  ggtitle("Surface Soil Moisture 29/04/23")+scale_fill_viridis(option="magma")
ggplot()+geom_raster(SSM5.crop_d, mapping=aes(x=x, y=y, fill=Surface.Soil.Moisture))+
  ggtitle("Surface Soil Moisture 23/05/23")+scale_fill_viridis(option="magma")

# Differenza tra le due immagini
cl_diff<-colorRampPalette(c("blue", "white", "orange"))(100)
SSM_diff<-SSM5.crop-SSM4.crop
plot(SSM_diff, col=cl_diff, main="Differenza tra le due immagini")

# NO SCE nè SWE perchè vale solo per le aree di pianura e ha limitazioni per quelle di montagna

#	D) Water Level (WL)
# Il dataset è un file .json
WL<-fromJSON("c_gls_WL_202312171906_0000000112214_ALTI_V2.2.0.json") # Carica il file .json
WLd<-as.data.frame(WL, xy=T) 
names(WLd) 

# Per costruire l'idrogramma, i dati che mi servono sono il tempo (x=data.time) e il livello del pelo libero 
# (y=data.water_surface_height_above_reference_datum). Il nome del fiume viene inserito con ggtitle() ed è 
# la proprietà properties.river 
# geom_point() aggiunge i punti a dispersione all'idrogramma, mentre geom_line() aggiunge la polilinea.

ggplot(WLd, aes(x=data.time, y=data.water_surface_height_above_reference_datum))+geom_point()+geom_line()+
ggtitle(WLd$properties.river)
