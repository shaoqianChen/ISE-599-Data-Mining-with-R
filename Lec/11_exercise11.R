# exercise1.r

# create dataset with two features (columns)
set.seed(2)
x = matrix(rnorm(50*2),ncol=2)
x[1:25,1] = x[1:25,1] + 3
x[1:25,2] = x[1:25,2] - 4
head(x)

# as dataframe
d0 = data.frame(x)
head(d0)

bb = c(-8,8)
plot(x,pch=20,ylim=bb,xlim=bb)
#
# K-means
#
# 2 clusters
#
km.out = kmeans(x,centers=2,nstart=20)
km.out
str(km.out)
# 
# clusters labels
km.out$cluster
#
# plot clusters
#
colors = km.out$cluster
class(colors)
plot(x,col=colors,pch=20,ylim=bb,xlim=bb,main='K-means with K=2')
#
# 3 clusters
#
set.seed(4)
km.out = kmeans(x,3,nstart=90)
colors = km.out$cluster
plot(x,col=colors,pch=20,ylim=bb,xlim=bb,main='K-means with K=3 clusters')
#
# total within cluster variation with k=3 clusters
km.out$tot.withinss
#
# elbow chart
#
n = nrow(d0)
set.seed(2)
TWCV = NULL
for (i in 2:n-1)
  {
    kmeans = kmeans(x,centers=i,nstart = 20)
    TWCV = c(TWCV,kmeans$tot.withinss)
  }
TWCV
plot(TWCV,type='l',xlab='K',ylab='Total within-cluster variation')
title('Elbow chart')
#
# I choose K=8
k = 4
kmeans = kmeans(x,centers=k,nstart = 20)
assignments = kmeans$cluster
d1 = d0
d1$cluster = assignments
d1
d2 = d1[order(d1$cluster),]
d2
colors = kmeans$cluster
plot(x,col=colors,pch=20,ylim=bb,xlim=bb,main='K-means with K=8 clusters',cex=1.5)
#



