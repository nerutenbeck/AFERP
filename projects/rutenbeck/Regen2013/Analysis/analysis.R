#################################################
##
##  Spatial Preparation, AFERP regeneration study
##  Nathan E. Rutenbeck
##  Summer 2013
##  
#################################################

library(rgdal)
library(rgeos)
library(spgrass6)

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

RAs.spdf<-readOGR(dsn='shp/layout',layer='RAs')
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

harvests.spdf<-readOGR(dsn='shp/layout',layer='Harvests')[,-6]
names(harvests.spdf)<-c('year','entry','perimeter','area','RA')

harvests.spdf@data$id<-rownames(harvests.spdf@data)
harvests.pts<-fortify(harvests.spdf,region='id')
harvests.df<-join(harvests.pts,harvests.spdf@data)
head(harvests.df)
names(harvests.df)


### Retention trees

# spatial locations
RTs.spdf<-readOGR(dsn='shp/layout',layer='Retention_trees')[,5:6]
names(RTs.spdf)

RTs.df<-cbind(coordinates(RTs.spdf),RTs.spdf@data,over(RTs.spdf,harvests.spdf))[,-10]
head(RTs.df)

# measurements
RT_inv<-read.table('RT_inventories.txt',header=T,sep='\t')
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

plots.spdf<-readOGR(dsn='.',layer='plots')
plots.df<-cbind(coordinates(plots.spdf),plots.spdf@data,over(plots.spdf,harvests.spdf))
names(plots.df)

### Selected sample gaps 
### (selected by numbering on paper maps for each RA, then random number generation in R)

smp_gaps<-readOGR(dsn='shp/regen_project',layer='sample_gaps')[,-6]
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


### Bring in regeneration data

regen<-read.table('trees.txt',sep='\t',header=T)
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


### Hierarchical clustering based on presence/absence

regen.mlt<-data.frame(unique(melt(regen,id='plot','spp')),pr=1)
head(regen.mlt)

pr.mat<-dcast(regen.mlt,plot~value,value.var='pr',fill=0)

rownames(pr.mat)<-pr.mat$plot
head(pr.mat)

pr_ab.dist<-dist(pr.mat[,2:length(pr.mat)], method='binary')

pr_ab.fit<-hclust(pr_ab.dist,method='complete')
plot(pr_ab.fit,main='Presence-Absence Clusters',xlab='Binary Distance, Complete Linkage')

rect.hclust(pr_ab.fit,k=4,border='red')

pr_ab.grps<-cutree(pr_ab.fit,k=4)

pr.mat$pr.grp<-pr_ab.grps

pr.mat[pr.mat$pr.grp==1,] # Maple - fir - pine?
pr.mat[pr.mat$pr.grp==2,] # Fir-hemlock
pr.mat[pr.mat$pr.grp==3,] # Pine-Spruce-Oak
pr.mat[pr.mat$pr.grp==4,] # Maple - hardwood - pine


head(plots.df)
plots.df<-join(plots.df,pr.mat[,c(1,length(pr.mat))])
head(plots.df)


#### Hierarchical clustering based on sum basal area/spp

ba.long<-ddply(regen,.(plot,spp),summarize,sum.ba=sum(ba))

head(ba.long)

ba.mat<-dcast(ba.long,plot~spp)

head(ba.mat)

ba.mat[is.na(ba.mat)]<-0
ba.dist<-dist(ba.mat[,2:length(ba.mat)])

ba.fit<-hclust(ba.dist,method='ward')
plot(ba.fit,xlab='Presence-Absence Distance')
rect.hclust(ba.fit,k=2,border='red')

ba.mat$ba.grp<-cutree(ba.fit,k=4)

ba.mat[ba.mat$ba.grp==1,] # Mostly empty?
ba.mat[ba.mat$ba.grp==2,] # Pine - Fir

plots.df<-join(plots.df,ba.mat[,c(1,length(ba.mat))])
head(plots.df)


#### Hierarchical clustering based on all measured heights

