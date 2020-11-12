# pcr.r

# install.packages("pls")  needed?
# library(pls)          not needed

library(dplyr)
library(caret)   # createDataPartition(), train()
library(MASS)    # Boston dataset
dim(Boston)
#
# 20% test sets
set.seed(123)
training.samples <- Boston$medv %>% createDataPartition(p = 0.8, list = FALSE)
head(training.samples)

train.data  <- Boston[training.samples, ]
test.data <- Boston[-training.samples, ]
dim(train.data)
dim(test.data)
head(test.data)

# pcr 
#
# fit 10 models
#
set.seed(1)
model <- train(medv~., data = train.data, 
               method = "pcr",
               scale = TRUE,
               trControl = trainControl("cv", number = 10),
               tuneLength = 10)
str(model)
#
model$results
#
# plot train RMSE vs different values of components
plot(model,main="Principal Components Regression")
#
# best tuning parameter ncomp that minimize the cross-validation error, RMSE
model$bestTune
#
# variance per model
summary(model$finalModel)
#
# variance explained in predictors (1st row) and in the response (2nd row)
#
# test performance
predictions = model %>% predict(test.data)
RMSE = caret::RMSE(predictions, test.data$medv)
Rsquare = caret::R2(predictions, test.data$medv)
d1 = data.frame(RMSE,Rsquare)
rownames(d1) = c('pcr')
d1
#
# pls
#
set.seed(1)
model <- train(medv~., data = train.data, 
               method = "pls",
               scale = TRUE,
               trControl = trainControl("cv", number = 10),
               tuneLength = 10)
model$results
#
# plot train RMSE vs different values of components
plot(model,main="Partial least Squares Regression")
#
# best tuning parameter ncomp that minimize the cross-validation error, RMSE
model$bestTune
#
# variance per model
summary(model$finalModel)
#
# variance explained in predictors (1st row) and in the response (2nd row)
#
# test performance
predictions = model %>% predict(test.data)
RMSE = caret::RMSE(predictions, test.data$medv)
Rsquare = caret::R2(predictions, test.data$medv)
d2 = data.frame(RMSE,Rsquare)
rownames(d2) = c('pls')
#
# compare models
d3 = rbind(d1,d2)
d3




