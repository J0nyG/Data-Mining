## STAT318/462 Lab5: Decision Trees
#
# In this lab you will work through Section 8.3 of the course
# textbook, An Introduction to Statistical Learning (there is a
# link to this textbook on the Learn page). The R code from 
# Section 8.3 is given below. The rpart() R function is also 
# included as an alternative to tree().


# Chapter 8 Lab: Decision Trees

############## Fitting Classification Trees ##################

library(tree)
library(ISLR)
attach(Carseats)

# Turn into a classification problem (two class: High and Low)
High=ifelse(Sales<=8,"No","Yes")
Carseats1=data.frame(Carseats,High)

# Build a classification tree
tree.carseats=tree(High~.-Sales,Carseats1)
summary(tree.carseats)
plot(tree.carseats)
text(tree.carseats,pretty=0)
tree.carseats

# Estimate the accuracy of the tree
set.seed(1)
train=sample(1:nrow(Carseats1), 200)
Carseats.test=Carseats1[-train,]
High.test=High[-train]
tree.carseats=tree(High~.-Sales,Carseats1,subset=train)
tree.pred=predict(tree.carseats,Carseats.test,type="class")
table(tree.pred,High.test)
(98+56)/200

# Use cross validation to choose tree complexity
set.seed(3)
cv.carseats=cv.tree(tree.carseats,FUN=prune.misclass)
cv.carseats
plot(cv.carseats$size,cv.carseats$dev,type="b")

# Prune the tree
prune.carseats=prune.misclass(tree.carseats,best=6)
plot(prune.carseats)
text(prune.carseats,pretty=0)
tree.pred=predict(prune.carseats,Carseats.test,type="class")
table(tree.pred,High.test)
(94+54)/200

prune.carseats=prune.misclass(tree.carseats,best=5)
plot(prune.carseats)
text(prune.carseats,pretty=0)
tree.pred=predict(prune.carseats,Carseats.test,type="class")
table(tree.pred,High.test)
(92+56)/200
summary(prune.carseats)


## Using CART to solve this problem
library(rpart)
fit = rpart(High~.-Sales,method="class",data=Carseats1[train,])
#control=rpart.control(minsplit=2,cp=0)) 
summary(fit)
plot(fit)
text(fit,pretty=0)


#################### Fitting Regression Trees ################

library(MASS)
set.seed(1)
train = sample(1:nrow(Boston), nrow(Boston)/2)

# Grow the regression tree
tree.boston=tree(medv~.,Boston,subset=train)
summary(tree.boston)
plot(tree.boston)
text(tree.boston,pretty=0)

# Use cross validation to choose tree complexity
cv.boston=cv.tree(tree.boston)
plot(cv.boston$size,cv.boston$dev,type='b')
cv.boston

# Prune the tree
prune.boston=prune.tree(tree.boston,best=5)
plot(prune.boston)
text(prune.boston,pretty=0)

# Estimate the error of the tree
yhat=predict(tree.boston,newdata=Boston[-train,])
boston.test=Boston[-train,"medv"]
mean((yhat-boston.test)^2)

yhat=predict(prune.boston,newdata=Boston[-train,])
boston.test=Boston[-train,"medv"]
mean((yhat-boston.test)^2)


########## Bagging and Random Forests ########################

library(ISLR)
library(MASS)
library(randomForest)
set.seed(1)
train = sample(1:nrow(Boston), nrow(Boston)/2)


# Generate bagged trees
bag.boston=randomForest(medv~.,data=Boston,subset=train,mtry=13,importance=TRUE)
bag.boston
yhat.bag = predict(bag.boston,newdata=Boston[-train,])
boston.test=Boston[-train,"medv"]
plot(yhat.bag, boston.test)
abline(0,1)
mean((yhat.bag-boston.test)^2)

# Try increasing the number of trees
bag.boston=randomForest(medv~.,data=Boston,subset=train,mtry=13,ntree=1000)
yhat.bag = predict(bag.boston,newdata=Boston[-train,])
bag.boston
mean((yhat.bag-boston.test)^2)

# Try a random forest
set.seed(1)
rf.boston=randomForest(medv~.,data=Boston,subset=train,mtry=6,importance=TRUE)
yhat.rf = predict(rf.boston,newdata=Boston[-train,])
mean((yhat.rf-boston.test)^2)
importance(rf.boston)
varImpPlot(rf.boston)


############## Boosting ###################################


library(gbm)
set.seed(1)
boost.boston=gbm(medv~.,data=Boston[train,],distribution="gaussian",n.trees=5000,interaction.depth=4)
summary(boost.boston)
yhat.boost=predict(boost.boston,newdata=Boston[-train,],n.trees=5000)
mean((yhat.boost-boston.test)^2)

# change the shrinkage factor and tree depth
boost.boston=gbm(medv~.,data=Boston[train,],distribution="gaussian",n.trees=5000,interaction.depth=4,shrinkage=0.01)
yhat.boost=predict(boost.boston,newdata=Boston[-train,],n.trees=5000)
mean((yhat.boost-boston.test)^2)