ht.mlt<-melt(regen,id=c('plot','spp','sppnum'),measure.var='top_ht')

head(ht.mlt)

ht.cst<-dcast(ht.mlt,plot~spp+sppnum,value.var='value')
head(ht.cst)
ht.cst[is.na(ht.cst)]<-0
ht.dist<-dist(ht.cst[,2:length(ht.cst)])
ht.fit<-hclust(ht.dist,method='ward')

plot(ht.fit)
rect.hclust(ht.fit,k=3,border='red')

ht.cst$ht.grp<-cutree(ht.fit,k=3)
ht.cst$ht.grp

ht.cst[ht.cst$ht.grp==1,] # Pine-hardwood?
ht.cst[ht.cst$ht.grp==2,] # Fir-maple-pine?
ht.cst[ht.cst$ht.grp==3,] # Maple-fir

plots.sv<-plots.df
plots.df<-plots.sv


plots.df<-join(plots.df,ht.cst[,c(1,length(ht.cst))])
head(plots.df)

plots.df$ht.grp

regen2<-merge(na.omit(unique(plots.df)),regen)
head(regen2)
summary(regen2)

qplot(data=regen2,y=top_ht,x=spp,geom='point')+facet_wrap(~pr.grp)+ggtitle('Presence-Absence Clusters')
qplot(data=regen2,x=top_ht,y=spp)+facet_wrap(~ba.grp)+ggtitle('Basal Area Clusters')
qplot(data=regen2,x=top_ht,y=spp)+facet_wrap(~ht.grp)+
  ggtitle('Height Clusters')+
  xlab('top height (cm)')
qplot(data=regen2[regen2$ht.grp==1,],x=top_ht)+facet_wrap(~spp)+ggtitle('Height Cluster 1')
qplot(data=regen2[regen2$ht.grp==2,],x=top_ht)+facet_wrap(~spp)+ggtitle('Height Cluster 2')
qplot(data=regen2[regen2$ht.grp==3,],x=top_ht)+facet_wrap(~spp)+ggtitle('Height Cluster 3')


tmp<-ddply(regen2,.(plot,spp),summarize,
           top_ht=max(top_ht))
head(tmp)
tmp2<-ddply(tmp,.(plot),summarize,top_ht=max(top_ht))
head(tmp2)
tallest<-merge(tmp,tmp2)
head(tallest)

tall.tab<-(as.data.frame(table(tallest$spp)))
colnames(tall.tab)<-c('Species','Frequency')

for (i in 1:nrow(tall.tab)){
  tall.tab$Percent[i]<-tall.tab$Frequency[i]/sum(tall.tab$Frequency)
}

tall.tab<-orderBy(data=tall.tab,~-Frequency)

tall.tab

tall.tab$Species<-factor(tall.tab$Species,
                         levels=tall.tab$Species)

tall.tab

ggplot(tall.tab[tall.tab$Freq>0,],
       aes(x=Species,y=Frequency))+
  geom_bar(stat='identity')+
  ggtitle('Frequency of Tallest Tree')




#### Models to predict clusters
names(RAs.df)
plots.sv<-plots.df
plots.df<-plots.sv

plots.df<-unique(join(plots.df,RAs.df[,c(8,11)]))
head(plots.df)

# Linear discriminant analysis

fm1<-lda(ht.grp~area+entry+RT.BA,data=plots.df,na.action='na.omit')
summary(fm1)
fm1

ct<-table(na.omit(plots.df$ht.grp),predict(fm1)$class)
prop.table(ct,1)
diag(prop.table(ct, 1)) # percent correct for each cluster
sum(diag(prop.table(ct))) # percent correct overall

fm2<-multinom(ht.grp~trt+area+entry+RT.BA,data=plots.df)
fm2

str(fm2)

predict(fm2)
ct2<-table(na.omit(plots.df$ht.gr),predict(fm2))
prop.table(ct2,1)
diag(prop.table(ct2))
error<-1-sum(diag(prop.table(ct2))) # percent incorrect overall
error