# boosting.r
RNGkind(sample.kind = 'Rounding')
library(MASS)      # Boston dataset
library(tree)      # tree()
library(gbm)       # gbm()
dim(Boston)
#
# response is medv
# p=13 predictors
n = nrow(Boston)
set.seed(1)
train = sample(1:n,n/2)   # 253 train rows
ytest = Boston[-train,'medv']

# single tree
tree1 = tree(medv~.,Boston,subset=train)
newval = Boston[-train,]
yhat1 = predict(tree1,newval)
# mspe
mean((ytest-yhat1)^2)

# boosted regression trees
#==============================================================================================
set.seed(1)
boost1=gbm(medv~.,data=Boston[train,],distribution="gaussian",
           n.trees=5000,interaction.depth=4)
#
boost1
# for categorical response use distribution="bernoulli"
# depth of each tree limited to 4 splits
# 5000 trees (default is 100 trees)
# interaction.depth is d
#
names(boost1)
#
# lambda -default value
boost1$shrinkage

# importance of predictors
summary(boost1)
grid()
#
# lstat and rm best predictors

# test MSPE
ytest=Boston[-train,"medv"]       # y values in test set
# 
# predict test set -n.trees is required
#
yhat.boost=predict(boost1,newdata=Boston[-train,],n.trees=5000)
mean((yhat.boost-ytest)^2)    
#
# little improvement over Random Forest

# plot to compare with single tree
bound = c(0,55)
plot(yhat1~ytest,pch=19,cex=0.6,col='red',ylim=bound,xlim=bound)
points(yhat.boost~ytest,pch=19,cex=0.6,col='blue')
grid()
#
# red - single tree predictions
# blue - boosted tree predictions
#
# 45-degree line
abline(0,1)
# arbitrary bounds
abline(6.5,1,lty=2,col='blue')
abline(-6.5,1,lty=2,col='blue')
# outside bounds 
# many single tree predictions (red)
# few boosted tree predictions (blue)
#

# Try lambda = 0.2   (shrinkage)
#
boost2=gbm(medv~.,data=Boston[train,],distribution="gaussian",
           n.trees=5000,interaction.depth=4,shrinkage=0.2,verbose=F)
yhat.boost=predict(boost2,newdata=Boston[-train,],n.trees=5000)
mean((yhat.boost-ytest)^2)
#
# not as good as default lambda





