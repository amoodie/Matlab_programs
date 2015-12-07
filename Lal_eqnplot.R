rm(list = ls())
def.par <- par(no.readonly = TRUE)

require(RNetCDF)

#### read in GEBCO ####
topo <- open.nc('/home/andrew/Dropbox/blog/Lal_eqn/app_GEBCO.nc')

z <- array(read.nc(topo)$z, dim=read.nc(topo)$dim)
z <- z[,rev(seq(ncol(z)))]
xran <- read.nc(topo)$x_range
yran <- read.nc(topo)$y_range
zran <- read.nc(topo)$z_range
lon <- seq(read.nc(topo)$x[1], read.nc(topo)$x[2], read.nc(topo)$spac[1])
lat <- seq(read.nc(topo)$y[1], read.nc(topo)$y[2], read.nc(topo)$spac[1])

#### apply Lal, 1991 equation ####
a <- matrix(nrow=10,ncol=2, data=c(0,10,20,30,40,50,60,70,80,90, 
                                   3.511,3.360,4.0607,4.994,5.594,6.054,5.994,5.994,5.994,5.994))
afun <- approxfun(a[,1], a[,2])
b <- matrix(nrow=10,ncol=2, data=c(0,10,20,30,40,50,60,70,80,90, 
                                   2.547,2.522,2.734,3.904,4.946,5.715,6.018,6.018,6.018,6.018))
bfun <- approxfun(b[,1], b[,2])
c <- matrix(nrow=10,ncol=2, data=c(0,10,20,30,40,50,60,70,80,90, 
                                   0.95125,1.0668,1.2673,0.9739,1.3817,1.6473,1.7045,1.7045,1.7045,1.7045))
cfun <- approxfun(c[,1], c[,2])
d <- matrix(nrow=10,ncol=2, data=c(0,10,20,30,40,50,60,70,80,90, 
                                   0.18608,0.18830,0.22529,0.42671,0.53176,0.68684,0.71184,0.71184,0.71184,0.71184))
dfun <- approxfun(d[,1], d[,2])

z_lo <- z
z_lo[z_lo <= 0] <- NA
q <- z_lo
for(ilat in 1:ncol(z_lo)){
  v_lat <- lat[ilat]
  q[ , ilat] <- afun(v_lat) + bfun(v_lat)*z_lo[ , ilat] + cfun(v_lat)*z_lo[ , ilat]^2 + dfun(v_lat)*z_lo[ , ilat]^3
}
# rm(z,z_lo)

#### plot #### 
# make palettes
ocean.pal <- colorRampPalette(
  c("#000000", "#000413", "#000728", "#002650", "#005E8C",
    "#0096C8", "#45BCBB", "#8AE2AE", "#BCF8B9", "#DBFBDC")
)

land.pal <- colorRampPalette(
  c("#467832", "#887438", "#B19D48", "#DBC758", "#FAE769",
    "#FAEB7E", "#FCED93", "#FCF1A7", "#FCF6C1", "#FDFAE0")
)


prod.pal <- colorRampPalette(c("light green", "yellow", "orange", "red"))

zbreaks <- seq(-8000, 8000, by=10)
elev_cols <-c(ocean.pal(sum(zbreaks<=0)-1), land.pal(sum(zbreaks>0)))

prodbreaks <- seq(min(q, na.rm=T), max(q, na.rm=T), length.out=20)
prod_cols <-prod.pal(length(prodbreaks)-1)

par(mar=c(2,2,1,1), ps=10)
image(lon, lat, z=z, col=elev_cols, breaks=zbreaks, useRaster=TRUE)

image(lon, lat, z=q, col=prod_cols, breaks=prodbreaks, useRaster=TRUE)

