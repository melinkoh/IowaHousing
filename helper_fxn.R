#helper function for transforming data:

transform <- function(train,test,corr_thresh,skew_thresh){
  
  output <- list();
  
  # Apply the given function (is.na) for each column (use 2 for column, and use 1 for row) in the matrix train[, -c(1, 81)].
  numNA = colSums(apply(train[, -c(1, 81)], 2, is.na))
  number_of_missing = numNA[which(numNA != 0)]  # variables with NA's and the numbers of NA's for each of them
  
  # Drop variables with a lot of NA's (>0.4 are NA's)
  drops = c("Alley", "PoolQC", "Fence", "MiscFeature", "FireplaceQU")
  train = train[ , !(names(train) %in% drops)]
  test = test[ , !(names(test) %in% drops)]
  
  # Find out the numerical variables and the categorical variables
  data.type = sapply(train[, -c(1, ncol(train))], class)  # data type for all variables except Id and SalePrice
  cat_var = names(train)[which(c(NA, data.type, NA) == 'factor')]  # categorical variables
  numeric_var =  names(train)[which(c(NA, data.type, NA) == 'integer')]  # numerical variables
  
  # For the categorical variables, add <NA> as a new level
  for (j in cat_var){
    train[, j] = addNA(train[, j])  
    test[, j] = addNA(test[, j])
  }
  
  # For the numerical variables with NA's, replace the NA's with medians
  numWithNA = number_of_missing[names(number_of_missing) %in% numeric_var]
  tempVar = names(numWithNA)
  print(tempVar)
  for (j in tempVar){
    
    na.id = is.na(train[,j])  # Find the NA values
    tempMedian = median(train[,j],na.rm=TRUE)  # find the median
    train[which(na.id),j] = tempMedian
    
    na.id = is.na(test[,j])
    tempMedian = median(test[,j],na.rm=TRUE)
    test[which(na.id),j] = tempMedian
    
  }
  
  
  
  # Replace the numerical values 
  #for (j in numeric_var){
  #  na.id = is.na(test[, j])
  #  if (!any(na.id)){
  #    next
  #  }
  #  test[which(na.id), j] = median(train[, j])
  #}
  
  # Apply log transform to the SalePrice column
  train$SalePrice <- log(train$SalePrice + 1 )
  
  # The original test data loaded from Kaggle does not contain SalePrice,
  #   but if the test data input for this function is obtained from splitting the original train data (for cross-validation)
  #   then the test data will have a SalePrice column, in which case we need to log-tranform it as well
  if("SalePrice" %in% names(test)){
    test$SalePrice <- log(test$SalePrice + 1 )
  }
  
  # For numeric features with excessive skewness (> skew_thresh), perform log transformation
  skewed_feats = sapply(train[, numeric_var], skewness)
  skewed_feats = numeric_var[which(skewed_feats > skew_thresh)]
  for(j in skewed_feats) {
    train[, j] = log(train[, j] + 1)
    test[, j] = log(test[, j] + 1)
  }
  
  # Obtain the correlation matrix 
  correlations = cor(train[, c(numeric_var, 'SalePrice')])  # correlation matrix
  
  # Pick the variables with high correlations with SalePrice (exceeding corr_thresh)
  highCor = which(abs(correlations[, ncol(correlations)]) > corr_thresh)
  highCor = highCor[-length(highCor)]
  names(highCor)
  
  # Put the updated train, test and highCor to the output list
  attr(output,'train') = train;
  attr(output,'test') = test;
  attr(output,'highCor') = highCor;
  print(class(output))
  
  return(output);
}


# Compute root mean squared error between x and y
RMSE <- function(x,y){
  a <- sqrt(sum((log(x)-log(y))^2)/length(y))
  return(a)
}
