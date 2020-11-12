# cattree.r
RNGkind(sample.kind = 'Rounding')
library(tree)     # tree() cv.tree()
library(ISLR)     # data set

d0=Carseats
str(d0)
? Carseats
# Education is the average education (years) in the local population 
# 
# there are 10 predictors, some categorical
n = nrow(d0)

# create categorical response
high=ifelse(d0$Sales<=8,"No","Yes")
d1=data.frame(d0,high)

# tree - 2 predictors, full dataset
#=================================================================
tree0=tree(high~Price+Advertising,d1)

# scatterplot on predictors space (Price~Advertising does not work?)
plot(Advertising~Price,d1,pch=19,cex=0.6,col="red")
# regions and predicted category
partition.tree(tree0,add = T,col="blue")
#
# tree plot
plot(tree0)
text(tree0,cex=0.75)
#
# Combining plot and tree diagram, we conclude
#
# If price < $92.5 store is High Sales
# If price > $136.5 store is Low Sales
# If $92.5 < price < $136.5 store is High Sales if Advertising > $6.5
#
#
#
#
# full model -Sales
#=================================================================
tree1=tree(high~.-Sales,d1)
summary(tree1)
#
# This is a large tree with 27 regions
#
# Total deviance 170.7 is sum of deviances of terminal nodes
#   with 400-27 = 373 dof
 
# misclassifications
ypred = predict(tree1,d1,type="class") 
table(ypred,d1$high)   

# there are 36 misclassified obs
# training error rate 36/400 = 0.09  
 
names(tree1)

dim(tree1$frame)   # [1] 53  6
head(tree1$frame)
tail(tree1$frame)

# Factor ShelveLoc is most important classifier
# <leaf> rows are terminal nodes

plot(tree1)
text(tree1,cex=0.6,pretty=0)   # pretty shows class names on tree
title("Tree from the full dataset")

# Bad, medium is the left-hand branch
# 1st branch differentiates good locations from bad & medium

# training and test sets
#========================================================================
set.seed(2)
n = 1:nrow(d1)
train=sample(n, 200)   
d1.test=d1[-train,]      # test set with response
y.test=high[-train]   # response in test set

# training model
tree2=tree(high~.-Sales,d1,subset=train)

summary(tree2)
#
# Training accuracy rate is 90%
#
plot(tree2)
text(tree2,cex=0.6,pretty=0)   
title("Tree from the training set")

# test error rate 
pred2=predict(tree2,d1.test,type="class") 
# 
# use type="class" to get Yes,No predictions

table(pred2,y.test)

#
# out of 200 obs

aux=prop.table(table(pred2,y.test))
sum(diag(aux))    #    test accuracy rate

# CV on (mis)classification error rate
#========================================================================
set.seed(3)
tree3=cv.tree(tree2,FUN=prune.misclass)  # compare misclassifications

names(tree3)  
tree3$size        
tree3$dev         
#
# complexity parameter
#
round(tree3$k,2)  

# size values are n. terminal nodes
# dev is n. obs. misclassified  (the CV error rate)
# k is alpha = complexity parameter
# tree with 9 terminal nodes has lowest dev (CV error rate) 


# cv on deviance - to compare
#
tree4=cv.tree(tree2)
tree4$size            
round(tree4$dev,1)    
#
# did not work, since smallest deviance is for tree with one terminal node

# plot n. of misclassifications vs size, k
#
par(mfrow=c(1,2))
plot(tree3$dev~tree3$size,type="l");grid()
plot(tree3$dev~tree3$k,type="l");grid()
#
# smallest n. of misclassifications
# with 9 terminal nodes
# with k = 1.75

# use FUN=prune.misclass to
# prune training tree2 to 9 terminal nodes
prune9=prune.misclass(tree2,best=9)
par(mfrow=c(1,1))
plot(prune9)
text(prune9,cex=0.75,pretty=0)
title("CV optimized tree with 9 nodes")

# test error of the pruned tree
yhat9=predict(prune9,d1.test,type="class")
table(yhat9,y.test)
#

aux=prop.table(table(yhat9,y.test))
sum(diag(aux))    #[1] 0.77  test accuracy rate

summary(prune9)

