# Go to the directory for this model
setwd("lasso")

# Load libraries. If you do not have them installed, use install.packages to install them before running the code
library(glmnet)  # glmnet for lasso and ridge
library(moments)  # skewness
  
# Load the helper functions
source('../helper_fxn.R')

# Load the original data
train <- read.csv('../data/train.csv',header=T);
test <- read.csv('../data/test.csv',header=T);

# Define parameters for preprocessing
corr_thresh = 0;
skew_thresh = .75;
min_abs_corr = 0;

# Use the helper function, "transform", to do preprocessing
output <- transform(train,test,corr_thresh,skew_thresh,min_abs_corr);
train <- attr(output,"train");
test <- attr(output,"test");
highCor <- attr(output,"highCor");
length(highCor) == ncol(output) - 1;

# Convert the data frames to matrices
X = data.matrix(train[,-c(1,77)]) #remove columns ID and SalePrice
Y = data.matrix(train[77])
var.all= names(train)[-1]

# Use LASSO regularization with 10-fold cross-validation
cv.out = cv.glmnet(X, Y, alpha=1)  # lambda sequence set by glmnet

# Plot the CV error
plot(cv.out)

cv.out$lambda.min
cv.out$lambda.1se
mdl1min.coef=as.matrix(coef(cv.out, s="lambda.min"))
mdl1se.coef=as.matrix(coef(cv.out, s="lambda.1se"))

# View what variables are selected by LASSO
crit = 1e-8
rslt=sort(mdl1se.coef[abs(mdl1se.coef)>crit],decreasing=TRUE,index.return=TRUE)
var=rownames(mdl1se.coef)[unlist(as.matrix(rslt)[2])]
var

# Use the model to make predictions for the test data
Xtest = data.matrix(test[,-1])
ytest = predict(cv.out,newx=Xtest,s="lambda.1se")
ytest = exp(ytest) - 1

# Write the predictions to a file
submission = read.csv('../sample_prediction_file.csv')
submission$SalePrice = ytest
write.table(submission, 'prediction.csv', row.names = FALSE, sep = ',')

