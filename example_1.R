library(terra)
###########################################
##Load the raster files
path_shape<-"mendoza_basin.shp"
shapefile<-vect(path_shape)
plot(shapefile, main="Mendoza river basin")#

############################################
##Read a raster file
path_rast<-"dem_mendoza.tif"
dem<-rast(path_rast)
plot(dem)
lines(shapefile)
############################################
##Cropping and masking the raster to our shape 
cropped_dem<-crop(dem,shapefile)
plot(cropped_dem)
lines(shapefile)
##Crop subset the raster to the same extend of the shapefile
##To clean up the rest of the tiff we need to use the mask 
masked_dem<-mask(cropped_dem,shapefile)
plot(masked_dem)
lines(shapefile)
############################################
##The main advantage to a gis approach is that 
##This same process can be done in batches for 
##big data sets, lets go to the next example
##Load the chirps annual netcdf files
path_to_chirps<-"chirps-v2.0.annual.nc"
chirps<-rast(path_to_chirps)
plot(chirps)
plot(chirps[[1]])
############################################
##LEts crop the whole dataset for our shapefile 
c_chirps<-crop(chirps,shapefile)
##Lets check the extends 
plot(c_chirps[[1]])
lines(shapefile)
##Now mask them
m_chirps<-mask(c_chirps,shapefile)
plot(m_chirps[[1]])
lines(shapefile)
##Mean annual precipitation for the whole period (1981-2023)
mean_annual_prec<-mean(m_chirps)
max_annual_prec<-max(m_chirps)
min_annual_prec<-min(m_chirps)

plot(mean_annual_prec)
lines(shapefile)

plot(max_annual_prec)
lines(shapefile)


plot(min_annual_prec)
lines(shapefile)
########################################
##To extract the average values from the shapefile
##we can use

prec_timeseries<-extract(m_chirps,shapefile,fun="mean",ID=F)
###T is the transpose of the vector for time series 
prec_timeseries<-t(prec_timeseries)
plot(t(prec_timeseries),type="l")
##Now lets create some dates for this 
years<-seq(from="1981",to="2022",by=1)
df<-data.frame(years,prec_timeseries[2:43])
plot(df,type="l")


