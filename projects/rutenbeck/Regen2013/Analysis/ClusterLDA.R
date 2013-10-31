source('DataPrep.R')

### Hierarchical clustering based on presence/absence

regen.mlt<-data.frame(unique(melt(regen,id='plot','spp')),pr=1)
head(regen.mlt)
summary(regen.mlt)
pr.mat<-dcast(regen.mlt,plot~value,value.var='pr',fill=0)
pr.mat<-pr.mat[-c(1,6,121),]
row.names(pr.mat)<-pr.mat$plot

head(pr.mat)

pr_ab.dist<-dist(pr.mat[,2:length(pr.mat)], method='binary')

pr_ab.fit<-hclust(pr_ab.dist,method='complete')
plot(pr_ab.fit,main='Presence-Absence Clusters',xlab='Binary Distance, Complete Linkage')

rect.hclust(pr_ab.fit,k=6,border='red')

pr_ab.grps<-cutree(pr_ab.fit,k=6)

pr.mat$pr.grp<-pr_ab.grps

pr.mat[pr.mat$pr.grp==1,] # Maple - fir - pine?
pr.mat[pr.mat$pr.grp==2,] # Fir-hemlock
pr.mat[pr.mat$pr.grp==3,] # Pine-Spruce-Oak
pr.mat[pr.mat$pr.grp==4,] # Maple - hardwood - pine
pr.mat[pr.mat$pr.grp==5,] # Maple - hardwood - pine
pr.mat[pr.mat$pr.grp==6,] # Maple - hardwood - pine


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
rect.hclust(ba.fit,k=3,border='red')

ba.mat$ba.grp<-cutree(ba.fit,k=4)

ba.mat[ba.mat$ba.grp==1,] # Mostly empty?
ba.mat[ba.mat$ba.grp==2,] # Fir- Pine mixtures
ba.mat[ba.mat$ba.grp==3,] # Fir mixtures (no pine)

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
rect.hclust(ht.fit,k=4,border='red')

ht.cst$ht.grp<-cutree(ht.fit,k=4)
ht.cst$ht.grp

ht.cst[ht.cst$ht.grp==1,] # Pine-hardwood?
ht.cst[ht.cst$ht.grp==2,] # Fir-maple-pine?
ht.cst[ht.cst$ht.grp==3,] # Maple-fir
ht.cst[ht.cst$ht.grp==4,] # Maple-fir

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
pdf('hclust.pdf')
qplot(data=regen2[regen2$ht.grp==1,],x=top_ht)+facet_wrap(~spp)+ggtitle('Height Cluster 1')
qplot(data=regen2[regen2$ht.grp==2,],x=top_ht)+facet_wrap(~spp)+ggtitle('Height Cluster 2')
qplot(data=regen2[regen2$ht.grp==3,],x=top_ht)+facet_wrap(~spp)+ggtitle('Height Cluster 3')
qplot(data=regen2[regen2$ht.grp==4,],x=top_ht)+facet_wrap(~spp)+ggtitle('Height Cluster 4')
dev.off()

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
pdf('tallest.pdf',width=10)
ggplot(tall.tab[tall.tab$Freq>0,],
       aes(x=Species,y=Frequency))+
  geom_bar(stat='identity')+
  ggtitle('Frequency of Tallest Tree')
dev.off()



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

# Multinomial logistic regression

fm2<-multinom(ht.grp~trt+area+entry+RT.BA,data=plots.df)
fm2

str(fm2)

predict(fm2)
ct2<-table(na.omit(plots.df$ht.gr),predict(fm2))
prop.table(ct2,1)
diag(prop.table(ct2))
error<-1-sum(diag(prop.table(ct2))) # percent incorrect overall
error