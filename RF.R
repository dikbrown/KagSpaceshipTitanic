library(randomForest)
library(rpart)

seed <- 42

set.seed(seed)
ind_var <- c(Passenger)
rfset <- train2[,c(2, #HomePlanet 
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

forest1 <- randomForest(factor(Transported) ~ .,
                        data = rfset,
                        ntree = 500,
                        mtry = 3,
                        importance = TRUE,
                        na.action = na.omit,
                        replace = FALSE)
