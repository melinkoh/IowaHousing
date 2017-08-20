# Regression Models for Iowa Housing Price Prediction
This is for predicting the housing prices in Ames, Iowa. The data sets can be downloaded from the [Kaggle page](https://www.kaggle.com/c/house-prices-advanced-regression-techniques):
Three models are used:
* A simple linear regression model using only variables that show high correlation with the sales price,
* A linear regression model using variables selected by LASSO 
* A gradient boosting model

The gradient boosting model gives the lowest RMSE: 0.127.

### How to use the code

The code is written in R. 
1. Save the repository to your local computer, for example, ``C:\users\myusername\Iowahousing``.
2. Create a folder ``data`` in the repository, and save the data files ``train.csv`` and ``test.csv`` there. 
3. To run any of the three models, open the corresponding R script in RStudio and run it. For example, if you want to run the simple model, open ``simple_model\simple_model.R``. 
4. The model predictions will be saved to ``prediction.csv`` after the model has finished running.

### Notes
* In the folder for each model, there is a file named with the model name, followed by ``_func.R``. This is where the model is defined in an R function
* ``helper_fxn.R`` defines several functions that can be used when building all the models, including function ``transform`` which does preprocessing of the raw data, and ``write_pred`` which writes the predicted house prices to a new data file
