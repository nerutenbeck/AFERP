##################################
###
### Analysis of saplings, AFERP
### Nathan E. Rutenbeck, 
###
##################################

library(reshape)
library(doBy)
library(akima)
library(vegan)
library(car)
library(mgcv)
library(ggplot2)

saplings<-read.table("Saplings.txt",sep="\t",header=T) # Read data in
plots<-read.table("Plots.txt",sep='\t',header=T)
ra<-read.table("RA.txt",sep='\t',header=T)

saplings<-merge(saplings,plots,by=c('RA','PLOT'))
saplings<-merge(saplings,ra,by='RA')

str(saplings) # Examine structre of data frame
summary(saplings) # Look at distribution, etc.

# Recode factors

saplings$RA<-factor(saplings$RA)
# saplings$DATE<-as.POSIXct(saplings$DATE,format="%d/%m/%Y") # Don't know why this doesn't work 
saplings$S.<-factor(saplings$S.)
#saplings$INV<-factor(saplings$INV)
saplings$NT.MT<-factor(saplings$NT.MT)
saplings$TREE_CODE<-factor(saplings$TREE_CODE)
saplings$GAP<-factor(saplings$GAP)
#saplings$COND<-factor(saplings$COND)
saplings$CC<-factor(saplings$CC)
saplings$ST<-factor(saplings$ST)
saplings$LI<-factor(saplings$LI)
saplings$TREE_CODE<-recode(saplings$TREE_CODE,"c('ABBU','ABBA')='ABBA'")

str(saplings)

sap<-saplings[,-c(3,4,7,10,14:16,20,21)] # Create new object for contingency tables
sap$COND[is.na(sap$COND)]<-0
sap<-sap[sap$COND<7&sap$COND>-1,] # Remove harvested, missing, dead trees
sap$COND<-factor(sap$COND) # Refactor condition

sap<-sap[sap$TREE_CODE!='???',] # Remove unknown species
sap$TREE_CODE<-factor(sap$TREE_CODE)
sap$RA_PLOT<-with(sap,interaction(RA,PLOT))

# Split dataframe by treatment

sap.fs<-sap[sap$Treatment=="FS",] # split dataframe by treatment
sap.gs<-sap[sap$Treatment=="GS",]
sap.c<-sap[sap$Treatment=="C",]

###################################################
#
# Build contingency tables for each sample period
#
###################################################

contin.table=function(data){
  data.i<-with(data,table(RA_PLOT,TREE_CODE)) # make contingency table
  data.i<-data.i[apply(data.i,1,sum)>0,] # remove zero rows
  data.i<-data.i[,apply(data.i,2,sum)>0] # remove zero columns
  return(data.i)}

# Ply contingency tables into lists

fs.contin<-dlply(sap.fs,.(INV),.fun=contin.table)
gs.contin<-dlply(sap.gs,.(INV),.fun=contin.table)
c.contin<-dlply(sap.c,.(INV),.fun=contin.table)

str(fs.contin)


###################################################
##
##  Detrended Correspondence Analysis
##
###################################################

fs.dca<-llply(fs.contin, .fun=decorana)
gs.dca<-llply(gs.contin,.fun=decorana)
c.dca<-llply(c.contin,.fun=decorana)

windows()
par(mfrow=c(2,2))
for(i in 1:4){
  plot(fs.dca[[i]],main = paste('Femelschlag', i),xlim=c(-4,4),ylim=c(-3,3))}

for(i in 1:4){
  plot(gs.dca[[i]],main= paste('Group Selection',i),xlim=c(-5,5),ylim=c(-2,2))
}

for(i in 1:4){
  plot(c.dca[[i]],main=paste('Control',i),xlim=c(-4,4),ylim=c(-5,5))
}

# Relative abundance



# Importance values (BA/total_BA)