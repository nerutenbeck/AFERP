###################################################################
##
##  Project: AFERP Regeneration Composition Study: Data Prep
##  Author: Nathan E. Rutenbeck
##  Affiliation: Seymour Lab, University of Maine School of Forest Resources
##  Date: July-August 2013
##  
###################################################################

# Built under R Version 3.0.1

rm(list=ls())

library(rgdal)
library(rgeos)

library(doBy)
library(ggplot2)
library(plyr)
library(reshape2)
library(ggplot2)
library(cluster)
library(nnet)
library(mclust)


####### Read in ESRI Shapefiles to Spatial*DataFrame objects

### RA polygons

RAs.spdf<-readOGR(dsn='Data/shp/layout',layer='RAs')
names(RAs.spdf)<-c('trt','perimeter','area','RA')

RAs.spdf@data$id<-rownames(RAs.spdf@data)
RAs.pts<- fortify(RAs.spdf,region='id')
RAs.df<-join(RAs.pts,RAs.spdf@data)
ggplot(RAs.df,aes(long,lat,group=group,fill=factor(RA))) + 
  geom_polygon() +
  geom_path(color="white") +
  coord_equal()
head(RAs.df)

### Harvest polygons

harvests.spdf<-readOGR(dsn='Data/shp/layout',layer='Harvests')[,-6]
names(harvests.spdf)<-c('year','entry','perimeter','area','RA')

harvests.spdf@data$id<-rownames(harvests.spdf@data)
harvests.pts<-fortify(harvests.spdf,region='id')
harvests.df<-join(harvests.pts,harvests.spdf@data)
head(harvests.df)
names(harvests.df)


### Retention trees

# spatial locations
RTs.spdf<-readOGR(dsn='Data/shp/layout',layer='Retention_trees')[,5:6]
names(RTs.spdf)

RTs.df<-cbind(coordinates(RTs.spdf),RTs.spdf@data,over(RTs.spdf,harvests.spdf))[,-10]
head(RTs.df)

# measurements
RT_inv<-read.table('./Data/RT_inventories.txt',header=T,sep='\t')
names(RT_inv)
names(RT_inv)[2]<-'RT'
RTs.df<-join(RTs.df,RT_inv,by=c('RA','RT'))
RTs.df$BA<-pi*((RTs.df$DBH/2)^2)
summary(RTs.df)


#### Regeneration sampling

### Method to define sample points - (should have used set.seed?)

# plots<-spsample(smp.gaps,type='regular',cellsize=14.14)
# 
# plots.spdf<-SpatialPointsDataFrame(plots,data.frame('plot'=c(1:290)))
# proj4string(plots.spdf)<-proj4string(harvests.spdf)
# writeOGR(plots.spdf,dsn='.',layer='plots',driver='ESRI Shapefile',overwrite_layer=T)

plots.spdf<-readOGR(dsn='./Data',layer='plots')
plots.df<-cbind(coordinates(plots.spdf),plots.spdf@data,over(plots.spdf,harvests.spdf))
names(plots.df)

### Selected sample gaps 
### (selected by numbering on paper maps for each RA, then random number generation in R)

smp_gaps<-readOGR(dsn='Data/shp/regen_project',layer='sample_gaps')[,-6]
names(smp_gaps)<-c('year','entry','perimeter','area','RA')
smp_gaps@data$id<-rownames(smp_gaps@data)
smp_gaps.pts<-fortify(smp_gaps,region='id')
smp_gaps.df<-join(smp_gaps.pts,smp_gaps@data)


### Function to display basemap of each RA

basemap<-function(research.area,inventory=4){
  ggplot()+
    geom_polygon(data=harvests.df[harvests.df$entry==0&
                                    harvests.df$RA==research.area,],
                 aes(long,lat,group=group,fill=factor(entry)))+
    geom_polygon(data=harvests.df[harvests.df$entry!=0&
                                    harvests.df$RA==research.area,],
                 aes(long,lat,group=group,fill=factor(entry)))+
    coord_equal()+
    geom_point(data=RTs.df[RTs.df$RA==research.area&RTs.df$INV==inventory,],
               aes(x=coords.x1,y=coords.x2,cex=DBH/100,color=TREE_CODE))+
    scale_fill_manual('Entry',values=c('#006633','#009933','#33CC66'))+
    geom_point(data=plots.df[plots.df$RA==research.area,],
               aes(x=coords.x1,y=coords.x2),pch=1,cex=2.54)+
    labs(fill='Entry',color='Species',cex='DBH m2')
}

basemap(1)
basemap(2)
basemap(5)
basemap(6)
basemap(7)
basemap(9)


RTs.df[RTs.df$RA==9 & RTs.df$coords.x1>531000,]$RA<-6 ##### Temporary fix for incorrect label
basemap(9)

### calculate RT BA per harvest polygon

names(RTs.df)

RT_sum_ba<-ddply(RTs.df,.(id,INV),summarize,RT.ba.m2=sum(BA)*0.0001)
head(RT_sum_ba)
RT_BA.mlt<-melt(RT_sum_ba,id=c('id','INV'))
RT_BA.cst<-dcast(data=RT_BA.mlt,id~INV+variable)[,c(1,5)]
head(RT_BA.cst)
names(RT_BA.cst)<-c('id','RT.BA')

harvests.df<-join(harvests.df,RT_BA.cst)
RT_BA.cst
basemap(1)

# Join RT information to sample plots

names(harvests.df)
names(plots.df)

plots.sv<-plots.df
plots.df<-plots.sv

names(harvests.df)

plots.df<-unique(join(plots.df,harvests.df[,8:13]))
head(plots.df)


#################################


### Bring in regeneration data

regen<-read.table('Data/trees.txt',sep='\t',header=T)
head(regen)
summary(regen)
regen<-orderBy(~plot+spp-top_ht,data=regen)

regen$spp[regen$spp=='PRPE']<-'PRSE'
regen$ba<-pi*(regen$dbh/2)^2
head(regen,100)

regen<-(ddply(regen,.(plot,spp),mutate,sppnum=1:length(spp))) 
head(regen)
summary(regen)


regen<-regen[regen$sppnum<5,] # Remove some duplicates

qplot(data=regen,x=top_ht,geom='histogram',binwidth=50)+
  facet_wrap(~spp)+xlab('height (cm)')
qplot(data=regen,x=ba,geom='histogram',binwidth=10)+facet_wrap(~spp)

