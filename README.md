# KagSpaceshipTitanic

First attempt at Spaceship Titanic Kaggle competition

I decided to use a random forest model, using most of the variables in the dataset.  
  Passenger name was not used at all  
  PassengerID contains a group number and the number within the group. I pulled the group number out so I could get group size. The group size was used as a predictive variable, but ID and group number were not.  
  The Cabin variable is in the format deck/room_number/side. This was separated into three separate variables, and the Cabin variable was deleted.

Missing values were imputed with na.roughfix, which replaces NAs with column medians (for numeric variables) or column modes (for categoric variables). For modes, ties are broken randomly.

The training dataset was split 80/20 into a training set and a validation set.  
  Twelve random forest models were created, in three sets of four  
    Each set of models used different numbers of trees (500-1000) and variables (3-4)  
    Different sets used different predictor variables. The first model used all predictor variables. The variables of lowest importance were removed from the second model (removed the two least important variables (VIP and side). The third model also removed destination, room number, and group size. Importance was determined by the model.  
    
From each set of models, the best model was used on the validation set. The model performing the best on the validation set was used to analyze the test set.  
      
    
