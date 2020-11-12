# bagging.r
# all 13 predictors should be considered at each split (mtry=p)

RNGkind(sample.kind = 'Rounding')
library(MASS)      # Boston dataset
library(randomForest)

dim(Boston)  
# response is medv
# p=13 predictors
#
n = nrow(Boston)
set.seed(1)           
train = sample(n,n/2)   # 253 train rows

# Bagging and Random Forests
#=================================================================
set.seed(1)
bag1=randomForest(medv~.,data=Boston,subset=train,mtry=13,importance = T)
#
# train performance
bag1
# train MSE shown as Mean of squared residuals
# p = 13 predictors 
# default is B=500 trees
# will use
# importance(bag1) to ask for the importance of predictors 

summary(bag1)
#
# 500 train MSEs

# times train obs was OOB
table(bag1$oob.times)
#
# compare predictions vs actual prices
#
head(bag1$predicted)
# actual values
head(bag1$y)
head(Boston[train,"medv"])
#

# test set performance
ytest=Boston[-train,"medv"]         # y values in test set
yhat = predict(bag1,newdata=Boston[-train,])

# residuals and  row numbers
res = ytest - yhat
a = rownames(as.matrix(yhat))   # as.matrix is required

# plot yhat vs y
plot(yhat~ytest,pch=19,cex=0.5,ylim=c(0,50))
abline(0,1)
grid()
text(yhat~ytest,labels=ifelse(res>5,a,""),pos=1,offset=0.25,cex=0.4)
# dots seem to cluster around 45 degree line

# MSPE
mean((yhat-ytest)^2)    # this value changes
# large improvement over single tree MSPE

# try B=25 bagged trees
bag2=randomForest(medv~.,data=Boston,subset=train,mtry=13,ntree=25)
yhat = predict(bag2,newdata=Boston[-train,])
mean((yhat-ytest)^2)    #  this value changes
#
# not much different than that with B=500 trees
#
#
# RANDOM FOREST (mtry < p) 
#
set.seed(1)
forest1=randomForest(medv~.,data=Boston,subset=train,mtry=6,importance=T)
#
forest1
#
# MSPE
yhat.rf = predict(forest1,newdata=Boston[-train,])
mean((yhat.rf-ytest)^2) 
# some improvement over bagging

# importance of each predictor
#
importance(forest1)
#
# IncMSE - avg increase in MSE when predictor is excluded from model
# IncNodePurity - avg increase in RSS from splits using this predictor

# plot these two columns - for convenience
varImpPlot(forest1,main="")
#
# rm and lstat most important predictors

