gbm_func <- function(datalist){
  # The input "datalist" is a list generated from transform function, which does preprocessing of the data
  
  # Get training, test and high-correlation variables from "datalist"  
  train <- attr(datalist,"train");
  test <- attr(datalist,"test");
  
  # Build a GBM model
  current_model <- gbm(SalePrice ~., 
                           data = train[,-1], #remove ID column
                           distribution = "laplace",
                           shrinkage = 0.05,
                           interaction.depth = 5,
                           bag.fraction = 0.66,
                           n.minobsinnode = 1,
                           cv.folds = 100,
                           keep.data = F,
                           verbose = F,
                           n.trees = 1000);
  
  # Use the model to make predictions
  ytest = predict(current_model,newdata=test);
  ytest = exp(ytest) - 1;
  
  # Return the predictions for the test data
  return(ytest)

}