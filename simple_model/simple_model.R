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
corr_thresh = .7;  # The threshold of correlations of variables with house price, above which the variable is kept
skew_thresh = .75;  # The threshold of skewness of variables, above which a log tranform is applied to the variable

# Use the helper function, "transform", to do preprocessing
output <- transform(train,test,corr_thresh,skew_thresh);
train <- attr(output,"train");
test <- attr(output,"test");
highCor <- attr(output,"highCor");

# Create a multiple linear regression model only considering features that show high correlation with sales price
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
