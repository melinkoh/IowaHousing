# Go to the directory for this model
setwd("gbm")

# Remove variables
rm(list=ls())

# Load libraries. If you do not have them installed, use install.packages to install them before running the code
library(gbm)

# Load the helper functions
source('../helper_fxn.R')
source('gbm_func.R')

# Load the original data
train = read.csv('../data/train.csv');
test = read.csv('../data/test.csv');

# Parameters for preprocessing
corr_thresh = 0;
skew_thresh = .75;

# Preprocess
datalist <- transform(train,test,corr_thresh,skew_thresh);

# Run simple model to make predictions for the test data
pred = gbm_func(datalist)

# Write the predictions to a file
write_pred('../sample_submission.csv','prediction.csv',pred)

# Change the directory back to the main directory
setwd("..")