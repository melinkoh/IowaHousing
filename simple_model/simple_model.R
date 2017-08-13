# Go to the directory for this model
setwd("simple_model")

# Load libraries. If you do not have them installed, use install.packages to install them before running the code
library(moments)  # skewness

# Load the helper functions
source('../helper_fxn.R')

# Load the original data
train = read.csv('../data/train.csv');
test = read.csv('../data/test.csv');

# Define parameters for preprocessing
corr_thresh = .7;
skew_thresh = .75;
min_abs_corr = .3;

# Use the helper function, "transform", to do preprocessing
output <- transform(train,test,corr_thresh,skew_thresh,min_abs_corr);
train <- attr(output,"train");
test <- attr(output,"test");
highCor <- attr(output,"highCor");

# Create a multiple linear regression model
mlr = lm(SalePrice ~ ., data = train[, names(train) %in% c('SalePrice',names(highCor))])

# Use the model to make predictions for the test data
yHat = predict(mlr, newdata = test);
yHat = exp(yHat) - 1;

# Write the predictions to a file
submission = read.csv('../sample_submission.csv')
submission$SalePrice = yHat
write.table(submission, 'prediction.csv', row.names = FALSE, sep = ',')

# Change the directory back to the main directory
setwd("..")
