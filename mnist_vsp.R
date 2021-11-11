install.packages("remotes")
remotes::install_github("jlmelville/snedata")
library(snedata)
source("src.R")

mnist <- download_mnist()
show_digit(mnist[1,])

par(mfrow = c(5,5), mar = c(0,0,0,0),
    xaxt='n',
    yaxt='n',
    ann=FALSE)
for(i in 1:25) show_digit(mnist[i,])


Y = mnist



Y_r1000 = Y[sample(nrow(Y),1000),]
system.time({
  pca <- prcomp(Y_r1000[, 1:784], retx = TRUE, rank. = 10)
})

library(rARPACK)
system.time({
  s <- svds(as.matrix(Y_r1000[, 1:784]),k = 10)
})

# let's do a k = 30 SVD:
s <- svds(as.matrix(Y[, 1:784]),k = 30)
# this is the "Scree plot"
# we look for a gap or an elbow to pick k...
plot(s$d)
plot(s$d[-1])

k = 16

X = s$u[,1:k]
beta= s$v[,1:k]%*%diag(s$d[1:k])

#now each image has a feature vector of length 16
# they are kinda meaningless right now because we haven't yet made sense of them
# you could just put these into logistic regression, if you wanted to predit the labeling.

X[1,]
X[2,]

# However, I always want to make sense of things.
#  For that, we need a special sauce.
#  We want to find a k x k matrix that makes a lot of the feature values very close to zero.
#  **MAYBE** then each feature will indicate which number it is!

vm= varimax(X)
nice_x = X%*%vm$rotmat

# lev = rowSums(nice_x^2)
# plot(as.data.frame(nice_x[sample(60000, 1000, prob = lev[1:60000]),]), pch  =".")

nice_beta = beta%*% vm$rotmat

par(mfrow = c(4,4), mar = c(0,0,0,0),
    xaxt='n',
    yaxt='n',
    ann=FALSE)
for(i in 1:k) show_digit(nice_beta[,i])


# order_features = c(1,7,8,4,12,11,9,5,6,3,10,14,16,13,2,15)
# length(order_features)

(colMeans(nice_x[Y$Label==3,] )*1000) %>% round
