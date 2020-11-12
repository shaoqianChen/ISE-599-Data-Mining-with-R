# exercise2.r

# install.packages("cluster")
library(cluster)   # daisy()  clusplot()

d1 = read.csv('segment.csv')
str(d1)
head(d1)
summary(d1)
#
# function to find means by cluster
seg.summ = function(data,clusters)
  aggregate(data,list(clusters), function(x) mean(as.numeric(x)))

# hclust()
#
# Euclidian distances of numeric columns only
d2 = d1[,c('age','income','kids')]
d = dist(d2)
length(d)
head(d)
dd = as.matrix(d)
dim(dd)
# 
# daisy() to find distances even if columns are not numeric
#
d2 = daisy(d1)
class(d2)
head(d2)
as.matrix(d2)[1:7,1:7]
#
# dendrogram
#
seg.hc = hclust(d2,method='complete')
plot(seg.hc,cex=0.4)
# 
# cut at h=0.5
abline(h=0.5,col='red',lty=2)
cut(as.dendrogram(seg.hc),h=0.5)
#
# identigy the clusters
rect.hclust(seg.hc,k=5)
#
# plot first cluster
#
clusters = cut(as.dendrogram(seg.hc),h=0.5)
plot(clusters$lower[[1]])
#
# verify similarities
#
d1[c(128,137),]
#
# these customers have quite similar attributes
#
# if two customers are chosen from different clusters, it is likely they 
# would have different attributes
#
# cluster assignments
#
counts = cutree(seg.hc,k=5)
head(counts)
#
# count customers per cluster
#
table(counts)
#
# find averages by clusters
seg.summ(d1,counts)
#
# add assignments to the dataframe
#
d1$assignments = cutree(seg.hc,k=5)
head(d1)
#
# verify cluster 5
#
d3 = d1[d1$assignments==5,]
d3
#
# clusplot
#
# convert categorical into numeric cols
#
d4 = sapply(d1,as.numeric)
#
# sapply creates a matrix
#
dim(d4)
head(d4)
d5 = data.frame(d4)
str(d5)
#
# plot
#
clusplot(d5,d5$assignments,lines=0,color=T,shade=T,labels=4,cex=0.5)























