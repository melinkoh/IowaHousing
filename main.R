#load libraries, though error if don't exist:
library(leaps)  # regsubsets
library(glmnet)  # glmnet for lasso and ridge
library(moments)  # skewness
library(corrplot)  # corrplot
library(pls)  
library(gbm)  #gbm for random forest

rm(list=ls()) #remove all variables from workspace

source("simple_model.R")

source("lasso.R")