library(randomForest)
library(rpart)
###results of modeling @ https://docs.google.com/spreadsheets/d/1Yviru268eUQLLOVwfKBhv0N97o0-hcEtdG8N7BKmOTg/edit#gid=0

seed <- 42

set.seed(seed)
 
rfset <- train[,c(2, #HomePlanet 
                  3, #CryoSleep
                  4, #Destination
                  5, #Age
                  6, #VIP
                  7, #RoomService
                  8, #FoodCourt
                  9, #ShoppingMall
                  10, #Spa
                  11, #VRDeck
                  14, #deck
                  15, #room_num
                  16, #side - (S)tarboard or (P)ort
                  18, #grp_size - number of members in group
                  13 #Transported - Target
                  )]
set.seed(seed)
forest1 <- randomForest(factor(Transported) ~ .,
                        data = rfset,
                        ntree = 500,
                        mtry = 3,
                        importance = TRUE,
                        na.action = na.roughfix,
                        replace = FALSE)

rfpred <- predict(forest1, newdata = test2)

############
rfoutput <- data.frame(rfpred)

output <- data.frame(PassengerID = test$PassengerId, Transported = rfoutput$rfpred)

write.csv(output, "./sample_submission.csv", row.names = FALSE, quote = FALSE)

###
### Summary:
###
###   Split training data 80/20 into training and validation sets
###   Created 12 models on training data
###     Three sets of four, using varying number of trees and variables
###     Each set of models used a different set of independent variables
###     First set used all variables.
###     Second set removed VIP and side because of their low importance in first model
###     Third set also removed Destination, room number, and group size
###   From each set, chose the best-performing model and ran on the validation set
###   Chose the model that gave the best performance on the validation set. As it turns 
###       out, the best model was the first one I ran.
###
###   Results from model testing can be found at https://bit.ly/3Qv8eyH
###
