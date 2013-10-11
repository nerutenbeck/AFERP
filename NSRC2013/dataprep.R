library(plyr)
library(reshape2)
library(doBy)
library(ggplot2)

OSinv<-read.table('./data/OSinv.txt',sep='\t',head=T)
OStrees<-read.table('./data/OStrees.txt',sep='\t',head=T)
SAPinv<-read.table('./data/SAPinv.txt',sep='\t',head=T)
SAPtrees<-read.table('./data/SAPtrees.txt',sep='\t',head=T)
RTinv<-read.table('./data/RTinv.txt',sep='\t',head=T)
RTtrees<-read.table('./data/RTtrees.txt',sep='\t',head=T)
head(OSinv)
head(OStrees)

names(OSinv)[c(5,6)]<-c('TREENUM','SPP') # Change names
names(OStrees)[c(1,4,5)]<-c('UID','TREENUM','SPP') # change name

OS.cl<-OSinv[,c(1,2,5:7,9:10)]
OS.cl$BA<-(((OS.cl$DBH/2)*pi)^2)/10000 # Convert DBH to BA (m2)
head(OS.cl)

OS<-merge(OStrees[,c(1:4)],OS.cl,by=c('RA','PLOT','TREENUM'))
OS<-orderBy(~RA+PLOT+TREENUM+INV,data=OS)
OS<-OS[complete.cases(OS),]
head(OS,200)

plotBAs<-ddply(OS,.(RA,PLOT,INV),summarize,
               BA=sum(BA))

head(plotBAs)


RABAs<-ddply(plotBAs,.(RA,INV),summarize,
             BA=sum(BA/length(PLOT))*20)
RABAs


ggplot(RABAs,aes(x=INV,y=BA))+geom_area()+facet_wrap(~RA)

head(SAPinv)
head(SAPtrees)
names(SAPinv)[c(5,8)]<-c('SNUM','SPP')
names(SAPtrees)[3:4]<-c('SNUM','SPP')

sap<-merge(SAPinv[,c(1:2,5,6,8,9)],SAPtrees[,c(1:3)],by=c('RA','PLOT','SNUM'))
head(sap)

sap<-sap[complete.cases(sap),]

sap$BA<-((pi*sap$DBH/2)^2)/10000


RAsapBAs<-ddply(sap,.(RA,INV),summarize,
                  BA=sum(BA/length(PLOT))*100)

str(RAsapBAs)
str(RABAs)
RAsapBAs$source<-'saplings'
RABAs$source<-'overstory'


ggplot(RAsapBAs,aes(x=INV,y=BA))+geom_area()+facet_wrap(~RA)

pdf('BAtime_RAs.pdf',width=10)
ggplot(RABAs,aes(x=INV,y=BA,color=source))+geom_area()+facet_wrap(~RA)+
  ylab(expression(''*m^2*'/HA'))+
  xlab('Inventory')
dev.off()

path<-'g:/documents/research/AFERP/projects/rutenbeck/Regen2013/Analysis/Data/shp/layout'

RAs.spdf<-readOGR(dsn=path,layer='RAs')
names(RAs.spdf)<-c('trt','perimeter','area','RA')

RAs.spdf@data$id<-rownames(RAs.spdf@data)

RAs.pts<- fortify(RAs.spdf,region='id')
RAs.df<-join(RAs.pts,RAs.spdf@data)
ggplot(RAs.df,aes(long,lat,group=group,fill=factor(RA))) + 
  geom_polygon() +
  geom_path(color="white") +
  coord_equal()
head(RAs.df)

