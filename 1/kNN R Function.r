## STAT318/462 kNN regression function

kNN <- function(k,x.train,y.train,x.pred) {
# 
## This is kNN regression function for problems with
## 1 predictor
#
## INPUTS
#
# k       = number of observations in nieghbourhood 
# x.train = vector of training predictor values
# y.train = vector of training response values
# x.pred  = vector of predictor inputs with unknown
#           response values 
#
## OUTPUT
#
# y.pred  = predicted response values for x.pred

## Initialize:
n.pred <- length(x.pred);		y.pred <- numeric(n.pred)

## Main Loop
for (i in 1:n.pred){
  d <- abs(x.train - x.pred[i])
  dstar = d[order(d)[k]]
  y.pred[i] <- mean(y.train[d <= dstar])		
}
## Return the vector of predictions
invisible(y.pred)
}